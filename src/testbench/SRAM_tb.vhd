------------------------------------------------------------------------------------------------------------------------
--
-- Title       : SRAM_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for SRAM module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity SRAM_tb is
end SRAM_tb;

architecture tb_architecture of SRAM_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component SRAM
        port(
            in_clk        : in std_logic;

            in_control    : in std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
            in_reset      : in std_logic;

            in_address    : in std_logic_vector(15 downto 0);

            out_read_data : out std_logic_vector(7 downto 0);
            in_write_data : in  std_logic_vector(7 downto 0)
    );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_control    : std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0) := (others => '0');
    signal in_address    : std_logic_vector(15 downto 0) := x"0100";
    signal in_write_data : std_logic_vector(7 downto 0) := (others => '0');
    signal in_clk        : std_logic := '0';
    signal in_reset      : std_logic := '0';
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_read_data : std_logic_vector(7 downto 0) := (others => '0');

    -- check if output (read) value is equal to the excpected value
    procedure CHECK_VALUE (
        output_value   : in std_logic_vector(7 downto 0);
        expected_value : in integer) is
    begin
        assert (output_value = expected_value)
            report "CHECK_VALUE ERROR: expected " & integer'image(expected_value) & ", got " &
                    integer'image(to_integer(unsigned(output_value)))
            severity Error;
    end CHECK_VALUE;

begin

    -- Unit Under Test port map
    UUT: SRAM
        port map (
            in_control    => in_control,
            in_address    => in_address,
            in_reset      => in_reset,
            in_write_data => in_write_data,
            in_clk        => in_clk,
            out_read_data => out_read_data
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
        wait until in_clk'event and in_clk = '1';

        -- fill up stack
        for i in SRAM_MEMORY_SIZE - 1 downto 0 loop
            in_control(CONTROL_SRAM_WRITE_ENABLE) <= '0';
            in_control(CONTROL_SRAM_PUSH_ENABLE) <= '1';
            in_control(CONTROL_SRAM_POP_ENABLE) <= '0';
            in_address <= x"0105";
            in_write_data <= std_logic_vector(to_unsigned(i, in_write_data'length));
            wait until in_clk'event and in_clk = '1';
        end loop;

        -- push even if there's no space left on stack
        in_control(CONTROL_SRAM_PUSH_ENABLE) <= '1';
        in_write_data <= x"aa";
        wait until in_clk'event and in_clk = '1';
        wait until in_clk'event and in_clk = '1';

        -- pop values from stack
        for i in 0 to SRAM_MEMORY_SIZE + 2 loop
            in_control(CONTROL_SRAM_WRITE_ENABLE) <= '0';
            in_control(CONTROL_SRAM_PUSH_ENABLE) <= '0';
            in_control(CONTROL_SRAM_POP_ENABLE) <= '1';
            in_address <= x"0101";
            in_write_data <= std_logic_vector(to_unsigned(i+30, in_write_data'length));
            wait until in_clk'event and in_clk = '1';
            if i < SRAM_MEMORY_SIZE then
                CHECK_VALUE(out_read_data, i mod 256);
            else
                CHECK_VALUE(out_read_data, 255);
            end if;
        end loop;

        -- check RESET mechanism
        in_reset <= '1';
        wait for 2*CLOCK_CYCLE;
        in_reset <= '0';
        wait until in_clk'event and in_clk = '1';
        for i in 0 to 5 loop
            in_control(CONTROL_SRAM_WRITE_ENABLE) <= '0';
            in_control(CONTROL_SRAM_PUSH_ENABLE) <= '1';
            in_control(CONTROL_SRAM_POP_ENABLE) <= '0';
            in_address <= x"0105";
            in_write_data <= std_logic_vector(to_unsigned(i + 123, in_write_data'length));
            wait until in_clk'event and in_clk = '1';
        end loop;
        for i in 0 to 5 loop
            in_address <= std_logic_vector(to_unsigned(SRAM_HIGHEST_ADDRESS - i, in_address'length));
            wait for 0.1 ns;
            CHECK_VALUE(out_read_data, i + 123);
        end loop;

        -- check writing to SRAM mechanism
        in_control(CONTROL_SRAM_WRITE_ENABLE) <= '1';
        in_control(CONTROL_SRAM_PUSH_ENABLE) <= '0';
        in_control(CONTROL_SRAM_POP_ENABLE) <= '0';
        wait until in_clk'event and in_clk = '1';
        for i in 0 to 100 - 1 loop
            in_address <= std_logic_vector(to_unsigned(i + SRAM_LOWEST_ADDRESS, in_address'length));
            in_write_data <= std_logic_vector(to_unsigned(i, in_write_data'length));
            wait until in_clk'event and in_clk = '1';
        end loop;
        in_control(CONTROL_SRAM_WRITE_ENABLE) <= '0';
        in_control(CONTROL_SRAM_PUSH_ENABLE) <= '0';
        in_control(CONTROL_SRAM_POP_ENABLE) <= '0';
        wait for CLOCK_CYCLE;
        for i in 0 to 100 - 1 loop
            in_address <= std_logic_vector(to_unsigned(i + SRAM_LOWEST_ADDRESS, in_address'length));
            wait for 0.1 ns;
            CHECK_VALUE(out_read_data, i);
        end loop;
        wait for CLOCK_CYCLE;

        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_SRAM of SRAM_tb is
    for tb_architecture
        for UUT : SRAM
            use entity work.SRAM(SRAM);
        end for;
    end for;
end TESTBENCH_FOR_SRAM;
