-------------------------------------------------------------------------------
--
-- Title   : RESET LED
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
-------------------------------------------------------------------------------
--
-- Description:
--     Reset signal indicator connected to the onboard green LEDs.
--
-------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

----------------------------------------------
-- ENTITY RESET_LED
----------------------------------------------
entity Reset_LED is
    port(
        in_reset    : in  std_logic;
        green_led_1 : out std_logic;
        green_led_2 : out std_logic
    );
end Reset_LED;

----------------------------------------------
-- ARCHITECTURE OF SREG
----------------------------------------------
architecture Reset_LED of Reset_LED is
begin

    green_led_1 <= '1' when in_reset = '1' else '0';
    green_led_2 <= '1' when in_reset = '1' else '0';

end Reset_LED;
