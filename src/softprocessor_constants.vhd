library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package softprocessor_constants is
    constant MAIN_CLOCK_FREQUENCY : integer := 12000000;

    constant CONTROL_BUS_WIDTH                  : integer := 32;
    constant CONTROL_REGISTER_FILE_WRITE_ENABLE : integer := 0;
    constant CONTROL_MUX_SRC1_SEL               : integer := 1;
    constant CONTROL_MUX_SRC2_SEL               : integer := 2;
    constant CONTROL_MUX_PC_SEL                 : integer := 3;
    constant CONTROL_MUX_WRITE_DATA_LOWER       : integer := 4;
    constant CONTROL_MUX_WRITE_DATA_UPPER       : integer := 5;
    constant CONTROL_MUX_READ_DATA              : integer := 6;
    constant CONTROL_ALU_OP_TYPE_LOWER          : integer := 7;
    constant CONTROL_ALU_OP_TYPE_UPPER          : integer := 11;
    constant CONTROL_ALU_MODIFY_FLAG_ENABLE     : integer := 12;
    constant CONTROL_SRAM_WRITE_ENABLE          : integer := 13;
    constant CONTROL_SRAM_PUSH_ENABLE           : integer := 14;
    constant CONTROL_SRAM_POP_ENABLE            : integer := 15;
    constant CONTROL_GPIO_WRITE_ENABLE          : integer := 16;
    constant CONTROL_MUX_BRANCH_SEL             : integer := 17;

    constant ALU_FLAG_C : integer := 0;
    constant ALU_FLAG_Z : integer := 1;
    constant ALU_FLAG_N : integer := 2;
    constant ALU_FLAG_V : integer := 3;
    constant ALU_FLAG_S : integer := 4;
    constant ALU_FLAG_H : integer := 5;
    constant ALU_FLAG_T : integer := 6;
    constant ALU_FLAG_I : integer := 7;

    constant ALU_OP_ADD     : std_logic_vector(4 downto 0) := "00000";
    constant ALU_OP_AND     : std_logic_vector(4 downto 0) := "00001";
    constant ALU_OP_NEG     : std_logic_vector(4 downto 0) := "00010";
    constant ALU_OP_SUB     : std_logic_vector(4 downto 0) := "00011";
    constant ALU_OP_XOR     : std_logic_vector(4 downto 0) := "00100";
    constant ALU_OP_OR      : std_logic_vector(4 downto 0) := "00101";
    constant ALU_OP_DEC     : std_logic_vector(4 downto 0) := "00110";
    constant ALU_OP_INC     : std_logic_vector(4 downto 0) := "00111";
    constant ALU_OP_LSL     : std_logic_vector(4 downto 0) := "01000";
    constant ALU_OP_LSR     : std_logic_vector(4 downto 0) := "01001";
    constant ALU_OP_CBI     : std_logic_vector(4 downto 0) := "01010";
    constant ALU_OP_SBI     : std_logic_vector(4 downto 0) := "01011";
    constant ALU_OP_CLEAR_I : std_logic_vector(4 downto 0) := "01100";
    constant ALU_OP_CLEAR_T : std_logic_vector(4 downto 0) := "01101";
    constant ALU_OP_CLEAR_H : std_logic_vector(4 downto 0) := "01110";
    constant ALU_OP_CLEAR_S : std_logic_vector(4 downto 0) := "01111";
    constant ALU_OP_CLEAR_V : std_logic_vector(4 downto 0) := "10000";
    constant ALU_OP_CLEAR_N : std_logic_vector(4 downto 0) := "10001";
    constant ALU_OP_CLEAR_Z : std_logic_vector(4 downto 0) := "10010";
    constant ALU_OP_CLEAR_C : std_logic_vector(4 downto 0) := "10011";
    constant ALU_OP_SET_I   : std_logic_vector(4 downto 0) := "10100";
    constant ALU_OP_SET_T   : std_logic_vector(4 downto 0) := "10101";
    constant ALU_OP_SET_H   : std_logic_vector(4 downto 0) := "10110";
    constant ALU_OP_SET_S   : std_logic_vector(4 downto 0) := "10111";
    constant ALU_OP_SET_V   : std_logic_vector(4 downto 0) := "11000";
    constant ALU_OP_SET_N   : std_logic_vector(4 downto 0) := "11001";
    constant ALU_OP_SET_Z   : std_logic_vector(4 downto 0) := "11010";
    constant ALU_OP_SET_C   : std_logic_vector(4 downto 0) := "11011";

    constant INSTR_TYPE_ADD      : std_logic_vector(5 downto 0) := "000000";
    constant INSTR_TYPE_AND      : std_logic_vector(5 downto 0) := "000001";
    constant INSTR_TYPE_ANDI     : std_logic_vector(5 downto 0) := "000010";
    constant INSTR_TYPE_BRCC     : std_logic_vector(5 downto 0) := "000011";
    constant INSTR_TYPE_BRCS     : std_logic_vector(5 downto 0) := "000100";
    constant INSTR_TYPE_BREQ     : std_logic_vector(5 downto 0) := "000101";
    constant INSTR_TYPE_BRNE     : std_logic_vector(5 downto 0) := "000110";
    constant INSTR_TYPE_CBI      : std_logic_vector(5 downto 0) := "000111";
    constant INSTR_TYPE_CLC      : std_logic_vector(5 downto 0) := "001000";
    constant INSTR_TYPE_CLH      : std_logic_vector(5 downto 0) := "001001";
    constant INSTR_TYPE_CLI      : std_logic_vector(5 downto 0) := "001010";
    constant INSTR_TYPE_CLN      : std_logic_vector(5 downto 0) := "001011";
    constant INSTR_TYPE_CLS      : std_logic_vector(5 downto 0) := "001100";
    constant INSTR_TYPE_CLT      : std_logic_vector(5 downto 0) := "001101";
    constant INSTR_TYPE_CLV      : std_logic_vector(5 downto 0) := "001110";
    constant INSTR_TYPE_CLZ      : std_logic_vector(5 downto 0) := "001111";
    constant INSTR_TYPE_COM      : std_logic_vector(5 downto 0) := "010000";
    constant INSTR_TYPE_CP       : std_logic_vector(5 downto 0) := "010001";
    constant INSTR_TYPE_CPI      : std_logic_vector(5 downto 0) := "010010";
    constant INSTR_TYPE_DEC      : std_logic_vector(5 downto 0) := "010011";
    constant INSTR_TYPE_EOR      : std_logic_vector(5 downto 0) := "010100";
    constant INSTR_TYPE_IN       : std_logic_vector(5 downto 0) := "010101";
    constant INSTR_TYPE_INC      : std_logic_vector(5 downto 0) := "010110";
    constant INSTR_TYPE_JMP      : std_logic_vector(5 downto 0) := "010111";
    constant INSTR_TYPE_LDI      : std_logic_vector(5 downto 0) := "011000";
    constant INSTR_TYPE_LDS_MMIO : std_logic_vector(5 downto 0) := "011001";
    constant INSTR_TYPE_LDS_SRAM : std_logic_vector(5 downto 0) := "011010";
    constant INSTR_TYPE_LSL      : std_logic_vector(5 downto 0) := "011011";
    constant INSTR_TYPE_LSR      : std_logic_vector(5 downto 0) := "011100";
    constant INSTR_TYPE_MOV      : std_logic_vector(5 downto 0) := "011101";
    constant INSTR_TYPE_NOP      : std_logic_vector(5 downto 0) := "011110";
    constant INSTR_TYPE_OR       : std_logic_vector(5 downto 0) := "011111";
    constant INSTR_TYPE_ORI      : std_logic_vector(5 downto 0) := "100000";
    constant INSTR_TYPE_OUT      : std_logic_vector(5 downto 0) := "100001";
    constant INSTR_TYPE_POP      : std_logic_vector(5 downto 0) := "100010";
    constant INSTR_TYPE_PUSH     : std_logic_vector(5 downto 0) := "100011";
    constant INSTR_TYPE_RJMP     : std_logic_vector(5 downto 0) := "100100";
    constant INSTR_TYPE_SBI      : std_logic_vector(5 downto 0) := "100101";
    constant INSTR_TYPE_SBR      : std_logic_vector(5 downto 0) := "100110";
    constant INSTR_TYPE_SEC      : std_logic_vector(5 downto 0) := "100111";
    constant INSTR_TYPE_SEH      : std_logic_vector(5 downto 0) := "101000";
    constant INSTR_TYPE_SEI      : std_logic_vector(5 downto 0) := "101001";
    constant INSTR_TYPE_SEN      : std_logic_vector(5 downto 0) := "101010";
    constant INSTR_TYPE_SES      : std_logic_vector(5 downto 0) := "101011";
    constant INSTR_TYPE_SET      : std_logic_vector(5 downto 0) := "101100";
    constant INSTR_TYPE_SEV      : std_logic_vector(5 downto 0) := "101101";
    constant INSTR_TYPE_SEZ      : std_logic_vector(5 downto 0) := "101110";
    constant INSTR_TYPE_STS_MMIO : std_logic_vector(5 downto 0) := "101111";
    constant INSTR_TYPE_STS_SRAM : std_logic_vector(5 downto 0) := "110000";
    constant INSTR_TYPE_SUB      : std_logic_vector(5 downto 0) := "110001";
    constant INSTR_TYPE_SUBI     : std_logic_vector(5 downto 0) := "110010";

    constant SRAM_MEMORY_SIZE     : integer := 16#800#;
    constant SRAM_LOWEST_ADDRESS  : integer := 16#100#;
    constant SRAM_HIGHEST_ADDRESS : integer := 16#8ff#;

    constant MMIO_MEMORY_SIZE     : integer := 16#e0#;
    constant MMIO_LOWEST_ADDRESS  : integer := 16#20#;
    constant MMIO_HIGHEST_ADDRESS : integer := 16#ff#;

    constant GPIO_MEMORY_SIZE     : integer := 16#40#;
    constant GPIO_LOWEST_ADDRESS  : integer := 16#20#;
    constant GPIO_HIGHEST_ADDRESS : integer := 16#5f#;

    constant GPIO_PINB_ADDRESS  : integer := 16#23#;
    constant GPIO_DDRB_ADDRESS  : integer := 16#24#;
    constant GPIO_PORTB_ADDRESS : integer := 16#25#;
    constant GPIO_PINC_ADDRESS  : integer := 16#26#;
    constant GPIO_DDRC_ADDRESS  : integer := 16#27#;
    constant GPIO_PORTC_ADDRESS : integer := 16#28#;
    constant GPIO_PIND_ADDRESS  : integer := 16#29#;
    constant GPIO_DDRD_ADDRESS  : integer := 16#2A#;
    constant GPIO_PORTD_ADDRESS : integer := 16#2B#;
    constant GPIO_PINE_ADDRESS  : integer := 16#2C#;
    constant GPIO_DDRE_ADDRESS  : integer := 16#2D#;
    constant GPIO_PORTE_ADDRESS : integer := 16#2E#;

    constant MUX_ALU_SRC1_SEL_MEMORY    : std_logic := '1';
    constant MUX_ALU_SRC1_SEL_REGISTER  : std_logic := '0';

    constant MUX_ALU_SRC2_SEL_REGISTER  : std_logic := '1';
    constant MUX_ALU_SRC2_SEL_IMMEDIATE : std_logic := '0';

    constant MUX_READ_DATA_MMIO  : std_logic := '1';
    constant MUX_READ_DATA_SRAM  : std_logic := '0';

    constant MUX_WRITE_DATA_SEL_IMMEDIATE : std_logic_vector(1 downto 0) := "01";
    constant MUX_WRITE_DATA_SEL_ALU       : std_logic_vector(1 downto 0) := "10";
    constant MUX_WRITE_DATA_SEL_MEMORY    : std_logic_vector(1 downto 0) := "11";
    constant MUX_WRITE_DATA_SEL_REGISTER  : std_logic_vector(1 downto 0) := "00";

    constant MUX_PC_SEL_NEXT_INSTR      : std_logic := '1';
    constant MUX_PC_SEL_JUMP            : std_logic := '0';

    constant MUX_BRANCH_SEL_BRANCH      : std_logic := '1';
    constant MUX_BRANCH_SEL_NO_BRANCH   : std_logic := '0';

    constant UART_BAUDRATE    : integer := 9600;
    constant UART_DATA_LENGTH : integer := 8;
    constant UART_CLK_PER_BIT : integer := 6;--integer(MAIN_CLOCK_FREQUENCY/UART_BAUDRATE);

    constant PROG_MEM_MAX_NUMBER_OF_INSTRUCTIONS : integer := 512;
end package;

package body softprocessor_constants is
end package body softprocessor_constants;
