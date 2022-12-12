------------------------------------------------------------------------------------------------------------------------
--
-- Title   : UART_Rx
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description :
--     Receiver part of UART communication module.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY UART_RX
--------------------------------------------------------------------------------
entity UART_Rx is
    port (
        in_clk            : in  std_logic;
        in_tx_bit         : in  std_logic;
        in_reset          : in  std_logic;
        out_rx_data       : out std_logic_vector(UART_DATA_LENGTH-1 downto 0);
        out_byte_received : out std_logic;
        out_data_address  : out std_logic_vector(15 downto 0)
    );
end UART_Rx;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF UART_RX
--------------------------------------------------------------------------------
architecture UART_Rx of UART_Rx is
    -- basic states for basic state machine
    type rx_states_t is (st_rx_idle,      -- nothing to receive (high state)
                         st_rx_start_bit, -- start bit (low state)
                         st_rx_data_bits, -- data to receive (low/high state)
                         st_rx_stop_bit,  -- stop bit (high state)
                         st_rx_error,     -- error occured
                         st_rx_end);      -- wait for second half of a stop bit
    signal s_rx_state : rx_states_t := st_rx_idle;

    signal s_counter       : integer range 1 to UART_CLK_PER_BIT := 1;
    signal s_bit_index     : integer range 0 to UART_DATA_LENGTH-1 := 0;
    signal s_rx_data       : std_logic_vector(UART_DATA_LENGTH-1 downto 0) := (others => '0');
    signal s_byte_received : std_logic := '0';
    signal s_data_address  : std_logic_vector(15 downto 0) := (others => '0');

begin

    ----------------------------------------
    -- CALCULATE PROGRAMMING ADDRESS
    ----------------------------------------
    CALCULATE_ADDRESS: process(in_clk) begin
        if in_clk'event and in_clk = '1' then
            if in_reset = '0' then
                s_data_address <= (others => '0');
            elsif s_byte_received = '1' then
                s_data_address <= s_data_address + 1;
            end if;
        end if;
    end process CALCULATE_ADDRESS;

    ----------------------------------------
    -- RECEIVE FRAME
    ----------------------------------------
    RECEIVE_FRAME: process(in_clk) begin
        if in_clk'event and in_clk = '1' then
            case s_rx_state is
                ------------------
                -- IDLE
                ------------------
                when st_rx_idle =>
                    s_byte_received <= '0';
                    s_counter <= 1;
                    if in_tx_bit = '0' then
                        -- detect falling edge (beginning of a start bit)
                        s_rx_state <= st_rx_start_bit;
                    end if;
                ------------------
                -- START BIT
                ------------------
                when st_rx_start_bit =>
                    s_byte_received <= '0';
                    if s_counter < (UART_CLK_PER_BIT/2) then
                        -- count until middle of a start bit
                        s_counter <= s_counter + 1;
                    else
                        if in_tx_bit = '0' then
                            -- if still '0', start reading data bits
                            s_counter <= 1;
                            s_rx_state <= st_rx_data_bits;
                        else
                            -- reception error, abort and go to idle
                            s_rx_state <= st_rx_idle;
                        end if;
                    end if;
                ------------------
                -- DATA BITS
                ------------------
                when st_rx_data_bits =>
                    s_byte_received <= '0';
                    if s_counter < UART_CLK_PER_BIT then
                        -- count until middle of a next bit
                        s_counter <= s_counter + 1;
                    else
                        -- save bit into out RX byte
                        s_rx_data(s_bit_index) <= in_tx_bit;
                        s_counter <= 1;
                        if s_bit_index = UART_DATA_LENGTH - 1 then
                            -- if last bit in byte has been saved
                            s_bit_index <= 0;
                            s_rx_state <= st_rx_stop_bit;
                        else
                            s_bit_index <= s_bit_index + 1;
                        end if;
                    end if;
                ------------------
                -- STOP BIT
                ------------------
                when st_rx_stop_bit =>
                    s_byte_received <= '0';
                    if s_counter < UART_CLK_PER_BIT then
                        -- count until middle of a stop bit
                        s_counter <= s_counter + 1;
                    else
                        if in_tx_bit = '1' then
                            -- check if stop bit is still '1'
                            s_counter <= 1;
                            s_rx_state <= st_rx_end;
                        else
                            -- reception error, no proper stop bit has been detected
                            s_rx_state <= st_rx_error;
                        end if;
                    end if;
                ------------------
                -- ERROR
                ------------------
                when st_rx_error =>
                    s_byte_received <= '0';
                    if in_tx_bit = '1' then
                        -- wait until next '1' in bit
                        s_rx_state <= st_rx_idle;
                        s_byte_received <= '0';
                    end if;
                ------------------
                -- END
                ------------------
                when st_rx_end =>
                    if s_counter < (UART_CLK_PER_BIT/4) then
                        -- wait less than a half oF a bit
                        s_counter <= s_counter + 1;
                    else
                        s_counter <= 1;
                        s_rx_state <= st_rx_idle;
                        s_byte_received <= '1';
                    end if;
            end case;
        end if;
    end process RECEIVE_FRAME;

    out_rx_data       <= s_rx_data when s_rx_state = st_rx_end; -- send data out only if there was no errors (important!)
    out_byte_received <= s_byte_received when in_reset = '1' else '0';
    out_data_address  <= s_data_address;

end UART_Rx;
