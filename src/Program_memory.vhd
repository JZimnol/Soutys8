------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Program memory
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Programmable program memory ROM containing program instructions.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY PROGRAM MEMORY
--------------------------------------------------------------------------------
entity Program_memory is
    port(
        in_clk                : in  std_logic;

        in_instruction_number : in  std_logic_vector(15 downto 0);
        in_prog_trigger       : in  std_logic;
        in_prog_data          : in  std_logic_vector(7 downto 0);

        out_instruction       : out std_logic_vector(31 downto 0)
    );
end Program_memory;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF PROGRAM MEMORY
--------------------------------------------------------------------------------
architecture Program_memory of Program_memory is
    signal s_instruction : std_logic_vector(31 downto 0) := (others => '0');
    type rom_array_t is array (0 to 2*(PROG_MEM_MAX_NUMBER_OF_INSTRUCTIONS)+2) of std_logic_vector(7 downto 0);
    signal ROM : rom_array_t := (others => (others => '0'));

begin

    ----------------------------------------
    -- WRITE DATA TO THE MEMORY
    ----------------------------------------
    WRITE_DATA: process(in_clk) begin
        if in_clk'event and in_clk = '1' then
            if in_prog_trigger = '1' then
                ROM(to_integer(unsigned(in_instruction_number))) <= in_prog_data;
            end if;
        end if;
    end process WRITE_DATA;

    ----------------------------------------
    -- READ DATA FROM THE MEMORY
    ----------------------------------------
    READ_DATA: process(in_instruction_number) begin
        s_instruction <= ROM(2*to_integer(unsigned(in_instruction_number)) + 1) &
                         ROM(2*to_integer(unsigned(in_instruction_number)))     &
                         ROM(2*to_integer(unsigned(in_instruction_number)) + 3) &
                         ROM(2*to_integer(unsigned(in_instruction_number)) + 2);
    end process READ_DATA;

    out_instruction <= s_instruction;

end Program_memory;
