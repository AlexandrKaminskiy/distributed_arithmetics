----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2024 00:08:45
-- Design Name: 
-- Module Name: tb_shift_register - Behavioral
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

entity tb_shift_register is
--  Port ( );
end tb_shift_register;



architecture Behavioral of tb_shift_register is

component shift_register
    Generic (N: integer := 32);   
    Port ( 
       Din : in  STD_LOGIC_VECTOR(N - 1 downto 0);
           Se : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Dout : out  std_logic_vector(n - 1 downto 0));

end component;

constant clock_period : time := 20 ns;
signal inp: std_logic_vector(4 downto 0) := "10000";
signal outp: std_logic_vector(4 downto 0);
signal se: std_logic;
signal clk: std_logic;
signal rst: std_logic;

begin
clock_process: process
    begin
    clk <= '0';
    wait for clock_period/2;
    clk <= '1';
    wait for clock_period/2;
end process;

U2: shift_register port map
(
 Din=>inp,
 Se=>'1',
 Clk=>Clk,
 Rst=>'0',
 Dout=>inp
);

end Behavioral;
