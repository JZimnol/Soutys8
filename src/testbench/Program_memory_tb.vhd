library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity Program_memory_tb is
end Program_memory_tb;

architecture tb_architecture of Program_memory_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component Program_memory
        port(
            in_instruction_number : in std_logic_vector(15 downto 0);
            in_clk                : in std_logic;
            in_prog_trigger       : in std_logic;
            in_prog_data          : in std_logic_vector(7 downto 0);
            out_instruction       : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_instruction_number   : std_logic_vector(15 downto 0) := (others => '0');
    signal in_clk                  : std_logic := '0';
    signal in_prog_trigger         : std_logic := '0';
    signal in_prog_data            : std_logic_vector(7 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_instruction : std_logic_vector(31 downto 0) := (others => '0');

    -- write value "instruction" to the "next_instruction" input value
    procedure NEXT_INSTRUCTION (
        instruction                  : in integer;
        signal in_instruction_number : out std_logic_vector(15 downto 0)) is
    begin
        in_instruction_number <= std_logic_vector(to_unsigned(instruction, in_instruction_number'length));
    end NEXT_INSTRUCTION;

begin

    -- Unit Under Test port map
    UUT: Program_memory
        port map (
            in_instruction_number => in_instruction_number,
            in_clk                => in_clk,
            in_prog_trigger       => in_prog_trigger,
            in_prog_data          => in_prog_data,
            out_instruction       => out_instruction
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
        for ii in 0 to 31 loop
            NEXT_INSTRUCTION(ii, in_instruction_number);
            wait until in_clk'event and in_clk = '1';
        end loop;

        for ii in 0 to 31 loop
            wait until in_clk'event and in_clk = '1';
            NEXT_INSTRUCTION(ii, in_instruction_number);
            in_prog_trigger <= '1';
            in_prog_data <= std_logic_vector(to_unsigned(ii+1, in_prog_data'length));
            wait until in_clk'event and in_clk = '1';
            in_prog_trigger <= '0';
            wait for 2*CLOCK_CYCLE;
        end loop;

        for ii in 0 to 16 loop
            wait until in_clk'event and in_clk = '1';
            NEXT_INSTRUCTION(ii, in_instruction_number);
        end loop;

        wait for 2*CLOCK_CYCLE;
        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_PROGRAM_MEMORY of Program_memory_tb is
    for tb_architecture
        for UUT : Program_memory
            use entity work.Program_memory(Program_memory);
        end for;
    end for;
end TESTBENCH_FOR_PROGRAM_MEMORY;
