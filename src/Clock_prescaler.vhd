------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Clock prescaler
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Basic clock prescaler with flexible DIVIDE_FACTOR parameter.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

--------------------------------------------------------------------------------
-- ENTITY CLOCK_PRESCALER
--------------------------------------------------------------------------------
entity Clock_prescaler is
    port(
        in_CLK_12MHz : in  std_logic;
        out_CLK      : out std_logic
    );
end Clock_prescaler;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF CLOCK_PRESCALER
--------------------------------------------------------------------------------
architecture Clock_prescaler of Clock_prescaler is
    constant DIVIDE_FACTOR : integer := 4;
    
    signal s_divider : integer range 0 to DIVIDE_FACTOR-1;
    signal s_CLK : std_logic := '0';

begin
    
    ----------------------------------------
    -- COUNT CLOCK CYCLES
    ----------------------------------------
    process(in_CLK_12MHz) begin
        if in_CLK_12MHz'event and in_CLK_12MHz = '1' then
            if s_divider = DIVIDE_FACTOR-1 then
                s_divider <= 0;
                s_CLK <= '1';
            elsif s_divider < integer(DIVIDE_FACTOR/2) then
                s_divider <= s_divider + 1;
                s_CLK <= '0';
            else
                s_divider <= s_divider + 1;
                s_CLK <= '1';
            end if;
        end if;
    end process;

    out_CLK <= s_CLK when DIVIDE_FACTOR /= 1 else in_CLK_12MHZ;

end Clock_prescaler;
