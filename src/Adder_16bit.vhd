------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Adder 16bit
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Simple adder for two 16bit numbers.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY ADDER 16BIT
--------------------------------------------------------------------------------
entity Adder_16bit is
    port(
        in_input1  : in  std_logic_vector(15 downto 0);
        in_input2  : in  std_logic_vector(15 downto 0);

        out_output : out std_logic_vector(15 downto 0)
    );
end Adder_16bit;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF ADDER 16BIT
--------------------------------------------------------------------------------
architecture Adder_16bit of Adder_16bit is
begin

    out_output <= in_input1 + in_input2;

end Adder_16bit;
