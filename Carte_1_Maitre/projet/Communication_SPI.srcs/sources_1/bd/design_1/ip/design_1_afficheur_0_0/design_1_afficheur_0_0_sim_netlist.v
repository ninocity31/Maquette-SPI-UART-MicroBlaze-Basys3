// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Nov  8 15:52:41 2026
// Host        : ASUS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/souha/Bureau/everything/PRJ/Projet/Microblaze/Communication_SPI/Communication_SPI.srcs/sources_1/bd/design_1/ip/design_1_afficheur_0_0/design_1_afficheur_0_0_sim_netlist.v
// Design      : design_1_afficheur_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_afficheur_0_0,afficheur,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* ip_definition_source = "module_ref" *) 
(* x_core_info = "afficheur,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module design_1_afficheur_0_0
   (CLK,
    HEX,
    SEPT_SEG,
    AN);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 CLK CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME CLK, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_1_clk_out1, INSERT_VIP 0" *) input CLK;
  input [15:0]HEX;
  output [6:0]SEPT_SEG;
  output [3:0]AN;

  wire [3:0]AN;
  wire CLK;
  wire [15:0]HEX;
  wire [6:0]SEPT_SEG;

  design_1_afficheur_0_0_afficheur U0
       (.AN(AN),
        .CLK(CLK),
        .HEX(HEX),
        .SEPT_SEG(SEPT_SEG));
endmodule

(* ORIG_REF_NAME = "afficheur" *) 
module design_1_afficheur_0_0_afficheur
   (SEPT_SEG,
    AN,
    CLK,
    HEX);
  output [6:0]SEPT_SEG;
  output [3:0]AN;
  input CLK;
  input [15:0]HEX;

  wire [3:0]AN;
  wire \AN[0]_i_1_n_0 ;
  wire \AN[1]_i_1_n_0 ;
  wire \AN[2]_i_1_n_0 ;
  wire \AN[3]_i_1_n_0 ;
  wire CLK;
  wire ENABLE;
  wire ENABLE_i_2_n_0;
  wire ENABLE_i_3_n_0;
  wire \FSM_sequential_etat[0]_i_1_n_0 ;
  wire \FSM_sequential_etat[1]_i_1_n_0 ;
  wire [15:0]HEX;
  wire [6:0]SEPT_SEG;
  wire \cmp[0]_i_2_n_0 ;
  wire [13:0]cmp_reg;
  wire \cmp_reg[0]_i_1_n_0 ;
  wire \cmp_reg[0]_i_1_n_1 ;
  wire \cmp_reg[0]_i_1_n_2 ;
  wire \cmp_reg[0]_i_1_n_3 ;
  wire \cmp_reg[0]_i_1_n_4 ;
  wire \cmp_reg[0]_i_1_n_5 ;
  wire \cmp_reg[0]_i_1_n_6 ;
  wire \cmp_reg[0]_i_1_n_7 ;
  wire \cmp_reg[12]_i_1_n_3 ;
  wire \cmp_reg[12]_i_1_n_6 ;
  wire \cmp_reg[12]_i_1_n_7 ;
  wire \cmp_reg[4]_i_1_n_0 ;
  wire \cmp_reg[4]_i_1_n_1 ;
  wire \cmp_reg[4]_i_1_n_2 ;
  wire \cmp_reg[4]_i_1_n_3 ;
  wire \cmp_reg[4]_i_1_n_4 ;
  wire \cmp_reg[4]_i_1_n_5 ;
  wire \cmp_reg[4]_i_1_n_6 ;
  wire \cmp_reg[4]_i_1_n_7 ;
  wire \cmp_reg[8]_i_1_n_0 ;
  wire \cmp_reg[8]_i_1_n_1 ;
  wire \cmp_reg[8]_i_1_n_2 ;
  wire \cmp_reg[8]_i_1_n_3 ;
  wire \cmp_reg[8]_i_1_n_4 ;
  wire \cmp_reg[8]_i_1_n_5 ;
  wire \cmp_reg[8]_i_1_n_6 ;
  wire \cmp_reg[8]_i_1_n_7 ;
  wire [3:0]digit;
  wire [3:0]digit_0;
  wire [1:0]etat;
  wire p_0_in;
  wire [3:1]\NLW_cmp_reg[12]_i_1_CO_UNCONNECTED ;
  wire [3:2]\NLW_cmp_reg[12]_i_1_O_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \AN[0]_i_1 
       (.I0(etat[1]),
        .I1(etat[0]),
        .O(\AN[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \AN[1]_i_1 
       (.I0(etat[0]),
        .I1(etat[1]),
        .O(\AN[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \AN[2]_i_1 
       (.I0(etat[1]),
        .I1(etat[0]),
        .O(\AN[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \AN[3]_i_1 
       (.I0(etat[1]),
        .I1(etat[0]),
        .O(\AN[3]_i_1_n_0 ));
  FDRE \AN_reg[0] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\AN[0]_i_1_n_0 ),
        .Q(AN[0]),
        .R(1'b0));
  FDRE \AN_reg[1] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\AN[1]_i_1_n_0 ),
        .Q(AN[1]),
        .R(1'b0));
  FDRE \AN_reg[2] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\AN[2]_i_1_n_0 ),
        .Q(AN[2]),
        .R(1'b0));
  FDRE \AN_reg[3] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\AN[3]_i_1_n_0 ),
        .Q(AN[3]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h0200)) 
    ENABLE_i_1
       (.I0(ENABLE_i_2_n_0),
        .I1(cmp_reg[0]),
        .I2(cmp_reg[1]),
        .I3(ENABLE_i_3_n_0),
        .O(p_0_in));
  LUT6 #(
    .INIT(64'h0000200000000000)) 
    ENABLE_i_2
       (.I0(cmp_reg[10]),
        .I1(cmp_reg[11]),
        .I2(cmp_reg[8]),
        .I3(cmp_reg[9]),
        .I4(cmp_reg[12]),
        .I5(cmp_reg[13]),
        .O(ENABLE_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    ENABLE_i_3
       (.I0(cmp_reg[4]),
        .I1(cmp_reg[5]),
        .I2(cmp_reg[2]),
        .I3(cmp_reg[3]),
        .I4(cmp_reg[7]),
        .I5(cmp_reg[6]),
        .O(ENABLE_i_3_n_0));
  FDPE ENABLE_reg
       (.C(CLK),
        .CE(1'b1),
        .D(1'b0),
        .PRE(p_0_in),
        .Q(ENABLE));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_etat[0]_i_1 
       (.I0(etat[0]),
        .O(\FSM_sequential_etat[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \FSM_sequential_etat[1]_i_1 
       (.I0(etat[0]),
        .I1(etat[1]),
        .O(\FSM_sequential_etat[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "dig1:00,dig2:01,dig3:10,dig4:11" *) 
  FDRE \FSM_sequential_etat_reg[0] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\FSM_sequential_etat[0]_i_1_n_0 ),
        .Q(etat[0]),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "dig1:00,dig2:01,dig3:10,dig4:11" *) 
  FDRE \FSM_sequential_etat_reg[1] 
       (.C(CLK),
        .CE(ENABLE),
        .D(\FSM_sequential_etat[1]_i_1_n_0 ),
        .Q(etat[1]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h2094)) 
    \SEPT_SEG[0]_INST_0 
       (.I0(digit[3]),
        .I1(digit[2]),
        .I2(digit[0]),
        .I3(digit[1]),
        .O(SEPT_SEG[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hA4C8)) 
    \SEPT_SEG[1]_INST_0 
       (.I0(digit[3]),
        .I1(digit[2]),
        .I2(digit[1]),
        .I3(digit[0]),
        .O(SEPT_SEG[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hA210)) 
    \SEPT_SEG[2]_INST_0 
       (.I0(digit[3]),
        .I1(digit[0]),
        .I2(digit[1]),
        .I3(digit[2]),
        .O(SEPT_SEG[2]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hC214)) 
    \SEPT_SEG[3]_INST_0 
       (.I0(digit[3]),
        .I1(digit[2]),
        .I2(digit[0]),
        .I3(digit[1]),
        .O(SEPT_SEG[3]));
  LUT4 #(
    .INIT(16'h5710)) 
    \SEPT_SEG[4]_INST_0 
       (.I0(digit[3]),
        .I1(digit[1]),
        .I2(digit[2]),
        .I3(digit[0]),
        .O(SEPT_SEG[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h5190)) 
    \SEPT_SEG[5]_INST_0 
       (.I0(digit[3]),
        .I1(digit[2]),
        .I2(digit[0]),
        .I3(digit[1]),
        .O(SEPT_SEG[5]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h4025)) 
    \SEPT_SEG[6]_INST_0 
       (.I0(digit[3]),
        .I1(digit[0]),
        .I2(digit[2]),
        .I3(digit[1]),
        .O(SEPT_SEG[6]));
  LUT1 #(
    .INIT(2'h1)) 
    \cmp[0]_i_2 
       (.I0(cmp_reg[0]),
        .O(\cmp[0]_i_2_n_0 ));
  FDRE \cmp_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[0]_i_1_n_7 ),
        .Q(cmp_reg[0]),
        .R(1'b0));
  CARRY4 \cmp_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\cmp_reg[0]_i_1_n_0 ,\cmp_reg[0]_i_1_n_1 ,\cmp_reg[0]_i_1_n_2 ,\cmp_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\cmp_reg[0]_i_1_n_4 ,\cmp_reg[0]_i_1_n_5 ,\cmp_reg[0]_i_1_n_6 ,\cmp_reg[0]_i_1_n_7 }),
        .S({cmp_reg[3:1],\cmp[0]_i_2_n_0 }));
  FDRE \cmp_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[8]_i_1_n_5 ),
        .Q(cmp_reg[10]),
        .R(1'b0));
  FDRE \cmp_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[8]_i_1_n_4 ),
        .Q(cmp_reg[11]),
        .R(1'b0));
  FDRE \cmp_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[12]_i_1_n_7 ),
        .Q(cmp_reg[12]),
        .R(1'b0));
  CARRY4 \cmp_reg[12]_i_1 
       (.CI(\cmp_reg[8]_i_1_n_0 ),
        .CO({\NLW_cmp_reg[12]_i_1_CO_UNCONNECTED [3:1],\cmp_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_cmp_reg[12]_i_1_O_UNCONNECTED [3:2],\cmp_reg[12]_i_1_n_6 ,\cmp_reg[12]_i_1_n_7 }),
        .S({1'b0,1'b0,cmp_reg[13:12]}));
  FDRE \cmp_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[12]_i_1_n_6 ),
        .Q(cmp_reg[13]),
        .R(1'b0));
  FDRE \cmp_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[0]_i_1_n_6 ),
        .Q(cmp_reg[1]),
        .R(1'b0));
  FDRE \cmp_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[0]_i_1_n_5 ),
        .Q(cmp_reg[2]),
        .R(1'b0));
  FDRE \cmp_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[0]_i_1_n_4 ),
        .Q(cmp_reg[3]),
        .R(1'b0));
  FDRE \cmp_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[4]_i_1_n_7 ),
        .Q(cmp_reg[4]),
        .R(1'b0));
  CARRY4 \cmp_reg[4]_i_1 
       (.CI(\cmp_reg[0]_i_1_n_0 ),
        .CO({\cmp_reg[4]_i_1_n_0 ,\cmp_reg[4]_i_1_n_1 ,\cmp_reg[4]_i_1_n_2 ,\cmp_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\cmp_reg[4]_i_1_n_4 ,\cmp_reg[4]_i_1_n_5 ,\cmp_reg[4]_i_1_n_6 ,\cmp_reg[4]_i_1_n_7 }),
        .S(cmp_reg[7:4]));
  FDRE \cmp_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[4]_i_1_n_6 ),
        .Q(cmp_reg[5]),
        .R(1'b0));
  FDRE \cmp_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[4]_i_1_n_5 ),
        .Q(cmp_reg[6]),
        .R(1'b0));
  FDRE \cmp_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[4]_i_1_n_4 ),
        .Q(cmp_reg[7]),
        .R(1'b0));
  FDRE \cmp_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[8]_i_1_n_7 ),
        .Q(cmp_reg[8]),
        .R(1'b0));
  CARRY4 \cmp_reg[8]_i_1 
       (.CI(\cmp_reg[4]_i_1_n_0 ),
        .CO({\cmp_reg[8]_i_1_n_0 ,\cmp_reg[8]_i_1_n_1 ,\cmp_reg[8]_i_1_n_2 ,\cmp_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\cmp_reg[8]_i_1_n_4 ,\cmp_reg[8]_i_1_n_5 ,\cmp_reg[8]_i_1_n_6 ,\cmp_reg[8]_i_1_n_7 }),
        .S(cmp_reg[11:8]));
  FDRE \cmp_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cmp_reg[8]_i_1_n_6 ),
        .Q(cmp_reg[9]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \digit[0]_i_1 
       (.I0(HEX[8]),
        .I1(HEX[12]),
        .I2(HEX[0]),
        .I3(etat[1]),
        .I4(etat[0]),
        .I5(HEX[4]),
        .O(digit_0[0]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \digit[1]_i_1 
       (.I0(HEX[9]),
        .I1(HEX[13]),
        .I2(HEX[1]),
        .I3(etat[1]),
        .I4(etat[0]),
        .I5(HEX[5]),
        .O(digit_0[1]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \digit[2]_i_1 
       (.I0(HEX[10]),
        .I1(HEX[14]),
        .I2(HEX[2]),
        .I3(etat[1]),
        .I4(etat[0]),
        .I5(HEX[6]),
        .O(digit_0[2]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \digit[3]_i_1 
       (.I0(HEX[11]),
        .I1(HEX[15]),
        .I2(HEX[3]),
        .I3(etat[1]),
        .I4(etat[0]),
        .I5(HEX[7]),
        .O(digit_0[3]));
  FDRE \digit_reg[0] 
       (.C(CLK),
        .CE(ENABLE),
        .D(digit_0[0]),
        .Q(digit[0]),
        .R(1'b0));
  FDRE \digit_reg[1] 
       (.C(CLK),
        .CE(ENABLE),
        .D(digit_0[1]),
        .Q(digit[1]),
        .R(1'b0));
  FDRE \digit_reg[2] 
       (.C(CLK),
        .CE(ENABLE),
        .D(digit_0[2]),
        .Q(digit[2]),
        .R(1'b0));
  FDRE \digit_reg[3] 
       (.C(CLK),
        .CE(ENABLE),
        .D(digit_0[3]),
        .Q(digit[3]),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
