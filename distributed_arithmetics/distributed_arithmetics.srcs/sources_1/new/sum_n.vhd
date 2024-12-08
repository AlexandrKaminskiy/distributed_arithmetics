----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2024 02:03:38
-- Design Name: 
-- Module Name: sum_n - Behavioral
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

entity sum_n is
    generic (N: integer := 8);
    Port (
        A: in std_logic_vector(N - 1 downto 0);
        B: in std_logic_vector(N - 1 downto 0);   
        Q: out std_logic_vector(N - 1 downto 0)
    );
end sum_n;
    
architecture Behavioral of sum_n is
--component sum
--    port (
--        A, B, Oi: in std_logic;
--        S, Oo: out std_logic
--    );
--end component;  

--signal o_s: std_logic := '0';

begin

--SUM1: sum port map (A(0), B(0), '0', Q(0), o_s);

--SUMM: FOR I IN 1 TO N - 2 GENERATE
--    SUMn: sum port map (A(I), B(I), o_s, Q(I), o_s);
--END GENERATE;

--SUM_LAST: sum port map (A(N - 1), B(N - 1), o_s, Q(N - 1), O);

Q <= std_logic_vector(signed(A) + signed(B));


end Behavioral;
