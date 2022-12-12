------------------------------------------------------------------------------------------------------------------------
--
-- Title       : Register_file_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for Register_file module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity Register_file_tb is
end Register_file_tb;

architecture tb_architecture of Register_file_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component Register_file
        port(
            in_clk     : in std_logic;
            in_control : in std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
            in_reset   : in std_logic;

            in_reg1_addr  : in  std_logic_vector(4 downto 0);
            out_reg1_data : out std_logic_vector(7 downto 0);

            in_reg2_addr  : in  std_logic_vector(4 downto 0);
            out_reg2_data : out std_logic_vector(7 downto 0);

            in_reg_in_addr : in std_logic_vector(4 downto 0);
            in_reg_in_data : in std_logic_vector(7 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_clk         : std_logic := '0';
    signal in_control     : std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0) := (others => '0');
    signal in_reset       : std_logic := '0';
    signal in_reg1_addr   : std_logic_vector(4 downto 0) := (others => '0');
    signal in_reg2_addr   : std_logic_vector(4 downto 0) := (others => '0');
    signal in_reg_in_addr : std_logic_vector(4 downto 0) := (others => '0');
    signal in_reg_in_data : std_logic_vector(7 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_reg1_data  : std_logic_vector(7 downto 0) := (others => '0');
    signal out_reg2_data  : std_logic_vector(7 downto 0) := (others => '0');

    -- check if register value is equal to the excpected value
    procedure CHECK_VALUE (
        register_value : in std_logic_vector(7 downto 0);
        expected_value : in integer) is
    begin
        assert (register_value = expected_value)
            report "CHECK_VALUE ERROR: expected " & integer'image(expected_value) & ", got " &
                    integer'image(to_integer(unsigned(register_value)))
            severity Error;
    end CHECK_VALUE;

    -- write value "value" to the register with address "register_address"
    procedure WRITE_TO_REGISTER (
        register_address   : in  integer;
        value              : in  integer;
        signal out_addr    : out std_logic_vector(4 downto 0);
        signal out_value   : out std_logic_vector(7 downto 0);
        signal out_control : out std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)) is
    begin
        out_control(CONTROL_REGISTER_FILE_WRITE_ENABLE) <= '1';
        out_addr <= std_logic_vector(to_unsigned(register_address, out_addr'length));
        out_value <= std_logic_vector(to_unsigned(value, out_value'length));
        wait until in_clk'event and in_clk = '1';
        out_control(CONTROL_REGISTER_FILE_WRITE_ENABLE) <= '0';
    end WRITE_TO_REGISTER;

begin

    -- Unit Under Test port map
    UUT: Register_file
        port map (
            in_clk         => in_clk,
            in_reset       => in_reset,
            in_control     => in_control,
            in_reg1_addr   => in_reg1_addr,
            in_reg2_addr   => in_reg2_addr,
            in_reg_in_addr => in_reg_in_addr,
            in_reg_in_data => in_reg_in_data,
            out_reg1_data  => out_reg1_data,
            out_reg2_data  => out_reg2_data
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
        -- write value "3*i" to register with address "i"
        for i in 0 to 31 loop
            WRITE_TO_REGISTER(i, 3*i, in_reg_in_addr, in_reg_in_data, in_control);
        end loop;

        -- check if reg1 returns value "3*i" from register with address "i"
        for i in 0 to 31 loop
            in_reg1_addr <= std_logic_vector(to_unsigned(i, in_reg1_addr'length));
            wait for CLOCK_CYCLE/2;
            CHECK_VALUE(out_reg1_data, 3*i);
            wait until in_clk'event and in_clk = '0';
        end loop;

        -- check if reg2 return values "3*i" from register with address "i"
        for i in 0 to 31 loop
            in_reg2_addr <= std_logic_vector(to_unsigned(i, in_reg2_addr'length));
            wait for CLOCK_CYCLE/2;
            CHECK_VALUE(out_reg2_data, 3*i);
            wait until in_clk'event and in_clk = '0';
        end loop;

        -- check reset mechanism
        wait until in_clk'event and in_clk ='1';
        in_reset <= '1';
        wait for 2*CLOCK_CYCLE;
        for i in 0 to 5 loop
            WRITE_TO_REGISTER(i, 3*i, in_reg_in_addr, in_reg_in_data, in_control);
        end loop;
        in_reset <= '0';
        wait for 2*CLOCK_CYCLE;

        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_REGISTER_FILE of Register_file_tb is
    for tb_architecture
        for UUT : Register_file
            use entity work.Register_file(Register_file);
        end for;
    end for;
end TESTBENCH_FOR_REGISTER_FILE;
