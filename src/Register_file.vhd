------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Register file
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Register file for operating on registers. Registers can be read or written.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY REGISTER_FILE
--------------------------------------------------------------------------------
entity Register_file is
    port(
        in_clk         : in  std_logic;
        in_control     : in  std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
        in_reset       : in  std_logic;

        in_reg1_addr   : in  std_logic_vector(4 downto 0);
        out_reg1_data  : out std_logic_vector(7 downto 0);

        in_reg2_addr   : in  std_logic_vector(4 downto 0);
        out_reg2_data  : out std_logic_vector(7 downto 0);

        in_reg_in_addr : in  std_logic_vector(4 downto 0);
        in_reg_in_data : in  std_logic_vector(7 downto 0)
    );
end Register_file;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF REGISTER_FILE
--------------------------------------------------------------------------------
architecture Register_file of Register_file is
    signal s_reg1_data    : std_logic_vector(7 downto 0) := (others => '0');
    signal s_reg2_data    : std_logic_vector(7 downto 0) := (others => '0');
    signal s_write_enable : std_logic := '0';

    type reg_file_array_t is array (0 to 31) of std_logic_vector(7 downto 0);
    signal registers : reg_file_array_t := (others=>(others=>'0'));

begin

    ----------------------------------------
    -- READ DATA FROM REGISTERS
    ----------------------------------------
    READ_DATA: process(in_reg1_addr, in_reg2_addr, registers) begin
        s_reg1_data <= registers(to_integer(unsigned(in_reg1_addr)));
        s_reg2_data <= registers(to_integer(unsigned(in_reg2_addr)));
    end process READ_DATA;

    ----------------------------------------
    -- WRITE DATA TO REGISTER
    ----------------------------------------
    WRITE_DATA: process(in_clk) begin
        if in_clk'event and in_clk='1' then
            if in_reset = '1' then
                registers <= (others=>(others=>'0'));
            elsif s_write_enable='1' then
                registers(to_integer(unsigned(in_reg_in_addr))) <= in_reg_in_data;
            end if;
        end if;
    end process WRITE_DATA;

    out_reg1_data  <= s_reg1_data;
    out_reg2_data  <= s_reg2_data;
    s_write_enable <= in_control(CONTROL_REGISTER_FILE_WRITE_ENABLE);

end Register_file;
