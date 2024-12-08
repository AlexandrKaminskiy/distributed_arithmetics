----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 00:58:10
-- Design Name: 
-- Module Name: top_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_2_rom_2_baat is
  generic (N : integer := 10; K: integer := 4);
  Port (X0 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X1 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X2 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X3 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0);
--             Q0_after_sum: out STD_LOGIC_VECTOR(N - 1 downto 0);
--             Q1_after_sum: out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q0: out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q1: out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end top_module_2_rom_2_baat;

architecture Behavioral of top_module_2_rom_2_baat is

--signal state: std_logic_vector := "0000";
--subtype tword is std_logic_vector (N - 1 downto 0);
type tprom is array (0 to 2 ** (K / 2) - 1) of std_logic_vector (N - 1 downto 0);
constant ROM0 : tprom := 
(
    "0000000000",
    "0000100000",
    "0001000000",
    "0001100000"
);
constant ROM1 : tprom := 
(
    "0000000000",
    "0001000000",
    "0001000000",
    "0010000000"
);
signal acc0: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
signal acc1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM1(0);

signal acc0_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
signal acc1_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);

signal counter: integer := 0;
signal da_enabled: std_logic := '1';

signal baat: integer := 2;
signal sign_bits: integer := 3;


begin

P1: process (CLK)
variable address0: std_logic_vector (K / 2 - 1 downto 0);
variable address0_shift_1: std_logic_vector (K / 2 - 1 downto 0);
variable address1: std_logic_vector (K / 2 - 1 downto 0);
variable address1_shift_1: std_logic_vector (K / 2 - 1 downto 0);

variable acc_temp0: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
variable acc_temp0_shift1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);

variable acc_temp1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM1(0);
variable acc_temp1_shift1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);


variable sign_bits0_shift_1: std_logic_vector(1 - 1 downto 0);
variable sign_bits0_shift_2: std_logic_vector(2 - 1 downto 0);


variable sign_bits1_shift_1: std_logic_vector(1 - 1 downto 0);
variable sign_bits1_shift_2: std_logic_vector(2 - 1 downto 0);


variable sign_bits1: std_logic_vector(1 - 1 downto 0);
variable value_from_rom: std_logic_vector (N - 1 downto 0);
begin
    if rising_edge(CLK) then
        if (da_enabled = '1') then
           if (counter = 8) then 
               counter <= 0;
               da_enabled <= '0';
           else
           
               address0_shift_1 := X0(counter) & X1(counter);
               address0 := X0(counter + 1) & X1(counter + 1);
               
               acc_temp0_shift1 := std_logic_vector(signed(ROM0(to_integer(unsigned(address0_shift_1)))));
               sign_bits0_shift_1 := (others => acc_temp0_shift1(acc_temp0_shift1'high));
               acc_temp0_shift1 := sign_bits0_shift_1 & acc_temp0_shift1(acc_temp0_shift1'length - 1 downto 1);
               if (counter + baat = N - baat) then
                  acc_temp0 := std_logic_vector(signed(acc0) - signed(ROM0(to_integer(unsigned(address0)))));
               else 
                  acc_temp0 := std_logic_vector(signed(ROM0(to_integer(unsigned(address0)))) + signed(acc0));
               end if;
               
               acc_temp0 := std_logic_vector(signed(acc_temp0) + signed(acc_temp0_shift1));
               acc0_after_sum <= acc_temp0;
               
               if (counter + baat /= N - baat) then
                   sign_bits0_shift_2 := (others => acc_temp0(acc_temp0'high));
                   acc_temp0 := sign_bits0_shift_2 & acc_temp0(acc_temp0'length - 1 downto sign_bits0_shift_2'length);
               end if;
               
               acc0 <= acc_temp0;
                



               address1_shift_1 := X2(counter) & X3(counter);
               address1 := X2(counter + 1) & X3(counter + 1);
               
               acc_temp1_shift1 := std_logic_vector(signed(ROM1(to_integer(unsigned(address1_shift_1)))));
               sign_bits1_shift_1 := (others => acc_temp1_shift1(acc_temp1_shift1'high));
               acc_temp1_shift1 := sign_bits1_shift_1 & acc_temp1_shift1(acc_temp1_shift1'length - 1 downto 1);
               if (counter + baat = N - baat) then
                  acc_temp1 := std_logic_vector(signed(acc1) - signed(ROM1(to_integer(unsigned(address1)))));
               else 
                  acc_temp1 := std_logic_vector(signed(ROM0(to_integer(unsigned(address1)))) + signed(acc1));
               end if;
               
               acc_temp1 := std_logic_vector(signed(acc_temp1) + signed(acc_temp1_shift1));
               acc1_after_sum <= acc_temp1;
               
               if (counter + baat /= N - baat) then
                   sign_bits1_shift_2 := (others => acc_temp1(acc_temp1'high));
                   acc_temp1 := sign_bits1_shift_2 & acc_temp1(acc_temp1'length - 1 downto sign_bits1_shift_2'length);
               end if;
               
               acc1 <= acc_temp1;
                

               counter <= counter + baat;
           end if;  
        end if;        
    end if;
end process;

Q0 <= acc0;
Q1 <= acc1;
Q <= std_logic_vector(signed(acc0) + signed(acc1));
end Behavioral;
