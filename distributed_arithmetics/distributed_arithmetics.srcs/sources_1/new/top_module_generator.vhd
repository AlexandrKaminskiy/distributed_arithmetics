----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2024 02:46:36
-- Design Name: 
-- Module Name: top_module_generator - Behavioral
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

entity top_module_generator is
generic (N : integer := 16; K: integer := 8);
Port (CLK: in std_logic;
             Q : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q0 : out STD_LOGIC_VECTOR(N - 1 downto 0);
             Q1 : out STD_LOGIC_VECTOR(N - 1 downto 0)
             );
end top_module_generator;

architecture Behavioral of top_module_generator is


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

type val_arr is array (0 to K - 1) of std_logic_vector (N - 1 downto 0);
signal x_array : val_arr := 
(
    "0001111110101110", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"
);

constant baat: integer := 2;

signal counter: integer := 0;
signal mod_value: integer := N / baat;
signal s_q: STD_LOGIC_VECTOR (N - 1 downto 0);
signal result: STD_LOGIC_VECTOR (N - 1 downto 0);

signal current_value_in_array: integer := 1;
signal start: std_logic := '0';
begin

GEN: process (CLK)
begin
    if (rising_edge(CLK)) then
        if ((counter) mod mod_value = 0) then
            if (start = '1') then
                x_array(0) <= s_q;
                x_array(1 to x_array'length - 1) <= x_array(0 to x_array'length - 2);
                result <= s_q;
                current_value_in_array <= ((current_value_in_array + 1) mod K);
            else
                start <= '1';
            end if;
        end if;
        counter <= counter + 1;
    end if;
end process;

FILTER: top_module_2_rom_diff_filter_biased_bin_code port map (
    X0 => x_array(0),
    X1 => x_array(1), 
    X2 => x_array(2), 
    X3 => x_array(3), 
    X4 => x_array(4), 
    X5 => x_array(5), 
    X6 => x_array(6),
    X7 => x_array(7),
    CLK => CLK, 
    Q => s_q,
    Q0 => Q0, 
    Q1 => Q1);
q <= result;    
end Behavioral;
