------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Multiplexer 4x8bit
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Multiplexer with 4 8bit inputs.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY MUX 4x8BIT
--------------------------------------------------------------------------------
entity MUX4_8bit is
    port(
        in_input1  : in  std_logic_vector(7 downto 0);
        in_input2  : in  std_logic_vector(7 downto 0);
        in_input3  : in  std_logic_vector(7 downto 0);
        in_input4  : in  std_logic_vector(7 downto 0);
        out_output : out std_logic_vector(7 downto 0);

        in_control : in std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0)
    );
end MUX4_8bit;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF MUX 4x8BIT
--------------------------------------------------------------------------------
architecture MUX4_8bit of MUX4_8bit is
    signal s_select : std_logic_vector(1 downto 0) := (others => '0');

begin

    out_output <= in_input1 when s_select=MUX_WRITE_DATA_SEL_IMMEDIATE else
                  in_input2 when s_select=MUX_WRITE_DATA_SEL_REGISTER  else
                  in_input3 when s_select=MUX_WRITE_DATA_SEL_MEMORY    else
                  in_input4 when s_select=MUX_WRITE_DATA_SEL_ALU;
    s_select   <= in_control(CONTROL_MUX_WRITE_DATA_UPPER downto CONTROL_MUX_WRITE_DATA_LOWER);

end MUX4_8bit;
