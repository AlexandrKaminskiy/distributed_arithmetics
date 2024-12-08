----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2024 13:09:32
-- Design Name: 
-- Module Name: sub_n - Behavioral
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

entity sub_n is
    generic (N: integer := 8);
Port (
    A: in std_logic_vector(N - 1 downto 0);
    B: in std_logic_vector(N - 1 downto 0);   
    Q: out std_logic_vector(N - 1 downto 0)
);
end sub_n;

architecture Behavioral of sub_n is

begin
--Q <= std_logic_vector(resize(signed(A), Q'length) - resize(signed(B), Q'length));
Q <= std_logic_vector(signed(a) - signed(B));


end Behavioral;
