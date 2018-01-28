// PicoFramework.v
// This is the toplevel of Pico firmware framework for the Virtex-6 PCIe cards. (501,503,E18, etc.)
// Based on some defines, like PICO_MODEL_* and PICO_FPGA_*, this changes its module name and instantiated PCIe core.
// Copyright 2009, Pico Computing, Inc.

`include "PicoDefines.v"

`ifdef PICO_MODEL_M501
  `ifdef PICO_FPGA_LX195T
    module PicoFrameworkM501_LX195T1
  `elsif PICO_FPGA_LX240T
    module PicoFrameworkM501_LX240T2
  `endif
`elsif PICO_MODEL_M503
	`ifdef PICO_FPGA_LX240T
	 module PicoFrameworkM503_LX240T2
	`elsif PICO_FPGA_SX315T
	 module PicoFrameworkM503_SX315T2
	`elsif PICO_FPGA_LX550T
	 module PicoFrameworkM503_LX550T2
	`elsif PICO_FPGA_LX550T_1
	 module PicoFrameworkM503_LX550T1
	`endif // PICO_FPGA_LX240T
`elsif PICO_MODEL_M505
  `ifdef PICO_FPGA_LX325T
    module PicoFrameworkM505_LX325T1
  `elsif PICO_FPGA_LX160T
    module PicoFrameworkM505_LX160T1
  `elsif PICO_FPGA_LX410T
    module PicoFrameworkM505_LX410T1
  `endif
`elsif PICO_MODEL_M506
    module PicoFrameworkM506_A3
`elsif PICO_MODEL_EX800
     `ifdef PICO_FPGA_A9
    module PicoFrameworkEX800_A9
    `elsif PICO_FPGA_A7
    module PicoFrameworkEX800_A7
    `endif
`elsif PICO_MODEL_M510
    module PicoFrameworkM510_KU060
`elsif PICO_MODEL_EX600
  `ifdef PICO_FPGA_SX315T
    module PicoFrameworkEX600_SX315T2
  `endif
`endif
# (
  parameter PCIE_EXT_CLK      = "TRUE",  // Use External Clocking Module
  parameter C_DATA_WIDTH = 128,            // RX/TX interface data width
  // Do not override parameters below this line
  parameter STRB_WIDTH = C_DATA_WIDTH / 8,               // TSTRB width
  parameter KEEP_WIDTH        = C_DATA_WIDTH / 8 // TSTRB width
)
  (
    `ifndef PICO_MODEL_M503
        `ifndef PICO_MODEL_EX600
            // flash
            input flash_busy,
            output flash_byte,
            output flash_ce,
            output flash_oe,
            output flash_reset,
            output flash_we,
            //output flash_wp,
            output reg [25:0] flash_a,
            inout [15:0] flash_d,
        `endif //PICO_MODEL_EX600
    `endif //PICO_MODEL_M503
    
    // stream signals we're taking to the toplevel for the user
    output                      s_clk,
    output                      s_rst,
    
    output                      s_out_en,
    output         [8:0]        s_out_id,
    input     [127:0]           s_out_data,
    
    output                      s_in_valid,
    output [8:0]                s_in_id,
    output [127:0]              s_in_data,
    
    output       [8:0]          s_poll_id,
    input      [31:0]           s_poll_seq,
    input      [127:0]          s_poll_next_desc,
    input                       s_poll_next_desc_valid,
    
    output          [8:0]       s_next_desc_rd_id,
    output                      s_next_desc_rd_en,

    input  [7:0]                UserPBWidth,
  
    // user-direct writes
    input [127:0]               user_pci_wr_q_data,
    input                       user_pci_wr_q_valid,
    output                      user_pci_wr_q_en,

    input [127:0]               user_pci_wr_data_q_data,
    input                       user_pci_wr_data_q_valid,
    output                      user_pci_wr_data_q_en,
    
    output                      direct_rx_valid,
    
    `ifdef SIMULATION
    input                         user_clk,
    input                         user_reset,
    input                         user_lnk_up,

    // Tx
    input  [5:0]                  tx_buf_av,
    input                         tx_cfg_req,
    input                         tx_err_drop,
    output                        tx_cfg_gnt,

    input                         s_axis_tx_tready,
    output  [C_DATA_WIDTH-1:0]    s_axis_tx_tdata,
    output  [STRB_WIDTH-1:0]      s_axis_tx_tstrb,
    output  [3:0]                 s_axis_tx_tuser,
    output                        s_axis_tx_tlast,
    output                        s_axis_tx_tvalid,

    // Rx
    output                        rx_np_ok,
    input  [C_DATA_WIDTH-1:0]     m_axis_rx_tdata,
    input  [STRB_WIDTH-1:0]       m_axis_rx_tstrb,
    input                         m_axis_rx_tlast,
    input                         m_axis_rx_tvalid,
    output                        m_axis_rx_tready,
    input  [21:0]                 m_axis_rx_tuser,

    // Flow Control
    input  [11:0]                 fc_cpld,
    input  [7:0]                  fc_cplh,
    input  [11:0]                 fc_npd,
    input  [7:0]                  fc_nph,
    input  [11:0]                 fc_pd,
    input  [7:0]                  fc_ph,
    output [2:0]                  fc_sel,
    `else //!SIMULATION
    output  [7:0]    pci_exp_txp,
    output  [7:0]    pci_exp_txn,
    input   [7:0]    pci_exp_rxp,
    input   [7:0]    pci_exp_rxn,
    `endif
    
    input  extra_clk_p,
    input  extra_clk_n,
    output extra_clk,

    input                                        sys_clk_p,
    input                                        sys_clk_n,
    input                                        sys_reset_n,

    // temperature output from the System Monitor
    output  [9:0]                   temp
);

  localparam        PL_FAST_TRAIN	        = "FALSE";

`ifndef SIMULATION
  wire                                        user_clk;
  wire                                        user_half_clk;
  wire                                        user_reset;
  wire                                        user_lnk_up;

  // Tx
  wire [5:0]                                  tx_buf_av;
  wire                                        tx_cfg_req;
  wire                                        tx_err_drop;
  wire                                        tx_cfg_gnt;
  wire                                        s_axis_tx_tready;
  wire [3:0]                                  s_axis_tx_tuser;
  wire [C_DATA_WIDTH-1:0]                     s_axis_tx_tdata;
  wire [STRB_WIDTH-1:0]                       s_axis_tx_tstrb;
  wire                                        s_axis_tx_tlast;
  wire                                        s_axis_tx_tvalid;


  // Rx
  wire [C_DATA_WIDTH-1:0]                     m_axis_rx_tdata;
  wire [STRB_WIDTH-1:0]                       m_axis_rx_tstrb;
  wire                                        m_axis_rx_tlast;
  wire                                        m_axis_rx_tvalid;
  wire                                        m_axis_rx_tready;
  wire  [21:0]                                m_axis_rx_tuser;
  wire                                        rx_np_ok;

  // Flow Control
  wire [11:0]                                 fc_cpld;
  wire [7:0]                                  fc_cplh;
  wire [11:0]                                 fc_npd;
  wire [7:0]                                  fc_nph;
  wire [11:0]                                 fc_pd;
  wire [7:0]                                  fc_ph;
  wire [2:0]                                  fc_sel;
  
 //TX
  wire                                        v6_s_axis_tx_tready;
  wire [63:0]                                 v6_s_axis_tx_tdata;
  wire [7:0]                                  v6_s_axis_tx_tstrb;
  wire [3:0]                                  v6_s_axis_tx_tuser;
  wire                                        v6_s_axis_tx_tlast;
  wire                                        v6_s_axis_tx_tvalid;
  // Rx
  wire [63:0]                                 v6_m_axis_rx_tdata;
  wire [7:0]                                  v6_m_axis_rx_tstrb;
  wire                                        v6_m_axis_rx_tlast;
  wire                                        v6_m_axis_rx_tvalid;
  wire                                        v6_m_axis_rx_tready;
  wire [21:0]                                 v6_m_axis_rx_tuser;
  
  wire [43:0]                                 M00_AXIS_TUSER;
  wire [7:0]                                  M01_AXIS_TUSER;
`endif //!SIMULATION


  //-------------------------------------------------------
  // 3. Configuration (CFG) Interface
  //-------------------------------------------------------

  wire [31:0]                                 cfg_do;
  wire                                        cfg_rd_wr_done;
  wire  [31:0]                                cfg_di;
  wire   [3:0]                                cfg_byte_en;
  wire   [9:0]                                cfg_dwaddr;
  wire                                        cfg_wr_en;
  wire                                        cfg_rd_en;

  wire                                        cfg_err_cor;
  wire                                        cfg_err_ur;
  wire                                        cfg_err_ecrc;
  wire                                        cfg_err_cpl_timeout;
  wire                                        cfg_err_cpl_abort;
  wire                                        cfg_err_cpl_unexpect;
  wire                                        cfg_err_posted;
  wire                                        cfg_err_locked;
  wire [47:0]                                 cfg_err_tlp_cpl_header;
  wire                                        cfg_err_cpl_rdy;
  wire                                        cfg_interrupt;
  wire                                        cfg_interrupt_rdy;
  wire                                        cfg_interrupt_assert;
  wire [7:0]                                  cfg_interrupt_di;
  wire [7:0]                                  cfg_interrupt_do;
  wire [2:0]                                  cfg_interrupt_mmenable;
  wire                                        cfg_interrupt_msienable;
  wire                                        cfg_interrupt_msixenable;
  wire                                        cfg_interrupt_msixfm;
  wire                                        cfg_turnoff_ok;
  wire                                        cfg_to_turnoff;
  wire                                        cfg_trn_pending;
  wire                                        cfg_pm_wake;
  wire  [7:0]                                 cfg_bus_number;
  wire  [4:0]                                 cfg_device_number;
  wire  [2:0]                                 cfg_function_number;
  wire [15:0]                                 cfg_status;
  wire [15:0]                                 cfg_command;
  wire [15:0]                                 cfg_dstatus;
  wire [15:0]                                 cfg_dcommand;
  wire [15:0]                                 cfg_lstatus;
  wire [15:0]                                 cfg_lcommand;
  wire [15:0]                                 cfg_dcommand2;
  wire  [2:0]                                 cfg_pcie_link_state;
  wire [63:0]                                 cfg_dsn;

  //-------------------------------------------------------
  // 4. Physical Layer Control and Status (PL) Interface
  //-------------------------------------------------------

  wire [2:0]                                  pl_initial_link_width;
  wire [1:0]                                  pl_lane_reversal_mode;
  wire                                        pl_link_gen2_capable;
  wire                                        pl_link_partner_gen2_supported;
  wire                                        pl_link_upcfg_capable;
  wire [5:0]                                  pl_ltssm_state;
  wire                                        pl_received_hot_rst;
  wire                                        pl_sel_link_rate;
  wire [1:0]                                  pl_sel_link_width;
  wire                                        pl_directed_link_auton;
  wire [1:0]                                  pl_directed_link_change;
  wire                                        pl_directed_link_speed;
  wire [1:0]                                  pl_directed_link_width;
  wire                                        pl_upstream_prefer_deemph;
  
  wire sys_clk_c;

  reg user_reset_q;
  reg user_reset_q_n;
  reg user_lnk_up_q;
  always @(posedge user_clk) begin
    user_reset_q <= user_reset;
    user_lnk_up_q <= user_lnk_up;
  end
  
  `ifdef PICO_MODEL_M505
  // Wires used for external clocking connectivity
  wire                                        PIPE_PCLK_IN;
  wire  [7:0]    PIPE_RXUSRCLK_IN;
  wire                                        PIPE_RXOUTCLK_IN;
  wire                                        PIPE_DCLK_IN;
  wire                                        PIPE_USERCLK1_IN;
  wire                                        PIPE_USERCLK2_IN;
  wire                                        PIPE_MMCM_LOCK_IN;
  wire                                        PIPE_OOBCLK_IN;

  wire                                        PIPE_TXOUTCLK_OUT;
  wire [7:0]     PIPE_RXOUTCLK_OUT;
  wire [7:0]     PIPE_PCLK_SEL_OUT;
  wire                                        PIPE_GEN3_OUT;
  
  localparam USER_CLK_FREQ = 4;
  localparam USER_CLK2_DIV2 = "TRUE";
  localparam USERCLK2_FREQ = (USER_CLK2_DIV2 == "TRUE") ? (USER_CLK_FREQ == 4) ? 3 : (USER_CLK_FREQ == 3) ? 2 : USER_CLK_FREQ
                                                                                   : USER_CLK_FREQ;
  
  // Generate External Clock Module if External Clocking is selected
  generate
    if (1) begin : ext_clk

      //---------- PIPE Clock Module -------------------------------------------------
      pcie_7x_v1_6_8lane_gen2_pipe_clock #
      (
          .PCIE_ASYNC_EN                  ( "FALSE" ),     // PCIe async enable
          .PCIE_TXBUF_EN                  ( "FALSE" ),     // PCIe TX buffer enable for Gen1/Gen2 only
          .PCIE_LANE                      ( 6'h08 ),     // PCIe number of lanes
          `ifdef SIMULATION                                // PCIe Link Speed
            .PCIE_LINK_SPEED              ( 2 ),
          `else
            .PCIE_LINK_SPEED              ( 3 ),
          `endif
          .PCIE_REFCLK_FREQ               ( 0 ),     // PCIe reference clock frequency
          .PCIE_USERCLK1_FREQ             ( USER_CLK_FREQ +1 ),     // PCIe user clock 1 frequency
          .PCIE_USERCLK2_FREQ             ( USERCLK2_FREQ +1 ),     // PCIe user clock 2 frequency
          .PCIE_DEBUG_MODE                ( 0 )
      )
      pipe_clock_i
      (

          //---------- Input -------------------------------------
          .CLK_CLK                        ( sys_clk_c ),
          .CLK_TXOUTCLK                   ( PIPE_TXOUTCLK_OUT ),     // Reference clock from lane 0
          .CLK_RXOUTCLK_IN                ( PIPE_RXOUTCLK_OUT ),
          .CLK_RST_N                      ( 1'b1 ),
          .CLK_PCLK_SEL                   ( PIPE_PCLK_SEL_OUT ),
          .CLK_GEN3                       ( PIPE_GEN3_OUT ),

          //---------- Output ------------------------------------
          .CLK_PCLK                       ( PIPE_PCLK_IN ),
          .CLK_RXUSRCLK                   ( PIPE_RXUSRCLK_IN ),
          .CLK_RXOUTCLK_OUT               ( PIPE_RXOUTCLK_IN ),
          .CLK_DCLK                       ( PIPE_DCLK_IN ),
          .CLK_OOBCLK                     ( PIPE_OOBCLK_IN ),
          .CLK_USERCLK1                   ( PIPE_USERCLK1_IN ),
          .CLK_USERCLK2                   ( PIPE_USERCLK2_IN ),
          .CLK_MMCM_LOCK                  ( PIPE_MMCM_LOCK_IN )

      );
    end
  endgenerate
  `endif // PICO_MODEL_M505
  
  wire flash_wp; // tied in hardware on the E18
`ifndef ALTERA_FPGA  
(* TIG = "TRUE" *) wire sys_reset_n_c_vio;
`ifndef PICO_MODEL_E18
(* TIG = "TRUE" *) wire sys_reset_n_c_por;
`else
(* TIG = "TRUE" *) (* KEEP = "TRUE" *) wire sys_reset_n_c_por;
assign sys_reset_n_c = sys_reset_n_c_por;
`endif //!PICO_MODEL_E18

IBUFGDS extra_clk_ibuf (.I(extra_clk_p), .IB(extra_clk_n), .O(extra_clk));
reg [3:0] extra_cnt; always @(posedge extra_clk) extra_cnt <= extra_cnt + 1;

    `ifndef XILINX_ULTRASCALE
        `ifdef PICO_MODEL_M505
        IBUFDS_GTE2 refclk_ibuf (.O(sys_clk_c), .ODIV2(), .I(sys_clk_p), .IB(sys_clk_n));
        `else
        IBUFDS_GTXE1 refclk_ibuf (.O(sys_clk_c), .ODIV2(), .I(sys_clk_p), .IB(sys_clk_n), .CEB(1'b0));
        `endif
        
        // This code is not normal code it has been added to deal with linking
        // issues with the M505 and PLX8780 on the EX-7xx
        `ifdef XILINX_PLX_LINKING_WORKAROUND
            wire ibuf_sys_reset_n_c;
            
            parameter PCIE_RST_CNT  = 32'd20000000;
            parameter PCIE_LTSSM_L0 = 6'h16;
            parameter PCIE_x8       = 2'h3;
            parameter MAX_RST_CNT   = 32'd10;
            
            (* SHIFT_EXTRACT="NO", ASYNC_REG="TRUE", OPTIMIZE ="OFF" *)  
            reg         sys_reset_n_or_q[1:0];
            reg [31:0]  sys_reset_cnt;
            (* TIG = "TRUE" *) reg sys_reset_n_dly;
            reg [5:0]   pl_ltssm_state_q;
            reg [1:0]   pl_sel_link_width_q;
            reg         pl_sel_link_rate_q;
            reg         sys_rst_ste;
            reg [3:0]   ste_cnt;
            
            // This state machine is to resolve the linking issues we have been 
            // seeing with the M505 and EX-700/750 for more info, please see:
            // http://confluence.micron.com/confluence/pages/viewpage.action?pageId=52491853
            //
            // Here is what this state machine does:
            //     State 0:
            //       - After 100 ms check:
            //              - LTSSM state is L0 (6'h16)
            //              - Link width is x8 (3'h8)
            //              - Link Rate is Gen 2 (1'b1')
            //       - If none of the above are true then go to State 1, otherwise stay in this 
            //             state and keep the PCIe out of reset (sys_reset_n_dly)
            //       - The max number of times a reset will be issues is 10, after that the link is
            //             whatever it is this is to ensure that the PCIe is not constantly in reset
            //     State 1:
            //       - wait state for 100 ms
            
            always @(posedge extra_clk) begin
                // Cross Clock from async signal
                sys_reset_n_or_q[0] <= ibuf_sys_reset_n_c;
                sys_reset_n_or_q[1] <= sys_reset_n_or_q[0];
                
                //pl_* signals cross clock domain, not concerned about
                // meta-stability, because we check these signals only after
                // 100 ms
                pl_ltssm_state_q    <= pl_ltssm_state;
                pl_sel_link_rate_q  <= pl_sel_link_rate;
                pl_sel_link_width_q <= pl_sel_link_width;
                
                if (!sys_reset_n_or_q[1]) begin
                    sys_reset_cnt       <= 'h0;
                    sys_reset_n_dly     <= 1'b0;
                    ste_cnt             <= 'h0;
                    sys_rst_ste         <= 'h0;
                end else begin
                    case (sys_rst_ste)
                        1'b0: begin
                            if (sys_reset_cnt == PCIE_RST_CNT) begin
                                if (  ( (pl_ltssm_state_q != PCIE_LTSSM_L0) ||
                                        (pl_sel_link_width_q != PCIE_x8) ||
                                        (!pl_sel_link_rate_q) 
                                       ) && (ste_cnt <= MAX_RST_CNT)
                                    ) begin
                                    sys_rst_ste     <= 1'b1;
                                    ste_cnt         <= ste_cnt + 1'b1;
                                    sys_reset_n_dly <= 1'b0;
                                    sys_reset_cnt   <= 'h0;
                                end
                            end else begin
                                sys_reset_cnt       <= sys_reset_cnt + 1'b1;
                                sys_reset_n_dly     <= 1'b1;
                           end
                        end
                        
                        1'b1: begin
                            if (sys_reset_cnt == PCIE_RST_CNT) begin
                                sys_reset_cnt       <= 'h0;
                                sys_rst_ste         <= 1'b0;
                            end else begin
                                sys_reset_cnt       <= sys_reset_cnt + 1'b1;
                           end
                        end
                    endcase
                end
                
            end
            
            assign sys_reset_n_c = sys_reset_n_dly;
            
            IBUF   sys_reset_n_ibuf (.O(ibuf_sys_reset_n_c), .I(sys_reset_n));
        `else
        IBUF   sys_reset_n_ibuf (.O(sys_reset_n_c), .I(sys_reset_n));
        `endif //XILINX_PLX_LINKING_WORKAROUND
    `endif //XILINX_ULTRASCALE
`else
    assign extra_clk = extra_clk_p;
`endif //!ALTERA_FPGA

// TODO this is completely unconnected, and probably in the wrong place.
`ifndef ALTERA_FPGA
`ifndef XILINX_ULTRASCALE
`ifndef PICO_MODEL_M503
    `ifndef PICO_MODEL_EX600
        reg [31:0]        flash_ctrl_reg=32'h0;
        reg [15:0]        flash_d_o;
    
        wire [15:0] flash_d_i;
        wire flash_d_t = ~flash_oe; // flash_oe is active low.
        assign flash_reset = ~flash_ctrl_reg[0];
        assign flash_ce = ~flash_ctrl_reg[1];
        assign flash_oe = ~flash_ctrl_reg[2];
        assign flash_we = ~flash_ctrl_reg[3];
        assign flash_wp = ~flash_ctrl_reg[4];
        assign flash_byte = ~flash_ctrl_reg[5];
    
        genvar i;
        generate for (i=0; i < 16; i=i+1) begin:flash_d_bufs
        IOBUF flash_d_buf(.I(flash_d_o[i]), .O(flash_d_i[i]), .IO(flash_d[i]), .T(flash_d_t));
        end endgenerate
    `endif // !PICO_MODEL_EX600
`endif //!M503
`endif //!XILINX_ULTRASCALE
`endif //!ALTERA_FPGA
// in simulation, we drive the PCIe core signals from the testbench, rather than driving the real PCIe pins and
//   simulation the whole hard core.
`ifndef SIMULATION
`ifndef ALTERA_FPGA
`ifndef XILINX_ULTRASCALE
  `ifdef PICO_MODEL_M505
  pcie_7x_v1_6_8lane_gen2
  `elsif PICO_FPGA_LX550T_1
  v6_pcie_v2_4_8lane_gen1
  `else
  v6_pcie_v2_4_8lane_gen2
  `endif
#(
  `ifdef PICO_FPGA_LX240T
    .SUBSYSTEM_ID(16'h2240),
  `elsif PICO_FPGA_LX195T
    .SUBSYSTEM_ID(16'h1195),
  `elsif PICO_FPGA_LX325T
    .CFG_SUBSYS_ID(16'H1325),
  `elsif PICO_FPGA_SX315T
    .SUBSYSTEM_ID(16'h2315),
  `elsif PICO_FPGA_LX550T
    .SUBSYSTEM_ID(16'h2550),
  `elsif PICO_FPGA_LX550T_1
    .SUBSYSTEM_ID(16'h1550),
  `endif

  .PL_FAST_TRAIN      ( PL_FAST_TRAIN )
  `ifdef PICO_MODEL_M505
  ,.PCIE_EXT_CLK      ( PCIE_EXT_CLK )
  `endif
) core (
  `ifdef PICO_MODEL_M505  // few more core PCIe signals we need
    .tx_cfg_gnt( 1'b1 ),     // Tied to 1 in the app of the example design
    .rx_np_req( 1'b1 ),      // Tied to 1 in the app of the example design
  `endif

  //-------------------------------------------------------
  // 1. PCI Express (pci_exp) Interface
  //-------------------------------------------------------

  // Tx
  .pci_exp_txp( pci_exp_txp ),
  .pci_exp_txn( pci_exp_txn ),

  // Rx
  .pci_exp_rxp( pci_exp_rxp ),
  .pci_exp_rxn( pci_exp_rxn ),

  `ifdef PICO_MODEL_M505
  //----------------------------------------------------------------------------------------------------------------//
  // 2. Clocking Interface                                                                                          //
  //----------------------------------------------------------------------------------------------------------------//
  .PIPE_PCLK_IN                              ( PIPE_PCLK_IN ),
  .PIPE_RXUSRCLK_IN                          ( PIPE_RXUSRCLK_IN ),
  .PIPE_RXOUTCLK_IN                          ( PIPE_RXOUTCLK_IN ),
  .PIPE_DCLK_IN                              ( PIPE_DCLK_IN ),
  .PIPE_USERCLK1_IN                          ( PIPE_USERCLK1_IN ),
  .PIPE_OOBCLK_IN                            ( PIPE_OOBCLK_IN ),
  .PIPE_USERCLK2_IN                          ( PIPE_USERCLK2_IN ),
  .PIPE_MMCM_LOCK_IN                         ( PIPE_MMCM_LOCK_IN ),

  .PIPE_TXOUTCLK_OUT                         ( PIPE_TXOUTCLK_OUT ),
  .PIPE_RXOUTCLK_OUT                         ( PIPE_RXOUTCLK_OUT ),
  .PIPE_PCLK_SEL_OUT                         ( PIPE_PCLK_SEL_OUT ),
  .PIPE_GEN3_OUT                             ( PIPE_GEN3_OUT ),
  `endif //PICO_MODEL_M505

  //-------------------------------------------------------
  // 2. AXI-S Interface
  //-------------------------------------------------------
  `ifdef PICO_FPGA_LX550T_1
      // Common
      .user_clk_out( user_clk ),
      .user_half_clk_out( user_half_clk ),
      .user_reset_out( user_reset ),
      .user_lnk_up( user_lnk_up ),
    
      // Tx
      .s_axis_tx_tready( v6_s_axis_tx_tready ),
      .s_axis_tx_tdata( v6_s_axis_tx_tdata ),
      .s_axis_tx_tkeep( v6_s_axis_tx_tstrb ),
      .s_axis_tx_tuser( v6_s_axis_tx_tuser ),
      .s_axis_tx_tlast( v6_s_axis_tx_tlast ),
      .s_axis_tx_tvalid( v6_s_axis_tx_tvalid ),
      .tx_buf_av( tx_buf_av ),
      .tx_err_drop( tx_err_drop ),
    
      // Rx
      .m_axis_rx_tdata( v6_m_axis_rx_tdata ),
      .m_axis_rx_tkeep( v6_m_axis_rx_tstrb ),
      .m_axis_rx_tlast( v6_m_axis_rx_tlast ),
      .m_axis_rx_tvalid( v6_m_axis_rx_tvalid ),
      .m_axis_rx_tready( v6_m_axis_rx_tready ),
      .m_axis_rx_tuser ( v6_m_axis_rx_tuser ),
      .rx_np_ok( rx_np_ok ),
    
      // Flow Control
      .fc_cpld( fc_cpld ),
      .fc_cplh( fc_cplh ),
      .fc_npd( fc_npd ),
      .fc_nph( fc_nph ),
      .fc_pd( fc_pd ),
      .fc_ph( fc_ph ),
      .fc_sel( fc_sel ),
  `else
      // Common
      .user_clk_out( user_clk ),
      .user_reset_out( user_reset ),
      .user_lnk_up( user_lnk_up ),
    
      // Tx
      .s_axis_tx_tready( s_axis_tx_tready ),
      .s_axis_tx_tdata( s_axis_tx_tdata ),
      .s_axis_tx_tkeep( s_axis_tx_tstrb ),
      .s_axis_tx_tuser( s_axis_tx_tuser ),
      .s_axis_tx_tlast( s_axis_tx_tlast ),
      .s_axis_tx_tvalid( s_axis_tx_tvalid ),
      .tx_buf_av( tx_buf_av ),
      .tx_err_drop( tx_err_drop ),
    
      // Rx
      .m_axis_rx_tdata( m_axis_rx_tdata ),
      .m_axis_rx_tkeep( m_axis_rx_tstrb ),
      .m_axis_rx_tlast( m_axis_rx_tlast ),
      .m_axis_rx_tvalid( m_axis_rx_tvalid ),
      .m_axis_rx_tready( m_axis_rx_tready ),
      .m_axis_rx_tuser ( m_axis_rx_tuser ),
      .rx_np_ok( rx_np_ok ),
    
      // Flow Control
      .fc_cpld( fc_cpld ),
      .fc_cplh( fc_cplh ),
      .fc_npd( fc_npd ),
      .fc_nph( fc_nph ),
      .fc_pd( fc_pd ),
      .fc_ph( fc_ph ),
      .fc_sel( fc_sel ),
  `endif //PICO_FPGA_LX550T_1


  //-------------------------------------------------------
  // 3. Configuration (CFG) Interface
  //-------------------------------------------------------

  `ifdef PICO_MODEL_M505
  .cfg_mgmt_do(),
  .cfg_mgmt_rd_wr_done(),
  .cfg_mgmt_di( cfg_di ),
  .cfg_mgmt_byte_en( cfg_byte_en ),
  .cfg_mgmt_dwaddr( cfg_dwaddr ),
  .cfg_mgmt_wr_en( cfg_wr_en ),
  .cfg_mgmt_rd_en( cfg_rd_en ),
  `else
  .cfg_do( cfg_do ),
  .cfg_rd_wr_done( cfg_rd_wr_done),
  .cfg_di( cfg_di ),
  .cfg_byte_en( cfg_byte_en ),
  .cfg_dwaddr( cfg_dwaddr ),
  .cfg_wr_en( cfg_wr_en ),
  .cfg_rd_en( cfg_rd_en ),
  `endif

  `ifdef PICO_FPGA_LX550T_1
    .tx_cfg_gnt( tx_cfg_gnt ),
  `endif
  .cfg_err_cor( cfg_err_cor ),
  .cfg_err_ur( cfg_err_ur ),
  .cfg_err_ecrc( cfg_err_ecrc ),
  .cfg_err_cpl_timeout( cfg_err_cpl_timeout ),
  .cfg_err_cpl_abort( cfg_err_cpl_abort ),
  .cfg_err_cpl_unexpect( cfg_err_cpl_unexpect ),
  .cfg_err_posted( cfg_err_posted ),
  .cfg_err_locked( cfg_err_locked ),
  .cfg_err_tlp_cpl_header( cfg_err_tlp_cpl_header ),
  .cfg_err_cpl_rdy( cfg_err_cpl_rdy ),
  .cfg_interrupt( cfg_interrupt ),
  .cfg_interrupt_rdy( cfg_interrupt_rdy ),
  .cfg_interrupt_assert( cfg_interrupt_assert ),
  .cfg_interrupt_di( cfg_interrupt_di ),
  .cfg_interrupt_do( cfg_interrupt_do ),
  .cfg_interrupt_mmenable( cfg_interrupt_mmenable ),
  .cfg_interrupt_msienable( cfg_interrupt_msienable ),
  .cfg_interrupt_msixenable( cfg_interrupt_msixenable ),
  .cfg_interrupt_msixfm( cfg_interrupt_msixfm ),
  .cfg_turnoff_ok( cfg_turnoff_ok ),
  .cfg_to_turnoff( cfg_to_turnoff ),
  .cfg_trn_pending( cfg_trn_pending ),
  .cfg_pm_wake( cfg_pm_wake ),
  .cfg_bus_number( cfg_bus_number ),
  .cfg_device_number( cfg_device_number ),
  .cfg_function_number( cfg_function_number ),
  .cfg_status( cfg_status ),
  .cfg_command( cfg_command ),
  .cfg_dstatus( cfg_dstatus ),
  .cfg_dcommand( cfg_dcommand ),
  .cfg_lstatus( cfg_lstatus ),
  .cfg_lcommand( cfg_lcommand ),
  .cfg_dcommand2( cfg_dcommand2 ),
  .cfg_pcie_link_state( cfg_pcie_link_state ),
  .cfg_dsn( cfg_dsn ),
  .cfg_pmcsr_pme_en( ),
  .cfg_pmcsr_pme_status( ),
  .cfg_pmcsr_powerstate( ),

  //-------------------------------------------------------
  // 4. Physical Layer Control and Status (PL) Interface
  //-------------------------------------------------------

  .pl_initial_link_width( pl_initial_link_width ),
  .pl_lane_reversal_mode( pl_lane_reversal_mode ),
  `ifdef PICO_MODEL_M505
  .pl_link_gen2_cap( pl_link_gen2_capable ),
  .pl_link_upcfg_cap( pl_link_upcfg_capable ),
  .pl_sel_lnk_rate( pl_sel_link_rate ),
  .pl_sel_lnk_width( pl_sel_link_width ),
  `else
  .pl_link_gen2_capable( pl_link_gen2_capable ),
  .pl_link_upcfg_capable( pl_link_upcfg_capable ),
  .pl_sel_link_rate( pl_sel_link_rate ),
  .pl_sel_link_width( pl_sel_link_width ),
  `endif
  .pl_link_partner_gen2_supported( pl_link_partner_gen2_supported ),
  .pl_ltssm_state( pl_ltssm_state ),
  .pl_received_hot_rst( pl_received_hot_rst ),
  .pl_directed_link_auton( pl_directed_link_auton ),
  .pl_directed_link_change( pl_directed_link_change ),
  .pl_directed_link_speed( pl_directed_link_speed ),
  .pl_directed_link_width( pl_directed_link_width ),
  .pl_upstream_prefer_deemph( pl_upstream_prefer_deemph ),

  `ifdef PICO_MODEL_M505  
      //------------------------------------------------//
      // RP Only                                        //
      //------------------------------------------------//
      .cfg_pm_send_pme_to                         ( 1'b0 ),
      .cfg_ds_bus_number                          ( 8'b0 ),
      .cfg_ds_device_number                       ( 5'b0 ),
      .cfg_ds_function_number                     ( 3'b0 ),
      .cfg_mgmt_wr_rw1c_as_rw                     ( 1'b0 ),
      .cfg_msg_received                           ( ),
      .cfg_msg_data                               ( ),
    
      .cfg_bridge_serr_en                         ( ),
      .cfg_slot_control_electromech_il_ctl_pulse  ( ),
      .cfg_root_control_syserr_corr_err_en        ( ),
      .cfg_root_control_syserr_non_fatal_err_en   ( ),
      .cfg_root_control_syserr_fatal_err_en       ( ),
      .cfg_root_control_pme_int_en                ( ),
      .cfg_aer_rooterr_corr_err_reporting_en      ( ),
      .cfg_aer_rooterr_non_fatal_err_reporting_en ( ),
      .cfg_aer_rooterr_fatal_err_reporting_en     ( ),
      .cfg_aer_rooterr_corr_err_received          ( ),
      .cfg_aer_rooterr_non_fatal_err_received     ( ),
      .cfg_aer_rooterr_fatal_err_received         ( ),
    
      .cfg_msg_received_err_cor                   ( ),
      .cfg_msg_received_err_non_fatal             ( ),
      .cfg_msg_received_err_fatal                 ( ),
      .cfg_msg_received_pm_as_nak                 ( ),
      .cfg_msg_received_pme_to_ack                ( ),
      .cfg_msg_received_assert_int_a              ( ),
      .cfg_msg_received_assert_int_b              ( ),
      .cfg_msg_received_assert_int_c              ( ),
      .cfg_msg_received_assert_int_d              ( ),
      .cfg_msg_received_deassert_int_a            ( ),
      .cfg_msg_received_deassert_int_b            ( ),
      .cfg_msg_received_deassert_int_c            ( ),
      .cfg_msg_received_deassert_int_d            ( ),
      .pl_transmit_hot_rst                        ( 1'b0 ),
      .pl_downstream_deemph_source                ( 1'b0 ),
      
      //----------------------------------------------------------------------------------------------------------------//
      // 6. AER Interface                                                                                               //
      //----------------------------------------------------------------------------------------------------------------//
    
      .cfg_err_aer_headerlog                      ( 128'h0 ),
      .cfg_aer_interrupt_msgnum                   ( 5'h0 ),
      .cfg_err_aer_headerlog_set                  ( ),
      .cfg_aer_ecrc_check_en                      ( ),
      .cfg_aer_ecrc_gen_en                        ( ),
  `endif // PICO_MODEL_M505
  

  //-------------------------------------------------------
  // 7. System  (SYS) Interface
  //-------------------------------------------------------

  .sys_clk( sys_clk_c ),
  .sys_reset( !sys_reset_n_c )
);

    `ifdef PICO_FPGA_LX550T_1
    //----------------------------------------------------------------//
    // Axi Stream Interconnect
    // - converts 64 bit stream from the Virtex 6 PCIe to 128 bit
    //      stream for the Framework
    // - Also crosses clock domains from 250 Mhz to 125 Mhz
    // - S0 is 64 bits
    // - S1 is 128 bits
    // - M0 is 128 bits
    // - M1 is 64 bits
    //----------------------------------------------------------------// 
        always @ (posedge user_clk) user_reset_q_n <= ~user_reset_q;
           
        assign m_axis_rx_tuser[21:0]        = M00_AXIS_TUSER[21:0];
        
        axis_interconnect axis_interconnect (
            //Clock
            .S00_AXIS_ACLK               (user_clk),
            .S01_AXIS_ACLK               (user_half_clk),
            .ARESETN                     (user_reset_q_n), 

            .S00_AXIS_TVALID             (v6_m_axis_rx_tvalid), 
            .S01_AXIS_TVALID             (s_axis_tx_tvalid), 
            .S00_AXIS_TREADY             (v6_m_axis_rx_tready), 
            .S01_AXIS_TREADY             (s_axis_tx_tready), 
            .S00_AXIS_TDATA              (v6_m_axis_rx_tdata), 
            .S01_AXIS_TDATA              (s_axis_tx_tdata), 
            .S00_AXIS_TSTRB              (v6_m_axis_rx_tstrb), 
            .S01_AXIS_TSTRB              (s_axis_tx_tstrb), 
            .S00_AXIS_TLAST              (v6_m_axis_rx_tlast), 
            .S01_AXIS_TLAST              (s_axis_tx_tlast), 
            .S00_AXIS_TUSER              ( v6_m_axis_rx_tuser ), 
            .S01_AXIS_TUSER              ( {4'h0, s_axis_tx_tuser} ),
            
            .M00_AXIS_ACLK               (user_half_clk),
            .M01_AXIS_ACLK               (user_clk),
            .M00_AXIS_TVALID             (m_axis_rx_tvalid), 
            .M01_AXIS_TVALID             (v6_s_axis_tx_tvalid), 
            .M00_AXIS_TREADY             (m_axis_rx_tready), 
            .M01_AXIS_TREADY             (v6_s_axis_tx_tready), 
            .M00_AXIS_TDATA              (m_axis_rx_tdata), 
            .M01_AXIS_TDATA              (v6_s_axis_tx_tdata), 
            .M00_AXIS_TSTRB              (m_axis_rx_tstrb), 
            .M01_AXIS_TSTRB              (v6_s_axis_tx_tstrb), 
            .M00_AXIS_TLAST              (m_axis_rx_tlast), 
            .M01_AXIS_TLAST              (v6_s_axis_tx_tlast), 
            .M00_AXIS_TUSER              (M00_AXIS_TUSER), 
            .M01_AXIS_TUSER              (v6_s_axis_tx_tuser)
        );
    `endif //PICO_FPGA_LX550T_1 
`else //XILINX_ULTRASCALE
    xilinx_pcie_3_0_7vx #(
        // Leave the M510 with a X8 PCIe
        //`ifdef PICO_MODEL_M510
        //    `ifdef PICO_FPGA_KU060
        //        .PL_LINK_CAP_MAX_LINK_WIDTH     (4),
        //    `endif //PICO_FPGA_KU060
        //`endif //PICO_MODEL_M510
        .C_DATA_WIDTH (C_DATA_WIDTH)
    ) core (
        .user_clk                       ( user_clk              ),
        .user_reset                     ( user_reset            ),
        .user_lnk_up                    ( user_lnk_up           ),

        // Tx
        .pci_exp_txp                    ( pci_exp_txp ),
        .pci_exp_txn                    ( pci_exp_txn ),

        // Rx
        .pci_exp_rxp                    ( pci_exp_rxp ),
        .pci_exp_rxn                    ( pci_exp_rxn ),

        // Tx
        .s_axis_tx_tready               ( s_axis_tx_tready      ),
        .s_axis_tx_tdata                ( s_axis_tx_tdata       ),
        .s_axis_tx_tstrb                ( s_axis_tx_tstrb       ),
        .s_axis_tx_tuser                ( s_axis_tx_tuser       ),
        .s_axis_tx_tlast                ( s_axis_tx_tlast       ),
        .s_axis_tx_tvalid               ( s_axis_tx_tvalid      ),
    
        // Rx
        .m_axis_rx_tdata                ( m_axis_rx_tdata       ),
        .m_axis_rx_tstrb                ( m_axis_rx_tstrb       ),
        .m_axis_rx_tlast                ( m_axis_rx_tlast       ),
        .m_axis_rx_tvalid               ( m_axis_rx_tvalid      ),
        .m_axis_rx_tready               ( m_axis_rx_tready      ),
        .m_axis_rx_tuser                ( m_axis_rx_tuser       ),

        .cfg_interrupt                  ( cfg_interrupt         ),
        .cfg_interrupt_rdy              ( cfg_interrupt_rdy     ),

        .cfg_dsn                        ( cfg_dsn               ),
        .cfg_bus_number                 ( cfg_bus_number        ),
        .cfg_device_number              ( cfg_device_number     ),
        .cfg_function_number            ( cfg_function_number   ),
        .cfg_dcommand                   ( cfg_dcommand          ),

        .sys_clk_p                      ( sys_clk_p             ),
        .sys_clk_n                      ( sys_clk_n             ),
        .sys_reset_n                    ( sys_reset_n           )
    ); 
`endif

`else //ALTERA_FPGA
    altera_pcie #(.C_DATA_WIDTH(C_DATA_WIDTH), .STRB_WIDTH(STRB_WIDTH)) core (
        .user_clk                       ( user_clk              ),
        .user_reset                     ( user_reset            ),
        .user_lnk_up                    ( user_lnk_up           ),

        // Tx
        .pci_exp_txp                    ( pci_exp_txp           ),

        // Rx
        .pci_exp_rxp                    ( pci_exp_rxp           ),

        // Tx
        .s_axis_tx_tready               ( s_axis_tx_tready      ),
        .s_axis_tx_tdata                ( s_axis_tx_tdata       ),
        .s_axis_tx_tstrb                ( s_axis_tx_tstrb       ),
        .s_axis_tx_tuser                ( s_axis_tx_tuser       ),
        .s_axis_tx_tlast                ( s_axis_tx_tlast       ),
        .s_axis_tx_tvalid               ( s_axis_tx_tvalid      ),
    
        // Rx
        .m_axis_rx_tdata                ( m_axis_rx_tdata       ),
        .m_axis_rx_tstrb                ( m_axis_rx_tstrb       ),
        .m_axis_rx_tlast                ( m_axis_rx_tlast       ),
        .m_axis_rx_tvalid               ( m_axis_rx_tvalid      ),
        .m_axis_rx_tready               ( m_axis_rx_tready      ),
        .m_axis_rx_tuser                ( m_axis_rx_tuser       ),

        .interrupt_req                  ( cfg_interrupt         ),
        .interrupt_rdy                  ( cfg_interrupt_rdy     ),

        .cfg_bus_number                 ( cfg_bus_number        ),
        .cfg_device_number              ( cfg_device_number     ),
        .cfg_function_number            ( cfg_function_number   ),
        .cfg_dcommand                   ( cfg_dcommand          ),

        .sys_clk                        ( sys_clk_p             ),
        .sys_reset_n                    ( sys_reset_n           )
    );
`endif
        
`else // SIMULATION
assign cfg_command = 16'h4; // set the bus master enable bit
// set the completer id to 0xCAFE for simulation
assign cfg_bus_number = 8'hca;
assign cfg_device_number = 5'h1f;
assign cfg_function_number = 3'h6;
//not really correct. we see (for example) 0x4920 in hardware for 256 maxpayload and 2kB max read.
//  but the simulation code might not handle these larger sizes.
assign cfg_dcommand = 16'h0;
`endif

pcie_app_v6  #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .STRB_WIDTH( STRB_WIDTH )

  )app (

  //-------------------------------------------------------
  // 1. AXI-S Interface
  //-------------------------------------------------------

  // Common
  `ifdef PICO_FPGA_LX550T_1
      `ifndef SIMULATION
            .user_clk( user_half_clk ),
      `else
            .user_clk( user_clk ),
      `endif //!SIMULATION
  `else
      .user_clk( user_clk ),
  `endif //PICO_FPGA_LX550T_1
  .user_reset( user_reset_q),
  .user_lnk_up( user_lnk_up ),

  // Tx
  .tx_buf_av( tx_buf_av ),
  .tx_cfg_req( tx_cfg_req ),
  .tx_err_drop( tx_err_drop ),
  .s_axis_tx_tready( s_axis_tx_tready ),
  .s_axis_tx_tdata( s_axis_tx_tdata ),
  .s_axis_tx_tstrb( s_axis_tx_tstrb ),
  .s_axis_tx_tuser( s_axis_tx_tuser ),
  .s_axis_tx_tlast( s_axis_tx_tlast ),
  .s_axis_tx_tvalid( s_axis_tx_tvalid ),
  .tx_cfg_gnt( tx_cfg_gnt ),

  // Rx
  .m_axis_rx_tdata( m_axis_rx_tdata ),
  .m_axis_rx_tstrb( m_axis_rx_tstrb ),
  .m_axis_rx_tlast( m_axis_rx_tlast ),
  .m_axis_rx_tvalid( m_axis_rx_tvalid ),
  .m_axis_rx_tready( m_axis_rx_tready ),
  .m_axis_rx_tuser ( m_axis_rx_tuser ),
  .rx_np_ok( rx_np_ok ),

  // Flow Control
  .fc_cpld( fc_cpld ),
  .fc_cplh( fc_cplh ),
  .fc_npd( fc_npd ),
  .fc_nph( fc_nph ),
  .fc_pd( fc_pd ),
  .fc_ph( fc_ph ),
  .fc_sel( fc_sel ),
        
    // stream signals we're taking to the toplevel for the user
    .s_clk(s_clk),
    .s_rst(s_rst),

    .s_out_en(s_out_en),
    .s_out_id(s_out_id[8:0]),
    .s_out_data(s_out_data[127:0]),

    .s_in_valid(s_in_valid),
    .s_in_id(s_in_id[8:0]),
    .s_in_data(s_in_data[127:0]),

    .s_poll_id(s_poll_id[8:0]),
    .s_poll_seq(s_poll_seq[31:0]),
    .s_poll_next_desc(s_poll_next_desc[127:0]),
    .s_poll_next_desc_valid(s_poll_next_desc_valid),

    .s_next_desc_rd_en(s_next_desc_rd_en),
    .s_next_desc_rd_id(s_next_desc_rd_id[8:0]),

    .UserPBWidth(UserPBWidth),
  
    // user-direct writes
    .user_pci_wr_q_data(user_pci_wr_q_data),
    .user_pci_wr_q_valid(user_pci_wr_q_valid),
    .user_pci_wr_q_en(user_pci_wr_q_en),

    .user_pci_wr_data_q_data(user_pci_wr_data_q_data),
    .user_pci_wr_data_q_valid(user_pci_wr_data_q_valid),
    .user_pci_wr_data_q_en(user_pci_wr_data_q_en),
    .direct_rx_valid(direct_rx_valid),

    // temperature status
    .temp(temp),

  //-------------------------------------------------------
  // 2. Configuration (CFG) Interface
  //-------------------------------------------------------

  .cfg_do( cfg_do ),
  .cfg_rd_wr_done( cfg_rd_wr_done),
  .cfg_di( cfg_di ),
  .cfg_byte_en( cfg_byte_en ),
  .cfg_dwaddr( cfg_dwaddr ),
  .cfg_wr_en( cfg_wr_en ),
  .cfg_rd_en( cfg_rd_en ),

  .cfg_err_cor( cfg_err_cor ),
  .cfg_err_ur( cfg_err_ur ),
  .cfg_err_ecrc( cfg_err_ecrc ),
  .cfg_err_cpl_timeout( cfg_err_cpl_timeout ),
  .cfg_err_cpl_abort( cfg_err_cpl_abort ),
  .cfg_err_cpl_unexpect( cfg_err_cpl_unexpect ),
  .cfg_err_posted( cfg_err_posted ),
  .cfg_err_locked( cfg_err_locked ),
  .cfg_err_tlp_cpl_header( cfg_err_tlp_cpl_header ),
  .cfg_err_cpl_rdy( cfg_err_cpl_rdy ),
  .cfg_interrupt( cfg_interrupt ),
  .cfg_interrupt_rdy( cfg_interrupt_rdy ),
  .cfg_interrupt_assert( cfg_interrupt_assert ),
  .cfg_interrupt_di( cfg_interrupt_di ),
  .cfg_interrupt_do( cfg_interrupt_do ),
  .cfg_interrupt_mmenable( cfg_interrupt_mmenable ),
  .cfg_interrupt_msienable( cfg_interrupt_msienable ),
  .cfg_interrupt_msixenable( cfg_interrupt_msixenable ),
  .cfg_interrupt_msixfm( cfg_interrupt_msixfm ),
  .cfg_turnoff_ok( cfg_turnoff_ok ),
  .cfg_to_turnoff( cfg_to_turnoff ),
  .cfg_trn_pending( cfg_trn_pending ),
  .cfg_pm_wake( cfg_pm_wake ),
  .cfg_bus_number( cfg_bus_number ),
  .cfg_device_number( cfg_device_number ),
  .cfg_function_number( cfg_function_number ),
  .cfg_status( cfg_status ),
  .cfg_command( cfg_command ),
  .cfg_dstatus( cfg_dstatus ),
  .cfg_dcommand( cfg_dcommand ),
  .cfg_lstatus( cfg_lstatus ),
  .cfg_lcommand( cfg_lcommand ),
  .cfg_dcommand2( cfg_dcommand2 ),
  .cfg_pcie_link_state( cfg_pcie_link_state ),
  .cfg_dsn( cfg_dsn ),

  //-------------------------------------------------------
  // 3. Physical Layer Control and Status (PL) Interface
  //-------------------------------------------------------

  .pl_initial_link_width( pl_initial_link_width ),
  .pl_lane_reversal_mode( pl_lane_reversal_mode ),
  .pl_link_gen2_capable( pl_link_gen2_capable ),
  .pl_link_partner_gen2_supported( pl_link_partner_gen2_supported ),
  .pl_link_upcfg_capable( pl_link_upcfg_capable ),
  .pl_ltssm_state( pl_ltssm_state ),
  .pl_received_hot_rst( pl_received_hot_rst ),
  .pl_sel_link_rate( pl_sel_link_rate ),
  .pl_sel_link_width( pl_sel_link_width ),
  .pl_directed_link_auton( pl_directed_link_auton ),
  .pl_directed_link_change( pl_directed_link_change ),
  .pl_directed_link_speed( pl_directed_link_speed ),
  .pl_directed_link_width( pl_directed_link_width ),
  .pl_upstream_prefer_deemph( pl_upstream_prefer_deemph )

);

endmodule
