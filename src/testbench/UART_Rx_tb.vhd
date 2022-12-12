------------------------------------------------------------------------------------------------------------------------
--
-- Title       : UART_Rx_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for UART_Rx module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity UART_Rx_tb is
end UART_Rx_tb;

architecture tb_architecture of UART_Rx_tb is
    constant CLOCK_CYCLE : time := 83.3 ns;

    -- Component declaration of the tested unit
    component UART_Rx
        port (
            in_clk            : in  std_logic;  -- input clock
            in_tx_bit         : in  std_logic;  -- serial data in
            in_reset          : in  std_logic;  -- reset signal
            out_rx_data       : out std_logic_vector(UART_DATA_LENGTH-1 downto 0); -- parallel data out
            out_byte_received : out std_logic;  -- active transmission info
            out_data_address  : out std_logic_vector(15 downto 0) -- programming address
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_clk    : std_logic := '0';
    signal in_tx_bit : std_logic := '1';
    signal in_reset  : std_logic := '0';
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_rx_data       : std_logic_vector(7 downto 0) := (others => '0');
    signal out_byte_received : std_logic := '0';
    signal out_data_address  : std_logic_vector(15 downto 0) := (others => '0');

    -- check if register value is equal to the excpected value
    procedure CHECK_VALUE (
        out_value      : in std_logic_vector(7 downto 0);
        expected_value : in integer) is
    begin
        assert (out_value = expected_value)
            report "CHECK_VALUE ERROR: expected " & integer'image(expected_value) & ", got " &
                    integer'image(to_integer(unsigned(out_value)))
            severity Error;
    end CHECK_VALUE;

    -- simulate sending byte and check correctness of the receiver
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
    UUT: UART_Rx
        port map (
            in_clk            => in_clk,
            in_tx_bit         => in_tx_bit,
            out_rx_data       => out_rx_data,
            out_byte_received => out_byte_received,
            in_reset          => in_reset,
            out_data_address  => out_data_address
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
        in_tx_bit <= '1';
        wait for 2*CLOCK_CYCLE;
        SEND_BYTE(in_tx_bit, "11111001");
        SEND_BYTE(in_tx_bit, "11001111");
        SEND_BYTE(in_tx_bit, "10101011");
        wait for 2*CLOCK_CYCLE;

        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_UART_RX of UART_Rx_tb is
    for tb_architecture
        for UUT : UART_Rx
            use entity work.UART_Rx(UART_Rx);
        end for;
    end for;
end TESTBENCH_FOR_UART_RX;
