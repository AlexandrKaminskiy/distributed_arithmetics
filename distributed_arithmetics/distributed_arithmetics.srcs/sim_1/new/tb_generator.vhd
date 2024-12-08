----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2024 13:06:31
-- Design Name: 
-- Module Name: tb_generator - Behavioral
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

entity tb_generator is
--  Port ( );
end tb_generator;

architecture Behavioral of tb_generator is

component top_module_generator is
generic (N : integer := 16; K: integer := 8);
Port (CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q0 : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q1 : out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end component;

constant n: integer := 16;
signal s_clk: std_logic := '0';
signal s_q: STD_LOGIC_VECTOR(n - 1 downto 0) := "0000000000000000";
signal s_q0: STD_LOGIC_VECTOR(n - 1 downto 0) := "0000000000000000";
signal s_q1: STD_LOGIC_VECTOR(n - 1 downto 0) := "0000000000000000";

begin

clk_proc: process
begin
    s_clk <= not s_clk;
    wait for 40ns;
end process;

top_m: top_module_generator port map (s_clk, s_q, s_q0, s_q1);

end Behavioral;
