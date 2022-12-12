------------------------------------------------------------------------------------------------------------------------
--
-- Title       : ALU_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for ALU module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity ALU_tb is
end ALU_tb;

architecture tb_architecture of ALU_tb is
    constant CLOCK_CYCLE : time := 100 ns;

    -- Component declaration of the tested unit
    component ALU
        port(
            in_src1    : in std_logic_vector(7 downto 0);
            in_src2    : in std_logic_vector(7 downto 0);
            out_result : out std_logic_vector(7 downto 0);

            in_SREG_clk : in std_logic;
            in_reset    : in std_logic;

            in_control     : in std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
            out_SREG_flags : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_src1     : std_logic_vector(7 downto 0) := (others => '0');
    signal in_src2     : std_logic_vector(7 downto 0) := (others => '0');
    signal in_control  : std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0) := (others => '0');
    signal in_SREG_clk : std_logic := '0';
    signal in_reset    : std_logic := '0';
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_result     : std_logic_vector(7 downto 0) := (others => '0');
    signal out_SREG_flags : std_logic_vector(7 downto 0) := (others => '0');

    -- change ALU input values
    procedure CHANGE_INPUTS (
        src1            : in  integer;
        signal out_src1 : out std_logic_vector(7 downto 0);
        src2            : in  integer;
        signal out_src2 : out std_logic_vector(7 downto 0)) is
    begin
        out_src1 <= std_logic_vector(to_unsigned(src1, out_src1'length));
        out_src2 <= std_logic_vector(to_unsigned(src2, out_src2'length));
    end CHANGE_INPUTS;

    procedure CHECK_SREG_FLAGS (
        SREG_flags : in std_logic_vector(7 downto 0);
        expected_value : in std_logic_vector(7 downto 0)) is
    begin
        assert (SREG_flags = expected_value)
            report "CHECK_SREG_FLAGS ERROR: expected " & integer'image(to_integer(unsigned(expected_value))) &
                   ", got " & integer'image(to_integer(unsigned(SREG_flags)))
            severity Error;
    end CHECK_SREG_FLAGS;

    -- change ALU operation type
    procedure CHANGE_OPERATION (
        operation : in std_logic_vector(4 downto 0);
        signal out_control : out std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)) is
    begin
        out_control(CONTROL_ALU_OP_TYPE_UPPER downto CONTROL_ALU_OP_TYPE_LOWER) <= operation;
    end CHANGE_OPERATION;

begin

    -- Unit Under Test port map
    UUT: ALU
        port map (
            in_src1        => in_src1,
            in_src2        => in_src2,
            in_control     => in_control,
            in_SREG_clk    => in_SREG_clk,
            in_reset       => in_reset,
            out_result     => out_result,
            out_SREG_flags => out_SREG_flags
        );

    CLOCK_CLK: process
    begin
        in_SREG_clk <= '0';
        wait for CLOCK_CYCLE/2;
        in_SREG_clk <= '1';
        wait for CLOCK_CYCLE/2;
    end process CLOCK_CLK;

    DATA_CHECK: process
    begin
        in_control(CONTROL_ALU_MODIFY_FLAG_ENABLE) <= '1';
        CHANGE_INPUTS(130, in_src1, 135, in_src2);
        CHANGE_OPERATION(ALU_OP_ADD, in_control);

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(130, in_src1, 126, in_src2);
        CHANGE_OPERATION(ALU_OP_ADD, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00011001");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(20, in_src1, 00, in_src2);
        CHANGE_OPERATION(ALU_OP_AND, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(150, in_src1, 155, in_src2);
        CHANGE_OPERATION(ALU_OP_AND, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(111, in_src1, 255, in_src2);
        CHANGE_OPERATION(ALU_OP_NEG, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(255, in_src1, 255, in_src2);
        CHANGE_OPERATION(ALU_OP_NEG, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(255, in_src1, 155, in_src2);
        CHANGE_OPERATION(ALU_OP_SUB, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(130, in_src1, 155, in_src2);
        CHANGE_OPERATION(ALU_OP_SUB, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00000000");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(85, in_src1, 170, in_src2);
        CHANGE_OPERATION(ALU_OP_XOR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(100, in_src1, 100, in_src2);
        CHANGE_OPERATION(ALU_OP_XOR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(128, in_src1, 127, in_src2);
        CHANGE_OPERATION(ALU_OP_OR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(0, in_src1, 0, in_src2);
        CHANGE_OPERATION(ALU_OP_OR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(128, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_DEC, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(0, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_DEC, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00111001");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(255, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_INC, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(127, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_INC, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(255, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_LSL, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00101101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(127, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_LSL, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00110101");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(1, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_LSR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00101100");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(128, in_src1, 1, in_src2);
        CHANGE_OPERATION(ALU_OP_LSR, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00111011");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(176, in_src1, 128, in_src2);
        CHANGE_OPERATION(ALU_OP_CBI, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100000");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(176, in_src1, 2, in_src2);
        CHANGE_OPERATION(ALU_OP_CBI, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100000");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(176, in_src1, 128, in_src2);
        CHANGE_OPERATION(ALU_OP_SBI, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100000");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(176, in_src1, 2, in_src2);
        CHANGE_OPERATION(ALU_OP_SBI, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100000");

        wait until in_SREG_clk'event and in_SREG_clk = '1';
        CHANGE_INPUTS(130, in_src1, 126, in_src2);
        CHANGE_OPERATION(ALU_OP_ADD, in_control);
        wait for CLOCK_CYCLE/4;
        CHECK_SREG_FLAGS(out_SREG_flags, "00100000");

        wait for 50 ns;
        report("End of simulation");
        finish;
    end process DATA_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_ALU of ALU_tb is
    for tb_architecture
        for UUT : ALU
            use entity work.ALU(ALU);
        end for;
    end for;
end TESTBENCH_FOR_ALU;
