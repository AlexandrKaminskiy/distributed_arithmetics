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

entity top_module_2_rom is
  generic (N : integer := 8; K: integer := 4);
  Port (X0 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X1 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X2 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X3 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end top_module_2_rom;

architecture Behavioral of top_module_2_rom is

component shifter
    generic (N: integer := 8; shift_amount: integer := 1); 
    Port ( A : in STD_LOGIC_VECTOR (N - 1 downto 0);
           Q : out STD_LOGIC_VECTOR(N - 1 downto 0));
end component; 

component sum_n
    generic (N: integer := 8);
    Port (
        A: in std_logic_vector(N - 1 downto 0);
        B: in std_logic_vector(N - 1 downto 0);   
        Q: out std_logic_vector(N - 1 downto 0)
    );
end component; 

--signal state: std_logic_vector := "0000";
--subtype tword is std_logic_vector (N - 1 downto 0);
type tprom is array (0 to 2 ** (K / 2) - 1) of std_logic_vector (N - 1 downto 0);
constant ROM0 : tprom := 
(
    "00000000",
    "00001000",
    "00010000",
    "00011000"
);
constant ROM1 : tprom := 
(
    "00000000",
    "00001000",
    "00010000",
    "00011000"
);
signal acc0: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
signal acc1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM1(0);

signal acc0_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
signal acc1_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);

signal counter: integer := 0;
signal da_enabled: std_logic := '1';

begin

P1: process (CLK)
variable address0: std_logic_vector (K / 2 - 1 downto 0);
variable address1: std_logic_vector (K / 2 - 1 downto 0);
variable acc_temp0: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
variable acc_temp1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM1(0);
variable sign_bits0: std_logic_vector(1 - 1 downto 0);
variable sign_bits1: std_logic_vector(1 - 1 downto 0);
variable value_from_rom: std_logic_vector (N - 1 downto 0);
begin
    if rising_edge(CLK) then
        if (da_enabled = '1') then
           if (counter = 6) then 
               counter <= 0;
               da_enabled <= '0';
           elsif (counter = 5) then
               address0 := X0(counter) & X1(counter);
               acc0 <= std_logic_vector(signed(acc0) - signed(ROM0(to_integer(unsigned(address0)))));
               address1 := X2(counter) & X3(counter);
               acc1 <= std_logic_vector(signed(acc1) - signed(ROM1(to_integer(unsigned(address1)))));
               counter <= counter + 1;
           else
               address0 := X0(counter) & X1(counter);
               acc_temp0 := std_logic_vector(signed(ROM0(to_integer(unsigned(address0)))) + signed(acc0));
               address1 := X2(counter) & X3(counter);
               acc_temp1 := std_logic_vector(signed(ROM1(to_integer(unsigned(address1)))) + signed(acc1));
               
               acc0_after_sum <= acc_temp0;
               acc1_after_sum <= acc_temp1;

               sign_bits0 := (others => acc_temp0(acc_temp0'high));
               sign_bits1 := (others => acc_temp1(acc_temp1'high));

               acc0 <= sign_bits0 & acc_temp0(acc_temp0'length - 1 downto 1);
               acc1 <= sign_bits0 & acc_temp1(acc_temp1'length - 1 downto 1);
               counter <= counter + 1;
           end if;  
        end if;        
    end if;
end process;

Q <= std_logic_vector(signed(acc0) + signed(acc1));
end Behavioral;
