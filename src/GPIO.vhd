------------------------------------------------------------------------------------------------------------------------
--
-- Title   : GPIO
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     GPIO part of MMIO module. Implements PORTB, PORTC, PORTD, PORTE registers.
--     Supports both input and output pins as it uses tristate buffers.
--
--            DDRx-----------+
--                           |
--                           |
--                       |\  |
--                       | \ |
--                       |  \|
--                       |   \
--     PORTx_____________|    \_______________GPIO_PIN
--                       |    /       |
--                       |   /        |
--                       |  /         |
--                       | /          |
--                       |/           |
--                                    |
--                PINx----------------+
--
--------------------------------------------------------------------------------
--
--     Tristate buffers configuration:
--         DDRx <= high
--            x is the output
--            PINx - to read the output
--            PORTx - set the output value
--         DDRx <= low
--            x is the input
--            PINx - to read the output
--            PORTx - to configure pull-up/down
--
--------------------------------------------------------------------------------
--
--                                 inout io_GPIO
--       +--+--+---+--+--+--+--+---+--+--+--+--+---+--+--+--+--+---+--+--+
--       |E7|E6|...|E1|E0|D7|D6|...|D1|D0|C7|C6|...|C1|C0|B7|B6|...|B1|B0|
--       +--+--+---+--+--+--+--+---+--+--+--+--+---+--+--+--+--+---+--+--+
--        31 30     25 24 23 22     17 16 15 14     09 08 07 06     01 00
--
--------------------------------------------------------------------------------
--
--                             array gpio_registers
--         0x2E 0x2D 0x2C  0x2B 0x2A 0x29  0x28 0x27 0x26  0x25 0x24 0x23
--       +-----+----+----+-----+----+----+-----+----+----+-----+----+----+
--       |PORTE|DDRE|PINE|PORTD|DDRD|PIND|PORTC|DDRC|PINC|PORTB|DDRB|PINB|
--       +-----+----+----+-----+----+----+-----+----+----+-----+----+----+
--          12   11   10    09   08   07    06   05   04    03   02   01
--
--------------------------------------------------------------------------------
--
--                            DATA MEMORY ADDRESSES
--
--               IN/OUT     +-----------------------+    LOAD/STORE
--                          |      32 registers_____|__0x0000-0x001f
--           0x0000-0x001f__|____64 I/O registers___|__0x0020-0x005f
--                          | 160 Ext I/o registers_|__0x0060-0x00ff
--                          |     Internal SRAM_____|__0x0100-0x08ff
--                          +-----------------------+
--
--------------------------------------------------------------------------------
--
--                   +==========+=============+=============+
--                   | Register | STS address | OUT address |
--                   +==========+=============+=============+
--                   |   PINB   |     0x23    |     0x03    |
--                   |   DDRB   |     0x24    |     0x04    |
--                   |   PORTB  |     0x25    |     0x05    |
--                   +----------+-------------+-------------+
--                   |   PINC   |     0x26    |     0x06    |
--                   |   DDRC   |     0x27    |     0x07    |
--                   |   PORTC  |     0x28    |     0x08    |
--                   +----------+-------------+-------------+
--                   |   PIND   |     0x29    |     0x09    |
--                   |   DDRD   |     0x2A    |     0x0A    |
--                   |   PORTD  |     0x2B    |     0x0B    |
--                   +----------+-------------+-------------+
--                   |   PINE   |     0x2C    |     0x0C    |
--                   |   DDRE   |     0x2D    |     0x0D    |
--                   |   PORTE  |     0x2E    |     0x0E    |
--                   +----------+-------------+-------------+
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY GPIO
--------------------------------------------------------------------------------
entity GPIO is
    port(
        in_clk        : in    std_logic;
        in_control    : in    std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
        in_reset      : in    std_logic;

        in_address    : in    std_logic_vector(15 downto 0);

        out_read_data : out   std_logic_vector(7 downto 0);
        in_write_data : in    std_logic_vector(7 downto 0);

        io_GPIO       : inout std_logic_vector(31 downto 0)
    );
end GPIO;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF GPIO
--------------------------------------------------------------------------------
architecture GPIO of GPIO is
    type gpio_reg_array_t is array (GPIO_LOWEST_ADDRESS to GPIO_HIGHEST_ADDRESS) of std_logic_vector(7 downto 0);
    signal gpio_registers : gpio_reg_array_t := (others=>(others=>'0'));

    signal s_read_data    : std_logic_vector(7 downto 0) := (others => '0');
    signal s_write_enable : std_logic := '0';

    signal s_pinB  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_ddrB  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_portB : std_logic_vector(7 downto 0) := (others => '0');

    signal s_pinC  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_ddrC  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_portC : std_logic_vector(7 downto 0) := (others => '0');

    signal s_pinD  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_ddrD  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_portD : std_logic_vector(7 downto 0) := (others => '0');

    signal s_pinE  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_ddrE  : std_logic_vector(7 downto 0) := (others => '0');
    signal s_portE : std_logic_vector(7 downto 0) := (others => '0');

begin

    -------------------------------------
    -- READ DATA FROM GPIO
    -------------------------------------
    READ_DATA: process(in_address, gpio_registers, s_pinB, s_pinC, s_pinD, s_pinE) begin
        if to_integer(unsigned(in_address)) >= GPIO_LOWEST_ADDRESS
            and to_integer(unsigned(in_address)) <= GPIO_HIGHEST_ADDRESS
        then
            -- workaround for having "X" states during simulation in gpio_registers array on GPIO_PINx_ADDRESS addresses
            case to_integer(unsigned(in_address)) is
                when GPIO_PINB_ADDRESS => s_read_data <= s_pinB;
                when GPIO_PINC_ADDRESS => s_read_data <= s_pinC;
                when GPIO_PIND_ADDRESS => s_read_data <= s_pinD;
                when GPIO_PINE_ADDRESS => s_read_data <= s_pinE;
                when others => s_read_data <= gpio_registers(to_integer(unsigned(in_address)));
            end case;
        end if;
    end process READ_DATA;

    -------------------------------
    -- WRITE DATA TO GPIO
    -------------------------------
    WRITE_DATA: process(in_clk) begin
        if in_clk'event and in_clk='1' then
            if in_reset = '1' then
               gpio_registers <= (others=>(others=>'0'));
            elsif s_write_enable='1' then
                case to_integer(unsigned(in_address)) is
                    when GPIO_PINB_ADDRESS | GPIO_PINC_ADDRESS | GPIO_PIND_ADDRESS | GPIO_PINE_ADDRESS =>
                        -- According to the AVR datasheet:
                        -- Writing a logic one to PINxn toggles the value of PORTxn, independent on the value of DDRxn.
                        gpio_registers(to_integer(unsigned(in_address)) + 2)
                            <= gpio_registers(to_integer(unsigned(in_address)) + 2) xor in_write_data;
                    when others =>
                        gpio_registers(to_integer(unsigned(in_address))) <= in_write_data;
                end case;
            end if;
        end if;
    end process WRITE_DATA;

    CONFIGURE_GPIO: for i in 0 to 7 generate
        io_GPIO(i)    <= s_portB(i) when s_ddrB(i) = '1' else 'Z';
        io_GPIO(i+8)  <= s_portC(i) when s_ddrC(i) = '1' else 'Z';
        io_GPIO(i+16) <= s_portD(i) when s_ddrD(i) = '1' else 'Z';
        io_GPIO(i+24) <= s_portE(i) when s_ddrE(i) = '1' else 'Z';
    end generate CONFIGURE_GPIO;
    s_pinB <= io_GPIO(7 downto 0);
    s_pinC <= io_GPIO(15 downto 8);
    s_pinD <= io_GPIO(23 downto 16);
    s_pinE <= io_GPIO(31 downto 24);

    s_ddrB  <= gpio_registers(GPIO_DDRB_ADDRESS);
    s_portB <= gpio_registers(GPIO_PORTB_ADDRESS);
    s_ddrC  <= gpio_registers(GPIO_DDRC_ADDRESS);
    s_portC <= gpio_registers(GPIO_PORTC_ADDRESS);
    s_ddrD  <= gpio_registers(GPIO_DDRD_ADDRESS);
    s_portD <= gpio_registers(GPIO_PORTD_ADDRESS);
    s_ddrE  <= gpio_registers(GPIO_DDRE_ADDRESS);
    s_portE <= gpio_registers(GPIO_PORTE_ADDRESS);

    out_read_data <= s_read_data;
    s_write_enable <= in_control(CONTROL_GPIO_WRITE_ENABLE);

end GPIO;
