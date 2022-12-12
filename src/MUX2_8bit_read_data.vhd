------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Multiplexer 2x8bit
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Multiplexer with 2 8bit inputs.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY MUX 2x8BIT
--------------------------------------------------------------------------------
entity MUX2_8bit_read_data is
    port(
        in_input1  : in  std_logic_vector(7 downto 0);
        in_input2  : in  std_logic_vector(7 downto 0);
        out_output : out std_logic_vector(7 downto 0);

        in_control : in  std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)
    );
end MUX2_8bit_read_data;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF MUX 2x8BIT
--------------------------------------------------------------------------------
architecture MUX2_8bit_read_data of MUX2_8bit_read_data is
    signal s_select : std_logic := '0';

begin

    out_output <= in_input1 when s_select=MUX_READ_DATA_MMIO else in_input2;
    s_select   <= in_control(CONTROL_MUX_READ_DATA);

end MUX2_8bit_read_data;
