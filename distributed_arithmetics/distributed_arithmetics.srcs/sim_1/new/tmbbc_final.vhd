----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2024 00:20:45
-- Design Name: 
-- Module Name: tmbbc_final - Behavioral
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

entity tmbbc_final is
--  Port ( );
end tmbbc_final;

architecture Behavioral of tmbbc_final is

component top_module_2_rom_diff_filter_biased_bin_code is
  generic (N : integer := 16; K: integer := 8);
  Port (X0 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X1 : in STD_LOGIC_VECTOR (N - 1 downto 0);
            X2 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X3 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X4 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X5 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X6 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X7 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q0 : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q1 : out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end component;

constant n: integer := 16;

--"000010111000", "000001100110", "000011001100", "000110011001"
--["000001111010", "000011010111", "000010011001", "000100000000"]
--"111110000110", "111100101001", "111101100111", "111100000000"
--['111110000000', '111100000000', '111110000000', '111100000000']
--["0001111110101110", "0001110000101000", "0001111110101110", "0001111110101110", "0001111110101110", "0001110000101000", "0000001111010111", "0001010100011110"]
signal x0: std_logic_vector (n - 1 downto 0) := "0001111110101110";-- 0,25
signal x1: std_logic_vector (n - 1 downto 0) := "0001110000101000";-- 0,25
signal x2: std_logic_vector (n - 1 downto 0) := "0001111110101110";-- 0,75
signal x3: std_logic_vector (n - 1 downto 0) := "0001111110101110";-- -0.50

signal x4: std_logic_vector (n - 1 downto 0) := "0001111110101110";-- 0,25
signal x5: std_logic_vector (n - 1 downto 0) := "0001110000101000";-- 0,25
signal x6: std_logic_vector (n - 1 downto 0) := "0000001111010111";-- 0,75
signal x7: std_logic_vector (n - 1 downto 0) := "0001010100011110";-- -0.50

signal s_q: std_logic_vector (n - 1 downto 0);
signal s_q0: std_logic_vector (n - 1 downto 0);
signal s_q1: std_logic_vector (n - 1 downto 0);
signal s_clk: std_logic := '0';

constant result: std_logic_vector (n - 1 downto 0) := "0000001111010111";

signal correct: std_logic_vector (n - 1 downto 0) := (others => '1');

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

top_m: top_module_2_rom_diff_filter_biased_bin_code port map (x0, x1, x2, x3, x4, x5, x6, x7, s_clk, s_q, s_q0, s_q1);
correct <= s_q xor result;
end Behavioral;
