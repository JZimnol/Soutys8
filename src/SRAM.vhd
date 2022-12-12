------------------------------------------------------------------------------------------------------------------------
--
-- Title   : SRAM
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     SRAM integrated with stack.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY SRAM
--------------------------------------------------------------------------------
entity SRAM is
    port(
        in_clk        : in  std_logic;
        in_control    : in  std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
        in_reset      : in  std_logic;

        in_address    : in  std_logic_vector(15 downto 0);
        in_write_data : in  std_logic_vector(7 downto 0);

        out_read_data : out std_logic_vector(7 downto 0)
    );
end SRAM;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF SRAM
--------------------------------------------------------------------------------
architecture SRAM of SRAM is
    signal s_read_data     : std_logic_vector(7 downto 0) := (others => '0');
    signal s_stack_data    : std_logic_vector(7 downto 0) := (others => '0');
    signal s_stack_pointer : integer range SRAM_LOWEST_ADDRESS - 1 to SRAM_HIGHEST_ADDRESS := SRAM_HIGHEST_ADDRESS;
    signal s_push_enable   : std_logic := '0';
    signal s_pop_enable    : std_logic := '0';
    signal s_write_enable  : std_logic := '0';

    --                                 0x100        to         0x8ff
    type sram_array_t is array (SRAM_LOWEST_ADDRESS to SRAM_HIGHEST_ADDRESS) of std_logic_vector(7 downto 0);
    signal SRAM : sram_array_t := (others=>(others=>'0'));

begin

    ----------------------------------------
    -- READ DATA FROM SRAM USING ADDRESS
    ----------------------------------------
    READ_DATA: process(in_address, s_stack_pointer, SRAM) begin
        if to_integer(unsigned(in_address)) >= SRAM_LOWEST_ADDRESS and
            to_integer(unsigned(in_address)) <= SRAM_HIGHEST_ADDRESS
        then
            s_read_data <= SRAM(to_integer(unsigned(in_address)));
        end if;
    end process READ_DATA;

    ----------------------------------------
    -- WRITE DATA TO SRAM USING ADDRESS
    -- OR PUSH, READ FROM SRAM USING POP
    ----------------------------------------
    WRITE_PUSH_POP_DATA: process(in_clk) begin
        if in_clk'event and in_clk='1' then
            if in_reset = '1' then
                -- set RAM values to zeros
                SRAM <= (others=>(others => '0'));
                s_stack_pointer <= SRAM_HIGHEST_ADDRESS;
            elsif s_write_enable = '1' then
                -- write data to RAM
                if to_integer(unsigned(in_address)) >= SRAM_LOWEST_ADDRESS and
                    to_integer(unsigned(in_address)) <= SRAM_HIGHEST_ADDRESS
                then
                    SRAM(to_integer(unsigned(in_address))) <= in_write_data;
                end if;
            elsif s_push_enable = '1' then
                -- push data to stack
                if s_stack_pointer >= SRAM_LOWEST_ADDRESS then
                    SRAM(s_stack_pointer) <= in_write_data;
                    s_stack_pointer <= s_stack_pointer - 1;
                end if;
            elsif s_pop_enable = '1' then
                -- pop data from stack
                if s_stack_pointer < SRAM_HIGHEST_ADDRESS then
                    s_stack_pointer <= s_stack_pointer + 1;
                end if;
            end if;
        end if;
    end process WRITE_PUSH_POP_DATA;

    s_write_enable <= in_control(CONTROL_SRAM_WRITE_ENABLE);
    s_push_enable  <= in_control(CONTROL_SRAM_PUSH_ENABLE);
    s_pop_enable   <= in_control(CONTROL_SRAM_POP_ENABLE);

    out_read_data <= SRAM(s_stack_pointer + 1) when s_pop_enable = '1' and s_stack_pointer < SRAM_HIGHEST_ADDRESS else
                     SRAM(s_stack_pointer) when s_pop_enable = '1' and s_stack_pointer = SRAM_HIGHEST_ADDRESS else
                     s_read_data;

end SRAM;
