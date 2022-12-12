------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Program counter
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Program counter that provides instruction number to the program memory.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY PROGRAM_COUNTER
--------------------------------------------------------------------------------
entity Program_counter is
    port(
        in_clk   : in std_logic;
        in_reset : in std_logic;

        in_next_instruction     : in  std_logic_vector(15 downto 0);
        out_current_instruction : out std_logic_vector(15 downto 0)
    );
end Program_counter;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF PROGRAM_COUNTER
--------------------------------------------------------------------------------
architecture Program_counter of Program_counter is
    signal s_next_instruction : std_logic_vector(15 downto 0) := (others => '0');

begin

    ----------------------------------------
    -- PREPARE NEXT INSTRUCTION
    ----------------------------------------
    LOAD_INSTRUCTION: process(in_clk) begin
        if in_clk'event and in_clk='1' then
            if in_reset = '1' then
                s_next_instruction <= (others => '0');
            else
                if to_integer(unsigned(in_next_instruction)) > PROG_MEM_MAX_NUMBER_OF_INSTRUCTIONS - 1 then
                    s_next_instruction <= (others => '0');
                else 
                    s_next_instruction <= in_next_instruction;
                end if;
            end if;
        end if;
    end process LOAD_INSTRUCTION;

    out_current_instruction <= s_next_instruction;

end Program_counter;
