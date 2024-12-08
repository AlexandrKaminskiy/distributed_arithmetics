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

entity top_module_2_rom_diff_filter_biased_bin_code is
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
end top_module_2_rom_diff_filter_biased_bin_code;

architecture Behavioral of top_module_2_rom_diff_filter_biased_bin_code is

type tprom is array (0 to 1, 0 to K - 1) of std_logic_vector (N - 1 downto 0);
constant ROM : tprom := 
(
    (
        "1100000010100100", "1110000001010010", "1110000001010010", "0000000000000000", "1110000001010010", "0000000000000000", "0000000000000000", "0001111110101110"
    ),
    (
        "1100000010100100", "1110000001010010", "1110000001010010", "0000000000000000", "1110000001010010", "0000000000000000", "0000000000000000", "0001111110101110"
    )
);

signal acc0: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM(0, 0);
signal acc1: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM(1, 0);

--signal acc0_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM0(0);
--signal acc1_after_sum: STD_LOGIC_VECTOR(N - 1 downto 0) := ROM1(0);

signal counter: integer := 0;
signal da_enabled: std_logic := '1';
constant baat: integer := 2;
constant neg_address: std_logic_vector (K / baat - 1 downto 0) := (others => '1');
constant zero_value: std_logic_vector (N - 1 downto 0) := (others => '0');


function get_acc_value(
    addr: std_logic_vector(K / baat - 1 downto 0); 
    shift: integer; 
    nrom: integer;
    acc: std_logic_vector(N - 1 downto 0);
    ts: std_logic
) return std_logic_vector is
variable result: std_logic_vector(N - 1 downto 0);
variable sign_bits : std_logic_vector(shift - 1 downto 0);-- = (others => acc_temp0(acc_temp0'high));
variable value: std_logic_vector(N - 1 downto 0);
variable address: std_logic_vector(K / baat - 1 downto 0);
variable address_from_addr0: std_logic_vector(K / baat - 1 downto 0) := (others => addr(1));
variable op: std_logic;
begin
-- addr(1 downto N) xor addr(0)
-- op = Ts xor addr(0)     === 0 -> +, 2 -> -1
    if (addr(K / 2 - 1) = '1') then
       address := addr xor neg_address;
       value := std_logic_vector(-signed(ROM(nrom, to_integer(unsigned(address)))));
    else 
       address := addr;
       value := std_logic_vector(signed(ROM(nrom, to_integer(unsigned(address)))));
    end if;

    if (ts = '0') then
        result := std_logic_vector(signed(acc) + signed(value));
        sign_bits := (others => result(result'high));
        result := sign_bits & result(result'length - 1 downto sign_bits'length);
    else
        result := std_logic_vector(signed(acc) - signed(value));
    end if;
    
    return result;
end function;


--function add_and_conditional_shift(
--    a: std_logic_vector(N - 1 downto 0);
--    b: std_logic_vector(N - 1 downto 0);
--    shift: integer;
--    ts: std_logic
--) return std_logic_vector is
--variable result: std_logic_vector(N - 1 downto 0);
--variable sign_bits : std_logic_vector(shift - 1 downto 0);-- = (others => acc_temp0(acc_temp0'high));
--begin

--    result := std_logic_vector(signed(a) + signed(b));
--    if (ts = '0') then
--        sign_bits := (others => result(result'high));
--        result := sign_bits & result(result'length - 1 downto sign_bits'length);
--    end if;
--    return result;
--end function;


begin

P1: process (CLK)
variable value00: std_logic_vector(N - 1 downto 0);
variable value01: std_logic_vector(N - 1 downto 0);

variable value10: std_logic_vector(N - 1 downto 0);
variable value11: std_logic_vector(N - 1 downto 0);
variable acc0_var: std_logic_vector(N - 1 downto 0) := acc0;
variable acc1_var: std_logic_vector(N - 1 downto 0) := acc1;
variable counter_var: integer := counter;

variable ts: std_logic;
begin
    if rising_edge(CLK) then
        if (da_enabled = '1') then
           counter_var := counter;
           acc0_var := acc0;
           acc1_var := acc1;

           if (counter_var = N) then 
               counter_var := 0;
               acc0_var := ROM(0, 0);
               acc1_var := ROM(1, 0);
--               da_enabled <= '0';
            end if;
--           else
               if (counter_var + baat = N) then
                   ts := '1';
               else 
                   ts := '0';
               end if;
               
               value00 := get_acc_value(X0(counter_var) & X1(counter_var) & X2(counter_var) & X3(counter_var), 1, 0, acc0_var, '0');
               value01 := get_acc_value(X0(counter_var + 1) & X1(counter_var + 1) & X2(counter_var + 1) & X3(counter_var + 1), 1, 0, value00, ts);
               acc0 <= value01;
                
--                value00 := get_acc_value(X0(counter) & X1(counter), 1, 0, zero_value, '0');
--                value01 := get_acc_value(X0(counter + 1) & X1(counter + 1), 0, 0, acc0, ts);
--                acc0 <= add_and_conditional_shift(value00, value01, 2, ts);
               value10 := get_acc_value(X4(counter_var) & X5(counter_var) & X6(counter_var) & X7(counter_var), 1, 1, acc1_var, '0');
               value11 := get_acc_value(X4(counter_var + 1) & X5(counter_var + 1) & X6(counter_var + 1) & X7(counter_var + 1), 1, 1, value10, ts);
               acc1 <= value11;
               
--               value10 := get_acc_value(X2(counter) & X3(counter), 1, 0, zero_value, '0');
--               value11 := get_acc_value(X2(counter + 1) & X3(counter + 1), 0, 0, acc1, ts);
--               acc1 <= add_and_conditional_shift(value11, value10, 2, ts);
               
               counter <= counter_var + baat;
--           end if;  
        end if;        
    end if;
end process;

Q <= std_logic_vector(signed(acc0) + signed(acc1));
q0 <= acc0;
q1 <= acc1;
end Behavioral;
