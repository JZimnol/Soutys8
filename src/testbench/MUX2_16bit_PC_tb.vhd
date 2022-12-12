library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity MUX2_16bit_PC_tb is
end MUX2_16bit_PC_tb;

architecture tb_architecture of MUX2_16bit_PC_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component MUX2_16bit_PC
        port(
            in_input1  : in  std_logic_vector(15 downto 0);
            in_input2  : in  std_logic_vector(15 downto 0);
            out_output : out std_logic_vector(15 downto 0);

            in_control : in  std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_control : std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0) := (others => '0');
    signal in_input1  : std_logic_vector(15 downto 0) := (others => '0');
    signal in_input2  : std_logic_vector(15 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_output : std_logic_vector(15 downto 0) := (others => '0');

    -- check if register value is equal to the excpected value
    procedure CHECK_VALUE (
        output_value   : in std_logic_vector(15 downto 0);
        expected_value : in integer) is
    begin
        assert (output_value = expected_value)
            report "CHECK_VALUE ERROR: expected " & integer'image(expected_value) & ", got " &
                    integer'image(to_integer(unsigned(output_value)))
            severity Error;
    end CHECK_VALUE;

begin

    -- Unit Under Test port map
    UUT: MUX2_16bit_PC
        port map (
            in_control => in_control,
            in_input1  => in_input1,
            in_input2  => in_input2,
            out_output => out_output
        );

    DATA_CHECK: process
    begin
        in_input1 <= x"0010";
        in_input2 <= x"0020";
        in_control <= (others => '0');

        in_control(CONTROL_MUX_PC_SEL) <= '0';
        wait for CLOCK_CYCLE/2;
        CHECK_VALUE(out_output, 32);

        in_control(CONTROL_MUX_PC_SEL) <= '1';
        wait for CLOCK_CYCLE/2;
        CHECK_VALUE(out_output, 16);

        wait for CLOCK_CYCLE/2;
        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_MUX2_16BIT_PC of MUX2_16bit_PC_tb is
    for tb_architecture
        for UUT : MUX2_16bit_PC
            use entity work.MUX2_16bit_PC(MUX2_16bit_PC);
        end for;
    end for;
end TESTBENCH_FOR_MUX2_16BIT_PC;
