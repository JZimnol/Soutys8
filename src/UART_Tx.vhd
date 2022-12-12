------------------------------------------------------------------------------------------------------------------------
--
-- Title   : UART_Tx
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description :
--     Transmitter part of UART communication module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY UART_Tx
--------------------------------------------------------------------------------
entity UART_Tx is
    port (
        in_clk        : in  std_logic;
        in_tx_data    : in  std_logic_vector(UART_DATA_LENGTH-1 downto 0);
        in_begin_send : in  std_logic;
        out_tx_bit    : out std_logic
    );
end UART_Tx;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF UART_Tx
--------------------------------------------------------------------------------
architecture UART_Tx of UART_Tx is
    -- basic states for basic state machine
    type s_tx_states_t is (st_tx_idle,      -- nothing to send (high state)
                           st_tx_start_bit, -- start bit (low state)
                           st_tx_data_bits, -- data to send (low/high state)
                           st_tx_stop_bit); -- stop bit (high state)
    signal s_tx_state : s_tx_states_t := st_tx_idle;

    signal s_counter   : integer range 1 to UART_CLK_PER_BIT := 1;
    signal s_bit_index : integer range 0 to UART_DATA_LENGTH - 1 := 0;
    signal s_tx_data   : std_logic_vector(UART_DATA_LENGTH-1 downto 0) := (others => '0');
    signal s_tx_bit    : std_logic := '1';

begin

    ----------------------------------------
    -- TRANSMIT FRAME
    ----------------------------------------
    TRANSMIT_FRAME: process(in_clk, in_begin_send) begin
        if (in_clk'event and in_clk = '1') then
            case s_tx_state is
                ------------------
                -- IDLE
                ------------------
                when st_tx_idle =>
                    -- "1" in output as the passive state
                    s_tx_bit  <= '1';
                    s_counter <= 1;
                    if in_begin_send = '1' then
                        s_tx_data <= in_tx_data;
                        s_counter <= 1;
                        s_tx_state <= st_tx_start_bit;
                    end if;
                -----------------
                -- START BIT
                -----------------
                when st_tx_start_bit =>
                    -- start bit is the first "0" in frame
                    s_tx_bit  <= '0';
                    if s_counter < UART_CLK_PER_BIT then
                        s_counter <= s_counter + 1;
                    else
                        s_counter <= 1;
                        s_tx_state <= st_tx_data_bits;
                    end if;
                -----------------
                -- DATA BITS
                -----------------
                when st_tx_data_bits =>
                    -- send out given bit
                    s_tx_bit <= s_tx_data(s_bit_index);
                    if s_counter < UART_CLK_PER_BIT then
                        s_counter <= s_counter + 1;
                    else
                        s_counter <= 1;
                        if s_bit_index = UART_DATA_LENGTH - 1 then
                            -- if last bit has been sent
                            s_bit_index <= 0;
                            s_tx_state <= st_tx_stop_bit;
                        else
                            s_bit_index <= s_bit_index + 1;
                        end if;
                    end if;
                -----------------
                -- STOP BIT
                -----------------
                when st_tx_stop_bit =>
                    s_tx_bit <= '1';
                    -- stop bit is the last "1" in frame
                    if s_counter < UART_CLK_PER_BIT then
                        s_counter <= s_counter + 1;
                    else
                        s_tx_state <= st_tx_idle;
                    end if;
            end case;
        end if;
    end process TRANSMIT_FRAME;

    out_tx_bit <= s_tx_bit;

end UART_Tx;
