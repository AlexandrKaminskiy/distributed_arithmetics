----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2024 02:47:43
-- Design Name: 
-- Module Name: behavioral - Behavioral
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

entity behavioral is
  Port (
    CLK: in std_logic
  );
end behavioral;

architecture Behavioral of behavioral is

signal state: std_logic_vector := "0000";
begin

P1: process (CLK)
begin
    if (rising_edge(CLK) = '1') then
        if (state = "0000") then
            state <= "0001";
        else if( state = "0001" ) then
            state <= "0010";
        else if (state = "0010") then
            state <= "0100";
        else if (state = "0100") then
            state <= "0001";    
        else
            state <= "0000";
        end if;
    end if;
end process;

end behavioral;
