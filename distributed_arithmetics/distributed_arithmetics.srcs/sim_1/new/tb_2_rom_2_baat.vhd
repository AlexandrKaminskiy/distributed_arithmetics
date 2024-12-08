----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2024 14:12:03
-- Design Name: 
-- Module Name: tb_2_rom - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_2_rom_2_baat is
--  Port ( );
end tb_2_rom_2_baat;

architecture Behavioral of tb_2_rom_2_baat is

component top_module_2_rom_2_baat
--    generic (N: integer := 8; shift_amount: integer := 1); 
--    Port ( A : in STD_LOGIC_VECTOR (N - 1 downto 0);
--           Q : out STD_LOGIC_VECTOR(N - 1 downto 0));
      generic (N : integer := 10; K: integer := 4);
           Port (X0 : in STD_LOGIC_VECTOR (N - 1 downto 0);
                     X1 : in STD_LOGIC_VECTOR (N - 1 downto 0);
                     X2 : in STD_LOGIC_VECTOR (N - 1 downto 0);
                      X3 : in STD_LOGIC_VECTOR (N - 1 downto 0);
                      CLK: in std_logic;
                      Q : out STD_LOGIC_VECTOR(N - 1 downto 0);
                      Q0: out STD_LOGIC_VECTOR(N - 1 downto 0);
                      Q1: out STD_LOGIC_VECTOR(N - 1 downto 0)
                      );       
end component;

signal s_clk: std_logic := '1';
--signal x0: std_logic_vector (9 downto 0) := "0001100000";-- 0.75
--signal x1: std_logic_vector (9 downto 0) := "1111000000";-- -0.50
--signal x2: std_logic_vector (9 downto 0) := "0001100000";-- 0,75
--signal x3: std_logic_vector (9 downto 0) := "1111000000";-- -0.50

signal x0: std_logic_vector (9 downto 0) := "1110010000";-- -0.875
signal x1: std_logic_vector (9 downto 0) := "1111000000";-- -0.50
signal x2: std_logic_vector (9 downto 0) := "0001100000";-- 0,75
signal x3: std_logic_vector (9 downto 0) := "1111000000";-- -0.50

signal s_q: std_logic_vector (9 downto 0);
signal s_q0: std_logic_vector (9 downto 0);
signal s_q1: std_logic_vector (9 downto 0);

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

top_m: top_module_2_rom_2_baat port map (x0, x1, x2, x3, s_clk, s_q, s_q0, s_q1);

end Behavioral;