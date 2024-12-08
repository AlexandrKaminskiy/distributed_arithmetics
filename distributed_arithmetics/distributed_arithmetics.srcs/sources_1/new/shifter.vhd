----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 11:46:08
-- Design Name: 
-- Module Name: shifter - Behavioral
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



entity shifter is
    generic (N: integer := 8; shift_amount: integer := 1); 
    Port ( A : in STD_LOGIC_VECTOR (N - 1 downto 0);
           Q : out STD_LOGIC_VECTOR(N - 1 downto 0));
end shifter;

architecture Behavioral of shifter is

--    function arith_shift_right(val: signed; shift_amount: integer)
--    return signed is
--        variable result: signed(val'length - 1 downto 0);
--        begin
--        if shift_amount > 0 then
--            result(val'length - shift_amount - 1 downto 0) := val((val'length - 1) downto shift_amount);
--            result(val'length - 1 downto val'length - shift_amount) := (others => val(val'high));
--        else
--            result := val;
--        end if;        
--        return result;
--    end function;

signal sign_bits: std_logic_vector(shift_amount - 1 downto 0); 
begin
sign_bits <= (others => A(A'high));
Q <= sign_bits & A(A'length - 1 downto shift_amount);

    
end Behavioral;
