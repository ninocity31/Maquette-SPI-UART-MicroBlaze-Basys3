// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Nov  8 15:52:41 2026
// Host        : ASUS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/work/Communication_SPI/Communication_SPI.srcs/sources_1/bd/design_1/ip/design_1_afficheur_0_0/design_1_afficheur_0_0_stub.v
// Design      : design_1_afficheur_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "afficheur,Vivado 2019.1" *)
module design_1_afficheur_0_0(CLK, HEX, SEPT_SEG, AN)
/* synthesis syn_black_box black_box_pad_pin="CLK,HEX[15:0],SEPT_SEG[6:0],AN[3:0]" */;
  input CLK;
  input [15:0]HEX;
  output [6:0]SEPT_SEG;
  output [3:0]AN;
endmodule
