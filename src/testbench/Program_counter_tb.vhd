  ------------------------------------------------------------------------------------------------------------------------
--
-- Title       : Program_counter_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for Program_counter module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity Program_counter_tb is
end Program_counter_tb;

architecture tb_architecture of Program_counter_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component Program_counter
        port(
            in_clk   : in std_logic;
            in_reset : in std_logic;

            in_next_instruction     : in std_logic_vector(15 downto 0);
            out_current_instruction : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_clk              : std_logic := '0';
    signal in_reset            : std_logic := '0';
    signal in_next_instruction : std_logic_vector(15 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_current_instruction : std_logic_vector(15 downto 0) := (others => '0');

    -- write value "instruction" to the "next_instruction" input value
    procedure NEXT_INSTRUCTION (
        instruction             : in integer;
        signal next_instruction : out std_logic_vector(15 downto 0)) is
    begin
        next_instruction <= std_logic_vector(to_unsigned(instruction, next_instruction'length));
    end NEXT_INSTRUCTION;

    -- check if register value is equal to the excpected value
    procedure CHECK_VALUE (
        current_instruction : in std_logic_vector(15 downto 0);
        expected_value      : in integer) is
    begin
        assert (current_instruction = expected_value)
            report "CHECK_VALUE ERROR: expected " & integer'image(expected_value) & ", got " &
                    integer'image(to_integer(unsigned(current_instruction)))
            severity Error;
    end CHECK_VALUE;

begin

    -- Unit Under Test port map
    UUT: Program_counter
        port map (
            in_clk                  => in_clk,
            in_reset                => in_reset,
            in_next_instruction     => in_next_instruction,
            out_current_instruction => out_current_instruction
        );

    CLOCK_CLK: process
    begin
        in_clk <= '0';
        wait for CLOCK_CYCLE/2;
        in_clk <= '1';
        wait for CLOCK_CYCLE/2;
    end process CLOCK_CLK;

    DATA_CHECK: process
    begin
        -- first address always equals to zero
        wait until in_clk'event and in_clk = '1';
        CHECK_VALUE(out_current_instruction, 0);
        for i in 1 to 25 loop
            NEXT_INSTRUCTION(i, in_next_instruction);
            wait until in_clk'event and in_clk = '1';
            CHECK_VALUE(out_current_instruction, i-1);
        end loop;
        NEXT_INSTRUCTION(26, in_next_instruction);
        in_reset <= '1';
        wait for 1.5*CLOCK_CYCLE;
        --NEXT_INSTRUCTION(0, in_next_instruction);
        --wait for 1.5*CLOCK_CYCLE;
        in_reset <= '0';
        for i in 1 to 10 loop
            NEXT_INSTRUCTION(i, in_next_instruction);
            wait until in_clk'event and in_clk = '1';
            CHECK_VALUE(out_current_instruction, i-1);
        end loop;

        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_PROGRAM_COUNTER of Program_counter_tb is
    for tb_architecture
        for UUT : Program_counter
            use entity work.Program_counter(Program_counter);
        end for;
    end for;
end TESTBENCH_FOR_PROGRAM_COUNTER;
