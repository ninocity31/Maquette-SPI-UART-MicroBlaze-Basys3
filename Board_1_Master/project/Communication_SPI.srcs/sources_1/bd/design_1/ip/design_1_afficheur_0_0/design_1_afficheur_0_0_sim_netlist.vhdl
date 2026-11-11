-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sun Nov  8 15:52:41 2026
-- Host        : ASUS running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               C:/work/Communication_SPI/Communication_SPI.srcs/sources_1/bd/design_1/ip/design_1_afficheur_0_0/design_1_afficheur_0_0_sim_netlist.vhdl
-- Design      : design_1_afficheur_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_afficheur_0_0_afficheur is
  port (
    SEPT_SEG : out STD_LOGIC_VECTOR ( 6 downto 0 );
    AN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    CLK : in STD_LOGIC;
    HEX : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_afficheur_0_0_afficheur : entity is "afficheur";
end design_1_afficheur_0_0_afficheur;

architecture STRUCTURE of design_1_afficheur_0_0_afficheur is
  signal \AN[0]_i_1_n_0\ : STD_LOGIC;
  signal \AN[1]_i_1_n_0\ : STD_LOGIC;
  signal \AN[2]_i_1_n_0\ : STD_LOGIC;
  signal \AN[3]_i_1_n_0\ : STD_LOGIC;
  signal ENABLE : STD_LOGIC;
  signal ENABLE_i_2_n_0 : STD_LOGIC;
  signal ENABLE_i_3_n_0 : STD_LOGIC;
  signal \FSM_sequential_etat[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_etat[1]_i_1_n_0\ : STD_LOGIC;
  signal \cmp[0]_i_2_n_0\ : STD_LOGIC;
  signal cmp_reg : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal \cmp_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \cmp_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \cmp_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \cmp_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \cmp_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \cmp_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \cmp_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal digit : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal digit_0 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal etat : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal p_0_in : STD_LOGIC;
  signal \NLW_cmp_reg[12]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_cmp_reg[12]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \AN[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \AN[1]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \AN[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \AN[3]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \FSM_sequential_etat[0]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \FSM_sequential_etat[1]_i_1\ : label is "soft_lutpair5";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_etat_reg[0]\ : label is "dig1:00,dig2:01,dig3:10,dig4:11";
  attribute FSM_ENCODED_STATES of \FSM_sequential_etat_reg[1]\ : label is "dig1:00,dig2:01,dig3:10,dig4:11";
  attribute SOFT_HLUTNM of \SEPT_SEG[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \SEPT_SEG[1]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \SEPT_SEG[2]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \SEPT_SEG[3]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \SEPT_SEG[5]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \SEPT_SEG[6]_INST_0\ : label is "soft_lutpair0";
begin
\AN[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => etat(1),
      I1 => etat(0),
      O => \AN[0]_i_1_n_0\
    );
\AN[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => etat(0),
      I1 => etat(1),
      O => \AN[1]_i_1_n_0\
    );
\AN[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => etat(1),
      I1 => etat(0),
      O => \AN[2]_i_1_n_0\
    );
\AN[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => etat(1),
      I1 => etat(0),
      O => \AN[3]_i_1_n_0\
    );
\AN_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \AN[0]_i_1_n_0\,
      Q => AN(0),
      R => '0'
    );
\AN_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \AN[1]_i_1_n_0\,
      Q => AN(1),
      R => '0'
    );
\AN_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \AN[2]_i_1_n_0\,
      Q => AN(2),
      R => '0'
    );
\AN_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \AN[3]_i_1_n_0\,
      Q => AN(3),
      R => '0'
    );
ENABLE_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => ENABLE_i_2_n_0,
      I1 => cmp_reg(0),
      I2 => cmp_reg(1),
      I3 => ENABLE_i_3_n_0,
      O => p_0_in
    );
ENABLE_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000200000000000"
    )
        port map (
      I0 => cmp_reg(10),
      I1 => cmp_reg(11),
      I2 => cmp_reg(8),
      I3 => cmp_reg(9),
      I4 => cmp_reg(12),
      I5 => cmp_reg(13),
      O => ENABLE_i_2_n_0
    );
ENABLE_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000002"
    )
        port map (
      I0 => cmp_reg(4),
      I1 => cmp_reg(5),
      I2 => cmp_reg(2),
      I3 => cmp_reg(3),
      I4 => cmp_reg(7),
      I5 => cmp_reg(6),
      O => ENABLE_i_3_n_0
    );
ENABLE_reg: unisim.vcomponents.FDPE
     port map (
      C => CLK,
      CE => '1',
      D => '0',
      PRE => p_0_in,
      Q => ENABLE
    );
\FSM_sequential_etat[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => etat(0),
      O => \FSM_sequential_etat[0]_i_1_n_0\
    );
\FSM_sequential_etat[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => etat(0),
      I1 => etat(1),
      O => \FSM_sequential_etat[1]_i_1_n_0\
    );
\FSM_sequential_etat_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \FSM_sequential_etat[0]_i_1_n_0\,
      Q => etat(0),
      R => '0'
    );
\FSM_sequential_etat_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => \FSM_sequential_etat[1]_i_1_n_0\,
      Q => etat(1),
      R => '0'
    );
\SEPT_SEG[0]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2094"
    )
        port map (
      I0 => digit(3),
      I1 => digit(2),
      I2 => digit(0),
      I3 => digit(1),
      O => SEPT_SEG(0)
    );
\SEPT_SEG[1]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A4C8"
    )
        port map (
      I0 => digit(3),
      I1 => digit(2),
      I2 => digit(1),
      I3 => digit(0),
      O => SEPT_SEG(1)
    );
\SEPT_SEG[2]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A210"
    )
        port map (
      I0 => digit(3),
      I1 => digit(0),
      I2 => digit(1),
      I3 => digit(2),
      O => SEPT_SEG(2)
    );
\SEPT_SEG[3]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"C214"
    )
        port map (
      I0 => digit(3),
      I1 => digit(2),
      I2 => digit(0),
      I3 => digit(1),
      O => SEPT_SEG(3)
    );
\SEPT_SEG[4]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5710"
    )
        port map (
      I0 => digit(3),
      I1 => digit(1),
      I2 => digit(2),
      I3 => digit(0),
      O => SEPT_SEG(4)
    );
\SEPT_SEG[5]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5190"
    )
        port map (
      I0 => digit(3),
      I1 => digit(2),
      I2 => digit(0),
      I3 => digit(1),
      O => SEPT_SEG(5)
    );
\SEPT_SEG[6]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4025"
    )
        port map (
      I0 => digit(3),
      I1 => digit(0),
      I2 => digit(2),
      I3 => digit(1),
      O => SEPT_SEG(6)
    );
\cmp[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cmp_reg(0),
      O => \cmp[0]_i_2_n_0\
    );
\cmp_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[0]_i_1_n_7\,
      Q => cmp_reg(0),
      R => '0'
    );
\cmp_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \cmp_reg[0]_i_1_n_0\,
      CO(2) => \cmp_reg[0]_i_1_n_1\,
      CO(1) => \cmp_reg[0]_i_1_n_2\,
      CO(0) => \cmp_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \cmp_reg[0]_i_1_n_4\,
      O(2) => \cmp_reg[0]_i_1_n_5\,
      O(1) => \cmp_reg[0]_i_1_n_6\,
      O(0) => \cmp_reg[0]_i_1_n_7\,
      S(3 downto 1) => cmp_reg(3 downto 1),
      S(0) => \cmp[0]_i_2_n_0\
    );
\cmp_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[8]_i_1_n_5\,
      Q => cmp_reg(10),
      R => '0'
    );
\cmp_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[8]_i_1_n_4\,
      Q => cmp_reg(11),
      R => '0'
    );
\cmp_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[12]_i_1_n_7\,
      Q => cmp_reg(12),
      R => '0'
    );
\cmp_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cmp_reg[8]_i_1_n_0\,
      CO(3 downto 1) => \NLW_cmp_reg[12]_i_1_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \cmp_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 2) => \NLW_cmp_reg[12]_i_1_O_UNCONNECTED\(3 downto 2),
      O(1) => \cmp_reg[12]_i_1_n_6\,
      O(0) => \cmp_reg[12]_i_1_n_7\,
      S(3 downto 2) => B"00",
      S(1 downto 0) => cmp_reg(13 downto 12)
    );
\cmp_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[12]_i_1_n_6\,
      Q => cmp_reg(13),
      R => '0'
    );
\cmp_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[0]_i_1_n_6\,
      Q => cmp_reg(1),
      R => '0'
    );
\cmp_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[0]_i_1_n_5\,
      Q => cmp_reg(2),
      R => '0'
    );
\cmp_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[0]_i_1_n_4\,
      Q => cmp_reg(3),
      R => '0'
    );
\cmp_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[4]_i_1_n_7\,
      Q => cmp_reg(4),
      R => '0'
    );
\cmp_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cmp_reg[0]_i_1_n_0\,
      CO(3) => \cmp_reg[4]_i_1_n_0\,
      CO(2) => \cmp_reg[4]_i_1_n_1\,
      CO(1) => \cmp_reg[4]_i_1_n_2\,
      CO(0) => \cmp_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cmp_reg[4]_i_1_n_4\,
      O(2) => \cmp_reg[4]_i_1_n_5\,
      O(1) => \cmp_reg[4]_i_1_n_6\,
      O(0) => \cmp_reg[4]_i_1_n_7\,
      S(3 downto 0) => cmp_reg(7 downto 4)
    );
\cmp_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[4]_i_1_n_6\,
      Q => cmp_reg(5),
      R => '0'
    );
\cmp_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[4]_i_1_n_5\,
      Q => cmp_reg(6),
      R => '0'
    );
\cmp_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[4]_i_1_n_4\,
      Q => cmp_reg(7),
      R => '0'
    );
\cmp_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[8]_i_1_n_7\,
      Q => cmp_reg(8),
      R => '0'
    );
\cmp_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cmp_reg[4]_i_1_n_0\,
      CO(3) => \cmp_reg[8]_i_1_n_0\,
      CO(2) => \cmp_reg[8]_i_1_n_1\,
      CO(1) => \cmp_reg[8]_i_1_n_2\,
      CO(0) => \cmp_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cmp_reg[8]_i_1_n_4\,
      O(2) => \cmp_reg[8]_i_1_n_5\,
      O(1) => \cmp_reg[8]_i_1_n_6\,
      O(0) => \cmp_reg[8]_i_1_n_7\,
      S(3 downto 0) => cmp_reg(11 downto 8)
    );
\cmp_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => '1',
      D => \cmp_reg[8]_i_1_n_6\,
      Q => cmp_reg(9),
      R => '0'
    );
\digit[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => HEX(8),
      I1 => HEX(12),
      I2 => HEX(0),
      I3 => etat(1),
      I4 => etat(0),
      I5 => HEX(4),
      O => digit_0(0)
    );
\digit[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => HEX(9),
      I1 => HEX(13),
      I2 => HEX(1),
      I3 => etat(1),
      I4 => etat(0),
      I5 => HEX(5),
      O => digit_0(1)
    );
\digit[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => HEX(10),
      I1 => HEX(14),
      I2 => HEX(2),
      I3 => etat(1),
      I4 => etat(0),
      I5 => HEX(6),
      O => digit_0(2)
    );
\digit[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => HEX(11),
      I1 => HEX(15),
      I2 => HEX(3),
      I3 => etat(1),
      I4 => etat(0),
      I5 => HEX(7),
      O => digit_0(3)
    );
\digit_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => digit_0(0),
      Q => digit(0),
      R => '0'
    );
\digit_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => digit_0(1),
      Q => digit(1),
      R => '0'
    );
\digit_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => digit_0(2),
      Q => digit(2),
      R => '0'
    );
\digit_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => CLK,
      CE => ENABLE,
      D => digit_0(3),
      Q => digit(3),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_afficheur_0_0 is
  port (
    CLK : in STD_LOGIC;
    HEX : in STD_LOGIC_VECTOR ( 15 downto 0 );
    SEPT_SEG : out STD_LOGIC_VECTOR ( 6 downto 0 );
    AN : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_afficheur_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_afficheur_0_0 : entity is "design_1_afficheur_0_0,afficheur,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_afficheur_0_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of design_1_afficheur_0_0 : entity is "module_ref";
  attribute x_core_info : string;
  attribute x_core_info of design_1_afficheur_0_0 : entity is "afficheur,Vivado 2019.1";
end design_1_afficheur_0_0;

architecture STRUCTURE of design_1_afficheur_0_0 is
  attribute x_interface_info : string;
  attribute x_interface_info of CLK : signal is "xilinx.com:signal:clock:1.0 CLK CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of CLK : signal is "XIL_INTERFACENAME CLK, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_1_clk_out1, INSERT_VIP 0";
begin
U0: entity work.design_1_afficheur_0_0_afficheur
     port map (
      AN(3 downto 0) => AN(3 downto 0),
      CLK => CLK,
      HEX(15 downto 0) => HEX(15 downto 0),
      SEPT_SEG(6 downto 0) => SEPT_SEG(6 downto 0)
    );
end STRUCTURE;
