------------------------------------------------------------------------------------------------------------------------
--
-- Title       : GPIO_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for GPIO module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity GPIO_tb is
end GPIO_tb;

architecture tb_architecture of GPIO_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component GPIO
        port(
            in_clk        : in std_logic;
            in_control    : in std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
            in_reset      : in std_logic;

            in_address    : in std_logic_vector(15 downto 0);

            out_read_data : out std_logic_vector(7 downto 0);
            in_write_data : in  std_logic_vector(7 downto 0);

            io_GPIO       : inout std_logic_vector(31 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_clk        : std_logic := '0';
    signal in_reset      : std_logic := '0';
    signal in_control    : std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0) := (others => '0');
    signal in_address    : std_logic_vector(15 downto 0) := (others => '0');
    signal in_write_data : std_logic_vector(7 downto 0) := (others => '0');
    signal io_GPIO       : std_logic_vector(31 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_read_data : std_logic_vector(7 downto 0) := (others => '0');

    -- write data to the GPIO registers
    procedure WRITE_DATA (
        data    : in integer;
        address : in integer;
        signal out_data    : out std_logic_vector(7 downto 0);
        signal out_address : out std_logic_vector(15 downto 0);
        signal out_control : out std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)) is
    begin
        wait until in_clk'event and in_clk = '0';
        out_address <= std_logic_vector(to_unsigned(address, out_address'length));
        out_data <= std_logic_vector(to_unsigned(data, out_data'length));
        out_control(CONTROL_GPIO_WRITE_ENABLE) <= '1';
        wait until in_clk'event and in_clk = '1';
        out_control(CONTROL_GPIO_WRITE_ENABLE) <= '0';
    end WRITE_DATA;

begin

    -- Unit Under Test port map
    UUT: GPIO
        port map (
            in_clk        => in_clk,
            in_reset      => in_reset,
            in_control    => in_control,
            in_address    => in_address,
            in_write_data => in_write_data,
            io_GPIO       => io_GPIO,
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
        WRITE_DATA(16#ff#, GPIO_DDRB_ADDRESS, in_write_data, in_address, in_control);
        WRITE_DATA(16#fa#, GPIO_PORTB_ADDRESS, in_write_data, in_address, in_control);
        io_GPIO <= x"ff00f0" & "ZZZZZZZZ";
        wait for 2*CLOCK_CYCLE;

        in_reset <= '1';
        io_GPIO <= x"ffffffff";
        wait for 2*CLOCK_CYCLE;

        in_reset <= '0';
        WRITE_DATA(16#11#, GPIO_PORTB_ADDRESS, in_write_data, in_address, in_control);
        in_address <= std_logic_vector(to_unsigned(GPIO_PINB_ADDRESS, in_address'length));
        wait for 100 ns;
        
        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_GPIO of GPIO_tb is
    for tb_architecture
        for UUT : GPIO
            use entity work.GPIO(GPIO);
        end for;
    end for;
end TESTBENCH_FOR_GPIO;
