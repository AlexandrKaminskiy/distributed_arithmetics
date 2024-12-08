----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 00:58:10
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module_biased_binary_code is
  generic (N : integer := 8; K: integer := 2);
  Port (X0 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             X1 : in STD_LOGIC_VECTOR (N - 1 downto 0);
             CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end top_module_biased_binary_code;

architecture Behavioral of top_module_biased_binary_code is

component shifter
    generic (N: integer := 8; shift_amount: integer := 1); 
    Port ( A : in STD_LOGIC_VECTOR (N - 1 downto 0);
           Q : out STD_LOGIC_VECTOR(N - 1 downto 0));
end component; 

component sum_n
    generic (N: integer := 8);
    Port (
        A: in std_logic_vector(N - 1 downto 0);
        B: in std_logic_vector(N - 1 downto 0);   
        Q: out std_logic_vector(N - 1 downto 0)
    );
end component; 

--signal state: std_logic_vector := "0000";
--subtype tword is std_logic_vector (N - 1 downto 0);
type tprom is array (0 to (2 ** K / 2) - 1) of std_logic_vector (N - 1 downto 0);
constant ROM : tprom := 
(
    "11100000",
    "00000000"
);
signal da_anabled: std_logic := '1';
signal acc: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM(0);
signal acc_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM(0);
signal neg_address: std_logic_vector (K - 1 downto 0) := (others => '1');
signal counter: integer := 0;

begin

P1: process (CLK)
variable address: std_logic_vector (K - 1 downto 0);
variable acc_temp: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM(0);
variable sign_bits: std_logic_vector(1 - 1 downto 0);
variable value: std_logic_vector(N - 1 downto 0);

begin
    if rising_edge(CLK) then
        if (da_anabled = '1') then
           if (counter = 7) then
               da_anabled <= '0';  
           elsif (counter = 6) then
               address := X0(counter) & X1(counter);
               if (X0(counter) = '1') then
                   address := address xor neg_address;
                   value := std_logic_vector(-signed(ROM(to_integer(unsigned(address)))));
               else 
                   value := std_logic_vector(signed(ROM(to_integer(unsigned(address)))));
               end if;
               acc <= std_logic_vector(signed(acc) - signed(value));
               --acc <= std_logic_vector(resize(signed(acc), acc'length) - resize(signed(ROM(to_integer(unsigned(address)))), acc'length));
               --acc <= std_logic_vector(resize(signed(acc) - signed(ROM(to_integer(unsigned(address)))), acc'length));
               counter <= counter + 1;
           else
               address := X0(counter) & X1(counter);
               if (X0(counter) = '1') then
                   address := address xor neg_address;
                   value := std_logic_vector(-signed(ROM(to_integer(unsigned(address)))));
               else 
                   value := std_logic_vector(signed(ROM(to_integer(unsigned(address)))));
               end if;
               acc_temp := std_logic_vector(signed(value) + signed(acc));
               acc_after_sum <= acc_temp;
               sign_bits := (others => acc_temp(acc_temp'high));
               acc <= sign_bits & acc_temp(acc_temp'length - 1 downto 1);
               counter <= counter + 1;
           end if;  
        end if;        
    end if;
end process;

Q <= acc;
end Behavioral;

