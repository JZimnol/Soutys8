------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Constant values
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     16bit constant values used on block scheme.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- ENTITY CONSTANT_VALUES
--------------------------------------------------------------------------------
entity constant_values is
    port(
        out_0 : out std_logic_vector(15 downto 0);
        out_1 : out std_logic_vector(15 downto 0)
    );
end constant_values;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF CONSTANT_VALUES
--------------------------------------------------------------------------------
architecture constant_values of constant_values is
begin

    out_0 <= "0000000000000000";
    out_1 <= "0000000000000001";

end constant_values;
