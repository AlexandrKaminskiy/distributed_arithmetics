----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2024 00:05:39
-- Design Name: 
-- Module Name: sum - Behavioral
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

entity sum is
    Port ( A  : in std_logic;
           B  : in std_logic;
           Oi : in std_logic;
           Oo : out std_logic;
           S  : out std_logic);
end sum;

architecture Behavioral of sum is

begin
S <= (not A and not B and Oi) or (not A and B and not Oi) or (A and not B and not Oi) or (A and B and Oi);
Oo <= (not A and B and Oi) or (A and not B and Oi) or (A and B and not Oi) or (A and B and Oi);

end Behavioral;
