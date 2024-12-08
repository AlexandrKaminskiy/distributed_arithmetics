----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2023 19:52:26
-- Design Name: 
-- Module Name: shift_register - Behavioral
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_register is
    Generic (N: integer := 32);
   
    Port ( 
       Din : in  STD_LOGIC_VECTOR(N - 1 downto 0);
           Se : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Dout : out  std_logic_vector(n - 1 downto 0));

end shift_register;

architecture Behavioral of shift_register is
  signal sdat: std_logic_vector(n-1 downto 0);
begin

  Left: process (CLK, RST, sdat)
  begin
    if RST = '1' then
      sdat <= (others => '0');
    elsif (SE = '1') then
      if rising_edge(CLK) then
        sdat <= Din(0) & Din(n-1 downto 1);
      end if;
    end if;
  end process;
  
  Dout <= sdat;
end Behavioral;