--------------------------------------------------------------------------------
-- afficheur.vhd -- 4-digit multiplexed 7-segment display driver (Basys 3)
--
-- Shows the 16-bit input HEX as 4 hexadecimal digits.
-- ENABLE (digit scan) is generated internally: one pulse every 10 000 clock
-- cycles, i.e. 100 MHz / 10 000 = 10 kHz, so 2.5 kHz per digit (no flicker).
-- Segments and anodes are active low.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity afficheur is
    Port (CLK : in std_logic;
          HEX : in std_logic_vector(15 downto 0);
          SEPT_SEG : out std_logic_vector(6 downto 0);
          AN : out std_logic_vector(3 downto 0)
          );
end afficheur;

architecture Behavioral of afficheur is

	type T_ETAT is (dig1, dig2, dig3, dig4);
	signal etat : T_ETAT := dig1;
	signal digit: std_logic_vector(3 downto 0);
	signal ENABLE : std_logic := '0';
	constant CMP_MAX : integer := 9999;            -- 10 000 cycles
	signal cmp : integer range 0 to CMP_MAX := 0;

begin

	with digit SELect
   SEPT_SEG<=
         "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

    -- ENABLE generation: one-cycle pulse every CMP_MAX+1 clock cycles
    process (CLK)
    begin
        if CLK'event and CLK = '1' then
            if cmp = CMP_MAX then
                cmp    <= 0;
                ENABLE <= '1';
            else
                cmp    <= cmp + 1;
                ENABLE <= '0';
            end if;
        end if;
    end process;

	process(CLK)
	begin
        if CLK'event and CLK='1' then
          if ENABLE = '1' then
	          case etat is
	          when dig1 => 	AN <= "0111";
	               digit <= HEX(15 downto 12);
	               etat <= dig2;
	          when dig2 => 	AN <= "1011";
	               digit <= HEX(11 downto 8);
	               etat <= dig3;
	          when dig3 => 	AN <= "1101";
	               digit <= HEX(7 downto 4);
	               etat <= dig4;
	          when dig4 => 	AN <= "1110";
	               digit <= HEX(3 downto 0);
	               etat <= dig1;
	          end case;
          end if;
        end if;
	end process;

end Behavioral;
