/*
* File Name     : I2CSlave.v
*
* Creation Date : 07-22-2013
*
* Author        : Corey Olson
*
* Last Modified : Tue 23 Jul 2013 12:36:06 PM CDT
*
* Description   : This module is an I2C slave.  it simply handles the I2C
*                 transactions, and it interfaces to a simple memory map
*                 protocol (address, write data, read data, r/w bit)
*                 -we assume that frequency(clk) >> frequency(scl)
*                 -we assume most of this module is synchronous to clk
*
* Copyright     : 2013, Pico Computing, Inc.
*/
module I2CSlave #(
    parameter           I2C_ADR     = 0,// I2C device address
    parameter           ADDR_WIDTH  = 32,// width of the addresses accepted via the I2C bus
                                        // Note: each transfer on the I2C bus
                                        // is <= I2C_BITS bits, so it may take
                                        // multiple transfers to get the
                                        // entire address
    parameter           DATA_WIDTH  = 32// width of the data accepted via the I2C bus
                                        // Note: each transfer on the I2C bus
                                        // is <= I2C_BITS bits, so it may take
                                        // multiple transfers to get the
                                        // entire data
)
(
    input               scl_pad_i,      // SDA-line input
    output              scl_pad_o,      // SDA-line output (always 1'b0)
    output              scl_padoen_o,   // SDA-line output enable
    
    input               sda_pad_i,      // SDA-line input
    output              sda_pad_o,      // SDA-line output (always 1'b0)
    output              sda_padoen_o,   // SDA-line output enable

    input               clk,
    input               rst,
    output reg  [ADDR_WIDTH-1:0]  addr,
    output reg  [DATA_WIDTH-1:0]    write_data,
    output reg          read,
    output reg          write,
    input       [DATA_WIDTH-1:0]    read_data
);

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // number of bits in a standard I2C transaction
    // Note: these are the number of bits transmitted before we ACK the
    // transmission
    localparam          I2C_BITS            = 8;

    // this is the width of the data bus width in terms of bytes (rounded up
    // to the nearest byte)
    localparam          DATA_WIDTH_BYTES    = (DATA_WIDTH + 7) / 8;

    // these signals are used to synchronize the scl signal to the clk
    // domain and to detect rising edges on scl
    reg                 scl_1;
    reg                 scl_2;
    reg                 scl_3;
    reg                 scl_rising_edge;
    reg                 scl_falling_edge;

    // these signals are used to synchronize the sda signal to the clk
    // domain and to detect rising edges on sda
    reg                 sda_1;
    reg                 sda_2;
    reg                 sda_3;
    reg                 sda_rising_edge;
    reg                 sda_falling_edge;

    // these signals are used to detect start and stop conditions on the scl
    // and sda lines (synchronous to clk)
    reg                 start_condition;
    reg                 stop_condition;

    // this holds the accepted device ID
    // Note: we should ONLY respond if this matches the I2C_ADR parameter
    reg [6:0]           device_id_in;
    reg                 accept_device_id;
    reg                 i2c_read_writen_bit;

    // this holds the current address specified by the I2C bus
    // Note: with I2C, we can ONLY accept I2C_BITS bits of address before we must ACK
    //       so a single address may take multiple I2C_BITS-bit transfers to populate
    //       the address
    reg                 accept_address;
    reg [7:0]           address_bit_pos;
    reg                 clear_address_bit_pos;
    reg                 incr_address;

    // this holds the info for data that we are receiving from the I2C bus
    reg [7:0]           wdata_bit_pos;
    reg                 accept_write_data;
    reg                 clear_wdata_bit_pos;

    // this holds the data that we read from the parallel output debug bus
    // we use this register while sending read data back to the I2C bus
    reg [DATA_WIDTH-1:0]rdata;
    reg [7:0]           rdata_bit_pos;
    reg                 send_read_data;
    reg                 load_read_data;

    // this tracks the number of scl edges we have seen during a transfer
    reg [3:0]           scl_edge_cnt;
    reg                 clear_scl_edge_cnt;

    // we use these signals to control the SDA and SCL outputs
    // if we set these to 1, then the SDA/SCL line will be pulled high by the
    // pullup resistors
    // if we set these to 0, then the SDA/SCL line will be pulled low
    reg                 scl_padoen_n;
    reg                 sda_padoen_n;

    ///////////////
    // FUNCTIONS //
    ///////////////

    // we use this function to determine if the input address is within
    // a valid range or not
    function ValidAddress;
        input   [ADDR_WIDTH-1:0]    addr_in;
        begin
            ValidAddress = 1'b1;
        end
    endfunction

    /////////
    // FSM //
    /////////

    reg [13:0]           state;
    reg [13:0]           nextState;

    // states
    localparam  START           = 'h0001,
                START_EXIT      = 'h0002,
                DEVICE          = 'h0004,
                DEVICE_ACK      = 'h0008,
                ADDRESS         = 'h0010,
                ADDRESS_ACK     = 'h0020,
                RX_WRITE_DATA   = 'h0040,
                WRITE_ACK       = 'h0080,
                WRITE           = 'h0100,
                INCR_ADDRESS    = 'h0200,
                READ            = 'h0400,
                TX_READ_DATA    = 'h0800,
                READ_ACK        = 'h1000,
                STOP            = 'h2000;


    // state machine
    // Note: this feels like a hack, but it seems to be a simple way to detect
    // when we should go back to the START state
    always @ (posedge clk) begin
        if (rst || stop_condition) begin
            state   <= START;
        end else if (start_condition) begin
            state   <= START_EXIT;
        end else begin
            state   <= nextState;
        end
    end

    // next state logic
    always @ (*) begin

        accept_device_id        = 0;

        accept_address          = 0;
        clear_address_bit_pos   = 0;
        incr_address            = 0;
        
        accept_write_data       = 0;
        clear_wdata_bit_pos     = 0;
        write                   = 0;
        
        read                    = 0;
        send_read_data          = 0;

        clear_scl_edge_cnt      = 0;
        
        scl_padoen_n            = 1;
        sda_padoen_n            = 1;

        nextState               = state;

        case (state)
            // here we wait for a start condition
            // must see a start condition before moving on
            // we also clear the SCL edge counter
            START: begin
                if (start_condition) begin
                    nextState = START_EXIT;
                end
            end
            // this is just a state that we should enter whenever we see
            // a start or a restart condition
            // Note: we just want to clear the scl edge count really
            START_EXIT: begin
                clear_scl_edge_cnt = 1;
                nextState = DEVICE;
            end
            // we accept a device ID from the I2C bus
            // if the accepted device ID matches ours, we ACK that device ID
            // Note: we assume this state is entered shortly after a start
            // condition, which means the SCL line is probably still high
            DEVICE: begin
                accept_device_id = 1;
                if ((scl_edge_cnt == I2C_BITS) && scl_falling_edge) begin
                    nextState = DEVICE_ACK;
                end
            end
            // we ack the device ID if it matches our device ID
            // if it does not match our device ID, go back to the start state
            // so we can wait for another device ID
            // Note: this state is entered just after the falling edge of SCL
            DEVICE_ACK: begin
                clear_scl_edge_cnt = 1;
                // if the device ID does not match, just go back to the start
                // state
                if (device_id_in != I2C_ADR) begin
                    nextState = START;
                end 
                // else the device ID must match, so ACK the device ID
                else begin
                    sda_padoen_n = 0;
                    // must hold SDA low until the falling edge of SCL
                    if (scl_falling_edge) begin
                        // the i2c_read_writen bit determines if we are doing
                        // a read or a write on the I2C bus
                        if (i2c_read_writen_bit) begin
                            nextState = READ;
                        end else begin
                            nextState = ADDRESS;
                        end
                    end
                end
            end
            // accept the register address I2C bus
            // -when doing a write, we ALWAYS get the address first
            // -after the I2C address is sent, we can either receive some write
            // data from the I2C bus, or we will see a restart condition,
            // which means we will probably do an I2C read
            // Note: this state is entered just after the falling edge of SCL
            ADDRESS: begin
                accept_address = 1;
                clear_wdata_bit_pos = 1;
                if ((scl_edge_cnt == I2C_BITS) && scl_falling_edge) begin
                    nextState = ADDRESS_ACK;
                end
            end
            // we know this address is meant for our device, so we ack the
            // address if it is valid
            // if this is not a valid address, then we do not ack it, and we
            // go back to the START state
            // Note: this state is entered just after the falling edge of SCL
            ADDRESS_ACK: begin
                clear_scl_edge_cnt = 1;
                // if this was not a valid address, then go back to the START
                // state without ACK'ing the address
                if (!ValidAddress(addr)) begin
                    nextState = START;
                end 
                // else this was a valid address, so ACK it
                // Note: must hold the ACK until the falling edge of SCL
                else begin
                    sda_padoen_n = 0;
                    if (scl_falling_edge) begin
                        // if we have received all the address bits, then we
                        // move onto the RX_WRITE_DATA state
                        if (address_bit_pos == ADDR_WIDTH) begin
                            nextState = RX_WRITE_DATA;
                        end
                        // if we have more address bits to receive, then go back to
                        // the ADDRESS state
                        else begin
                            nextState = ADDRESS;
                        end
                    end
                end
            end
            // we have received the proper device ID and a valid address, we
            // are now about to either do a write, or we just set the address
            // for the I2C read (in which case we will probably see a restart
            // condition)
            // Note: we detect restart conditions in the FSM (always block for
            // the state register), so we don't have to worry about detecting
            // a start condition here
            // Note: this state is entered just after the falling edge of SCL
            RX_WRITE_DATA: begin
                accept_write_data = 1;
                clear_address_bit_pos = 1;
                // if we start seeing some valid data, then we shove it into
                // our data register
                if ((scl_edge_cnt == I2C_BITS) && scl_falling_edge) begin
                    nextState = WRITE_ACK;
                end
            end
            // in this state, we ACK the write data
            // -we also detect if we have received all the write data that we
            // are expecting for this register
            // -if we have received all the data for this register, we move to
            // a new state that conditionally increments the address in the
            // event that we are writing > DATA_WIDTH bits to sequential
            // addresses over the I2C bus
            // Note: this state is entered just after the falling edge of SCL
            WRITE_ACK: begin
                clear_scl_edge_cnt = 1;
                // ack the I2C_BITS of write data that we have received
                sda_padoen_n = 0;
                if (scl_falling_edge) begin
                    // if we have received all the address bits, then we
                    // move onto the WRITE state
                    if (wdata_bit_pos == DATA_WIDTH) begin
                        nextState = WRITE;
                    end
                    // if we have more data bits to receive, then go back to
                    // the WRITE state
                    else begin
                        nextState = RX_WRITE_DATA;
                    end
                end
            end
            // in this state, we assert the write signal
            // this will initiate the write to the parallel output bus using
            // the data in the write_data register and the address in the addr
            // register
            // Note: this state is entered just after the falling edge of SCL
            WRITE: begin
                write = 1;
                nextState = INCR_ADDRESS;
            end
            // in this state, we conditionally increment the address
            // Note: we only increment the address if it seems that we are
            // going to be accepting more write data from the I2C bus, or if
            // we are going to be sending more read data on the I2C bus
            // Note: this state is entered just after the falling edge of SCL
            INCR_ADDRESS: begin
                incr_address = 1;
                // if this is doing a read, then we should increment 
                // the address and issue another read command
                if (i2c_read_writen_bit) begin
                   nextState = READ; 
                end
                // if this is doing a write, then we should receive some
                // more write data
                else begin
                    nextState = RX_WRITE_DATA;
                end
            end
            // now we have setup a stable read address, so we just need to
            // issue a read command to the parallel bus before sending that
            // read data back to the downstream logic
            // Note: we assume the read data will be returned to us on the
            // read_data port with a 1 cycle latency from when we issue this
            // read command
            // Note: this state is entered just after the falling edge of SCL
            READ: begin
                read = 1;
                nextState = TX_READ_DATA;
            end
            // in this state, we have previously issued a read to the parallel
            // output bus, and we have placed that read data into our rdata
            // register.  we should therefore drive the SDA line with the MSb
            // of that rdata register
            // Note: this state is entered just after the falling edge of SCL
            TX_READ_DATA: begin
                // drive the SDA line with the MSb of the read data
                sda_padoen_n = rdata[DATA_WIDTH-1];
                send_read_data = 1;

                if (scl_falling_edge) begin
                    // check if we have sent I2C_BITS worth of data
                    // if so, we must check for an ACK
                    if (scl_edge_cnt == I2C_BITS) begin
                        nextState = READ_ACK;
                    end
                end
            end
            // in this state, we are checking for an ACK from the I2C master
            // on the positive edge of SCL, if the SDA line is low, then the
            // I2C master ACK'd the read, so we should keep sending more read
            // data
            // Note: if we have sent DATA_WIDTH bits, we should go to the
            // INCR_ADDRESS state followed by the READ state, so we can read
            // the next register before sending that data out on the I2C bus
            // Note: this state is entered just after the falling edge of SCL
            READ_ACK: begin
                clear_scl_edge_cnt = 1;

                // check for the ACK from the I2C master
                // if the master did NOT ACK, then we are done reading
                if (scl_rising_edge && sda_3) begin
                    nextState = STOP;
                end else if (scl_falling_edge) begin
                    // if the master DID ACK and we have sent all the read
                    // data in the rdata register, then we should increment
                    // the address, read the next register, and send out that
                    // read data
                    if (rdata_bit_pos == DATA_WIDTH) begin
                        nextState = INCR_ADDRESS;
                    end
                    // if the master DID ACK and we have not sent all the read
                    // data in the rdata register, we should continue sending
                    // that read data
                    else begin
                        nextState = TX_READ_DATA;
                    end
                end
            end
            // just waiting for a stop condition in this state
            STOP: begin
                if (stop_condition) begin
                    nextState = START;
                end
            end
        endcase
    end

    ////////////////
    // SIDE LOGIC //
    ////////////////
    
    // the SCL and SDA outputs should always be 0, we just enable them
    // sometimes
    assign scl_pad_o = 1'b0;
    assign sda_pad_o = 1'b0;
    assign scl_padoen_o = ~scl_padoen_n;
    assign sda_padoen_o = ~sda_padoen_n;

    // synchronize scl and sda to the clk
    always @ (posedge clk) begin
        scl_1   <= scl_pad_i;
        scl_2   <= scl_1;
        scl_3   <= scl_2;
        sda_1   <= sda_pad_i;
        sda_2   <= sda_1;
        sda_3   <= sda_2;
    end

    // detect rising and falling edges on scl and sda
    always @ (posedge clk) begin
        scl_rising_edge     <= ~scl_3 &  scl_2;
        scl_falling_edge    <=  scl_3 & ~scl_2;
        sda_rising_edge     <= ~sda_3 &  sda_2;
        sda_falling_edge    <=  sda_3 & ~sda_2;
    end
    
    // detect start and stop conditions
    always @ (posedge clk) begin
        start_condition <= sda_falling_edge & scl_3;
        stop_condition  <= sda_rising_edge  & scl_3;
    end

    // track the number of SCL edges for an I2C_BITS-bit transfer on the I2C bus
    always @ (posedge clk) begin
        if (rst || clear_scl_edge_cnt) begin
            scl_edge_cnt    <= 0;
        end else if (scl_rising_edge) begin
            scl_edge_cnt    <= scl_edge_cnt + 4'h1;
        end
    end

    // register the device ID and the R/W bit from the I2C bus
    // Note: don't worry if we are not perfectly synchronized between the scl
    // rising edge and the sda bit, because we assume the I2C bus is slooooow
    always @ (posedge clk) begin
        if (scl_rising_edge && accept_device_id) begin
            device_id_in        <= {device_id_in[5:0],i2c_read_writen_bit};
            i2c_read_writen_bit <= sda_3;
        end
    end

    // accept the address from the I2C bus
    // Note: don't worry if we are not perfectly synchronized between the scl
    // rising edge and the sda bit, because we assume the I2C bus is slooooow
    // Note: we increment by the width of the data bus because this is
    // a byte-addressable bus
    always @ (posedge clk) begin
        if (rst || clear_address_bit_pos) begin
            address_bit_pos <= 0;
        end else if (scl_rising_edge && accept_address) begin
            addr            <= {addr[ADDR_WIDTH-2:0], sda_3};
            address_bit_pos <= address_bit_pos + 8'h1;
        end else if (incr_address) begin
            addr            <= addr + DATA_WIDTH_BYTES;
        end
    end
    
    // accept the data from the I2C bus
    // Note: don't worry if we are not perfectly synchronized between the scl
    // rising edge and the sda bit, because we assume the I2C bus is slooooow
    always @ (posedge clk) begin
        if (rst || clear_wdata_bit_pos) begin
            wdata_bit_pos   <= 0;
        end else if (scl_rising_edge && accept_write_data) begin
            write_data      <= {write_data[DATA_WIDTH-2:0], sda_3};
            wdata_bit_pos   <= wdata_bit_pos + 8'h1;
        end
    end

    // this register stores the data that we read via the output bus (debug
    // bus).  we parallel-load this read data register by asserting an address
    // and a read signal.  we then grab the data from the read_data input on
    // the following clock cycle
    always @ (posedge clk) begin
        if (rst || load_read_data) begin
            rdata_bit_pos   <= 0;
            rdata           <= read_data;
        end else if (scl_falling_edge && send_read_data) begin
            rdata_bit_pos   <= rdata_bit_pos + 8'h1;
            rdata           <= rdata << 1;
        end
        load_read_data      <= read;
    end
    
    ///////////
    // DEBUG //
    ///////////

    // some debugging messages
    always @ (posedge clk) begin
        if (start_condition)    $display("%t: Start Condition detected", $realtime);
        if (stop_condition)     $display("%t: Stop Condition detected", $realtime);
    end

endmodule


module hmc_i2c (
	input clk,
	inout scl,
	inout sda
);

wire [510:0] source, probe;
sourceprobe sourceprobe (
	.source(source),
	.probe(probe)
);

wire scl_pad_i, scl_pad_o, scl_padoen_o;
wire sda_pad_i, sda_pad_o, sda_padoen_o;
wire rst;
wire [31:0] addr;
wire [31:0] write_data;
reg  [31:0] read_data = 0;
wire read, write;

I2CSlave #(
    .I2C_ADR(0),
    .ADDR_WIDTH(32),
    .DATA_WIDTH(32)
) I2CSlave (
    .scl_pad_i(scl_pad_i),
    .scl_pad_o(scl_pad_o),
    .scl_padoen_o(scl_padoen_o),
    .sda_pad_i(sda_pad_i),
    .sda_pad_o(sda_pad_o),
    .sda_padoen_o(sda_padoen_o),
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .write_data(write_data),
    .read(read),
    .write(write),
    .read_data(read_data)
);

wire [31:0] enable_addr = source[32:1];
wire [31:0] enable_rd_data = source[64:33];
reg  [31:0] enable_wr_data = 0;

assign scl = scl_padoen_o ? scl_pad_o : 1'bz;
assign scl_pad_i = scl;
assign sda = sda_padoen_o ? sda_pad_o : 1'bz;
assign sda_pad_i = sda;
assign rst = source[0];
assign probe[31:0] = addr;
assign probe[63:32] = write_data;
assign probe[64] = read;
assign probe[65] = write;
assign probe[66] = scl_pad_i;
assign probe[67] = scl_pad_o;
assign probe[68] = scl_padoen_o;
assign probe[69] = sda_pad_i;
assign probe[70] = sda_pad_o;
assign probe[71] = sda_padoen_o;
assign probe[103:72] = enable_wr_data;

always @(posedge clk) begin
	if((addr == enable_addr) & read)
		read_data <= enable_rd_data;
	else
		read_data <= 32'h0;

	if((addr == enable_addr) & write)
		enable_wr_data <= write_data;
end

endmodule
