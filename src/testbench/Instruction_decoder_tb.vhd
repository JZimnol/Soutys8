------------------------------------------------------------------------------------------------------------------------
--
-- Title       : Instruction_decoder_tb
-- Design      : Soutys8
-- Author      : J.Zimnol
-- Company     : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Testbnech file for Instruction_decoder module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;
use std.textio.all;
use std.env.finish;

entity Instruction_decoder_tb is
end Instruction_decoder_tb;

architecture tb_architecture of Instruction_decoder_tb is
    -- Component declaration of the tested unit
    component Instruction_decoder
        port (
            in_instruction       : in  std_logic_vector(31 downto 0);
            out_instruction_type : out std_logic_vector(5 downto 0);

            out_reg1_addr        : out std_logic_vector(4 downto 0);
            out_reg2_addr        : out std_logic_vector(4 downto 0);
            out_reg3_addr        : out std_logic_vector(4 downto 0);

            out_immediate        : out std_logic_vector(7 downto 0);
            out_sram_address     : out std_logic_vector(15 downto 0);

            out_branch_address   : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal in_instruction : std_logic_vector(31 downto 0) := (others => '0');
    -- Observed signals - signals mapped to the output ports of tested entity
    signal out_instruction_type : std_logic_vector(5 downto 0) := (others => '0');
    signal out_reg1_addr        : std_logic_vector(4 downto 0) := (others => '0');
    signal out_reg2_addr        : std_logic_vector(4 downto 0) := (others => '0');
    signal out_reg3_addr        : std_logic_vector(4 downto 0) := (others => '0');
    signal out_immediate        : std_logic_vector(7 downto 0) := (others => '0');
    signal out_sram_address     : std_logic_vector(15 downto 0) := (others => '0');
    signal out_branch_address   : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- Unit Under Test port map
    UUT: Instruction_decoder
        port map (
            in_instruction => in_instruction,
            out_instruction_type => out_instruction_type,
            out_reg1_addr => out_reg1_addr,
            out_reg2_addr => out_reg2_addr,
            out_reg3_addr => out_reg3_addr,
            out_immediate => out_immediate,
            out_sram_address => out_sram_address,
            out_branch_address => out_branch_address
        );

    EOR_CHECK: process
    begin
        in_instruction <= "00100111000110000000000000000000";
        wait for 10 ns;

        assert (out_instruction_type = INSTR_TYPE_EOR)
            report "out_instruction_type ERROR: expected " & integer'image(to_integer(unsigned(INSTR_TYPE_EOR))) & ", got " &
                    integer'image(to_integer(unsigned(out_instruction_type)))
            severity Error;
        assert (out_reg1_addr = 17)
            report "out_reg1_addr ERROR: expected " & integer'image(17) & ", got " &
                    integer'image(to_integer(unsigned(out_reg1_addr)))
            severity Error;
        assert (out_reg2_addr = 24)
            report "out_reg2_addr ERROR: expected " & integer'image(24) & ", got " &
                    integer'image(to_integer(unsigned(out_reg2_addr)))
            severity Error;
        assert (out_reg3_addr = 17)
            report "out_reg3_addr ERROR: expected " & integer'image(17) & ", got " &
                    integer'image(to_integer(unsigned(out_reg3_addr)))
            severity Error;
        assert (out_branch_address = 0)
            report "out_branch_address ERROR: expected " & integer'image(0) & ", got " &
                    integer'image(to_integer(unsigned(out_branch_address)))
            severity Error;

        wait for 10 ns;
        report("End of simulation");
        finish;
    end process EOR_CHECK;

end tb_architecture;

configuration TESTBENCH_FOR_INSTRUCTION_DECODER of Instruction_decoder_tb is
    for tb_architecture
        for UUT : Instruction_decoder
            use entity work.Instruction_decoder(Instruction_decoder);
        end for;
    end for;
end TESTBENCH_FOR_INSTRUCTION_DECODER;
