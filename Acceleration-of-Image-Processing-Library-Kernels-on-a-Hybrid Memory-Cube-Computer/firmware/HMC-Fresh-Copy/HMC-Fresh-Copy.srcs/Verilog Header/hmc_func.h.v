`include "hmc_def.vh"

// return true if the RTC field is valid for a packet with the given command type.
function RTC_valid_for_cmd;
    input [5:0] cmd;
    begin
        case (cmd)
            `HMC_CMD_NULL:  RTC_valid_for_cmd   = 1'b0;
            `HMC_CMD_PRET:  RTC_valid_for_cmd   = 1'b0;
            `HMC_CMD_IRTRY: RTC_valid_for_cmd   = 1'b0;
            default:        RTC_valid_for_cmd   = 1'b1;
        endcase
    end
endfunction

// return true if the FRP field is valid for a packet with the given command type.
// (note that this happens to be the same as whether the RTC is valid.)
function FRP_valid_for_cmd;
    input [5:0] cmd;
    begin
        case (cmd)
            `HMC_CMD_NULL:  FRP_valid_for_cmd   = 1'b0;
            `HMC_CMD_PRET:  FRP_valid_for_cmd   = 1'b0;
            `HMC_CMD_IRTRY: FRP_valid_for_cmd   = 1'b0;
            default:        FRP_valid_for_cmd   = 1'b1;
        endcase
    end
endfunction

// return true if the RRP field is valid for a packet with the given command type.
// IRTRY does have an RRP field, but it's a request to start resending from that point, NOT an "ack,"
//   so we return false for IRTRY packets.
function RRP_valid_for_cmd;
    input [5:0] cmd;
    begin
        case (cmd)
            `HMC_CMD_NULL:  RRP_valid_for_cmd   = 1'b0;
            `HMC_CMD_IRTRY: RRP_valid_for_cmd   = 1'b0;
            default:        RRP_valid_for_cmd   = 1'b1;
        endcase
    end
endfunction

// return the CMD field in a flit.
function [7:0] GetCMD;
    input [127:0] data;
    begin
        GetCMD = data[5:0];
    end
endfunction

// return the TAG field in a flit.
function [8:0] GetTag;
    input [127:0] data;
    begin
        GetTag = data[23:15];
    end
endfunction

// return the Cube ID field (must be header flit in packet).
function [2:0] GetCubeID;
    input [127:0] data;
    begin
        GetCubeID = data[63:61];
    end
endfunction

// return the address field (must be header flit in packet).
function [33:0] GetAddr;
    input [127:0] data;
    begin
        GetAddr = data[57:24];
    end
endfunction

// return the DLN field (must be header flit in a packet).
function [3:0] GetDLN;
    input [127:0] data;
    begin
        GetDLN = data[14:11];
    end
endfunction

// return the LNG field (must be header flit in a packet).
function [3:0] GetLNG;
    input [127:0] data;
    begin
        GetLNG = data[10:7];
    end
endfunction

// return the RRP in a flit (must be the last flit in the packet).
function [7:0] GetRRP;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetRRP = data[7+64:0+64];
    end
endfunction

// return the FRP in a flit (must be the last flit in the packet).
function [7:0] GetFRP;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetFRP = data[15+64:8+64];
    end
endfunction

// return the RTC in a flit (must be the last flit in the packet).
function [4:0] GetRTC;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetRTC = data[31+64:27+64];
    end
endfunction

// return the SEQ in a flit (must be the last flit in the packet).
function [2:0] GetSEQ;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetSEQ = data[18+64:16+64];
    end
endfunction

// return the CRC in a flit (must be the last flit in the packet).
function [31:0] GetCRC;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetCRC = data[63+64:32+64];
    end
endfunction

// return the ERRSTAT in a flit (must be the last flit in the packet).
function [6:0] GetERRSTAT;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetERRSTAT = data[26+64:20+64];
    end
endfunction

// return the DINV in a flit (must be the last flit in the packet).
function GetDINV;
    input [127:0] data;
    begin
        // the tail starts at bit 64.
        GetDINV = data[19+64];
    end
endfunction

function [4:0] FillLeft5;
    input [4:0] data;
    casex (data)
        5'bxxxx1:  FillLeft5 = 5'b11111;
        5'bxxx10:  FillLeft5 = 5'b11110;
        5'bxx100:  FillLeft5 = 5'b11100;
        5'bx1000:  FillLeft5 = 5'b11000;
        5'b10000:  FillLeft5 = 5'b10000;
        default:   FillLeft5 = 5'b00000;
    endcase
endfunction

function [127:0] MakePRET;
    input [7:0] rrp;
    MakePRET = {32'h0,
                5'h0,       // RTC
                3'h0,       // SLID
                5'h0,       // res
                3'h0,       // SEQ
                8'h0,       // FRP
                rrp[7:0],   // RRP
                3'h0,       // CUB
                3'h0,       // res
                34'h0,      // ADRS
                9'h0,       // TAG
                4'h1,       // DLN
                4'h1,       // LNG
                1'h0,       // res
                6'h1        // CMD
                };
endfunction

function [8*8:1] Cmd2String;
    input [5:0] c;
    begin
        case (c)
            `HMC_CMD_NULL:      Cmd2String = "NULL";
            `HMC_CMD_PRET:      Cmd2String = "PRET";
            `HMC_CMD_TRET:      Cmd2String = "TRET";
            `HMC_CMD_IRTRY:     Cmd2String = "IRTRY";
            `HMC_CMD_WR16:      Cmd2String = "WR16";
            `HMC_CMD_P_WR16:    Cmd2String = "P_WR16";
            `HMC_CMD_P_WR32:    Cmd2String = "P_WR32";
            `HMC_CMD_P_WR48:    Cmd2String = "P_WR48";
            `HMC_CMD_P_WR64:    Cmd2String = "P_WR64";
            `HMC_CMD_P_WR80:    Cmd2String = "P_WR80";
            `HMC_CMD_P_WR96:    Cmd2String = "P_WR96";
            `HMC_CMD_P_WR112:   Cmd2String = "P_WR112";
            `HMC_CMD_P_WR128:   Cmd2String = "P_WR128";
            `HMC_CMD_RD16:      Cmd2String = "RD16";
            `HMC_CMD_RD32:      Cmd2String = "RD32";
            `HMC_CMD_RD48:      Cmd2String = "RD48";
            `HMC_CMD_RD64:      Cmd2String = "RD64";
            `HMC_CMD_RD80:      Cmd2String = "RD80";
            `HMC_CMD_RD96:      Cmd2String = "RD96";
            `HMC_CMD_RD112:     Cmd2String = "RD112";
            `HMC_CMD_RD128:     Cmd2String = "RD128";
            `HMC_CMD_RD_RS:     Cmd2String = "RD_RS";
            `HMC_CMD_WR_RS:     Cmd2String = "WR_RS";
            `HMC_CMD_MD_RD_RS:  Cmd2String = "MD_RD_RS";
            `HMC_CMD_MD_WR_RS:  Cmd2String = "MD_WR_RS";
            `HMC_CMD_ERROR:     Cmd2String = "ERROR";
            default:            Cmd2String = "INVALID";
        endcase
    end
endfunction

task PrintPkt;
    input [16*8:1]  name;
    input [127:0]   head;
    input [127:0]   tail;
    begin
        $display("[%t] PrintPkt(%s, 0x%x, 0x%x)", $time, name, head, tail);
        // head
        if ((GetCMD(head)>>3) == 3'b111) begin
            // Response-type packet
            $display("[%t] %s PrintPkt head: cmd: %s, tag:0x%x/%d", $time, name, Cmd2String(GetCMD(head)), GetTag(head), GetTag(head));
        end else begin
            // Request/flow-type packet
            $display("[%t] %s PrintPkt head: cmd: %x=%s, lng:%0d, dln:%0d, tag:0x%x/%d, adr:0x%0h, cub:%0d", $time, name, GetCMD(head), Cmd2String(GetCMD(head)), GetLNG(head), GetDLN(head), GetTag(head), GetTag(head), GetAddr(head), GetCubeID(head));
        end

        // tail
        if ((GetCMD(head)>>3) == 3'b111) begin
            // Response-type packet
            $display("[%t] %s PrintPkt tail: rtc:0x%x, seq:%d, frp:0x%x/%d, rrp:0x%x/%d", $time, name, GetRTC(tail), GetSEQ(tail), GetFRP(tail), GetFRP(tail), GetRRP(tail), GetRRP(tail));
        end else begin
            // Request/flow-type packet
            $display("[%t] %s PrintPkt tail: crc:%x, rtc:0x%x, seq:%d, frp:0x%x/%d, rrp:0x%x/%d", $time, name, GetCRC(tail), GetRTC(tail), GetSEQ(tail), GetFRP(tail), GetFRP(tail), GetRRP(tail), GetRRP(tail));
        end
    end
endtask

