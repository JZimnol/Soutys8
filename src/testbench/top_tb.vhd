------------------------------------------------------------------------------------------------------------------------
--
-- Title       : top_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for top module. File generated from .hex file by the python script.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity top_tb is
end top_tb;

architecture tb_architecture of top_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component top
        port(
            CLK_12MHz     : in    std_logic;
            RESET         : in    std_logic;
            io_GPIO       : inout std_logic_vector(31 downto 0);
            UART_data_out : out   std_logic;
            UART_data_in  : in    std_logic;
            green_led_1   : out   std_logic;
            green_led_2   : out   std_logic
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal CLK_12MHz     : std_logic := '0';
    signal RESET         : std_logic := '0';
    signal UART_data_in  : std_logic := '1';
    -- Observed signals - signals mapped to the output ports of tested entity
    signal io_GPIO       : std_logic_vector(31 downto 0) := (others => '0');
    signal UART_data_out : std_logic := '0';
    signal green_led_1   : std_logic := '0';
    signal green_led_2   : std_logic := '0';

    constant NUMBER_OF_BITS_TO_SEND : integer := 34;
    type rom_array_t is array (0 to NUMBER_OF_BITS_TO_SEND-1) of std_logic_vector(7 downto 0);
    constant ROM : rom_array_t := ( 0 => x"0f", 1 => x"ef", 2 => x"04", 3 => x"b9", 4 => x"00", 5 => x"e0", 6 => x"05", 7 => x"b9", 8 => x"40", 9 => x"e0",
                                    10 => x"01", 11 => x"e0", 12 => x"12", 13 => x"e0", 14 => x"23", 15 => x"e0", 16 => x"2a", 17 => x"95", 18 => x"f1", 19 => x"f7",
                                    20 => x"1a", 21 => x"95", 22 => x"d9", 23 => x"f7", 24 => x"0a", 25 => x"95", 26 => x"c1", 27 => x"f7", 28 => x"45", 29 => x"b9",
                                    30 => x"43", 31 => x"95", 32 => x"f4", 33 => x"cf" );

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

    procedure SEND_BYTE (
        signal data_out : out std_logic;
        data_value      : in  std_logic_vector(7 downto 0)) is
    begin
        data_out <= '0';
        wait for UART_CLK_PER_BIT*CLOCK_CYCLE;
        for i in 0 to 7 loop
            data_out <= data_value(i);
            wait for UART_CLK_PER_BIT*CLOCK_CYCLE;
        end loop;
        data_out <= '1';
        wait for UART_CLK_PER_BIT*CLOCK_CYCLE;
    end SEND_BYTE;

begin

    -- Unit Under Test port map
    UUT: top
        port map (
            CLK_12MHz     => CLK_12MHz,
            io_GPIO       => io_GPIO,
            RESET         => RESET,
            UART_data_in  => UART_data_in,
            UART_data_out => UART_data_out,
            green_led_1   => green_led_1,
            green_led_2   => green_led_2
        );

    CLOCK_CLK: process
    begin
        CLK_12MHz <= '0';
        wait for CLOCK_CYCLE/2;
        CLK_12MHz <= '1';
        wait for CLOCK_CYCLE/2;
    end process CLOCK_CLK;

    DATA_CHECK: process
    begin
        wait for 5*CLOCK_CYCLE;
        RESET <= '1';
        for i in 0 to NUMBER_OF_BITS_TO_SEND-1 loop
            wait for 2*CLOCK_CYCLE;
            SEND_BYTE(UART_data_in, ROM(i));
        end loop;
        wait for 1.25*CLOCK_CYCLE;
        RESET <= '0';
        io_GPIO <= x"00000000";
        wait for 100 ns;
        io_GPIO(7 downto 0) <= (others => 'Z');
        wait for 25.39 us;
        RESET <= '1';
        wait for 3*CLOCK_CYCLE;
        RESET <= '0';
        wait for 1000 us;

        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_TOP of top_tb is
    for tb_architecture
        for UUT : top
            use entity work.top(top);
        end for;
    end for;
end TESTBENCH_FOR_TOP;
