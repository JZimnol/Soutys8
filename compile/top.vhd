-------------------------------------------------------------------------------
--
-- Author      : JZimnol
-- Company     : University of Science and Technology AGH
--
-------------------------------------------------------------------------------
-- FILE GENERATED AUTOMATICALLY FROM .bde FILE
-------------------------------------------------------------------------------


-- Design unit header --
library ieee;
library work;
use ieee.std_logic_1164.all;
use work.softprocessor_constants.all;

entity top is
  port(
       CLK_12MHz : in STD_LOGIC;
       RESET : in STD_LOGIC;
       UART_data_in : in STD_LOGIC;
       green_led_1 : out STD_LOGIC;
       green_led_2 : out STD_LOGIC;
       UART_data_out : out STD_LOGIC;
       io_GPIO : inout STD_LOGIC_VECTOR(31 downto 0)
  );
end top;

architecture top of top is

---- Component declarations -----

component Adder_16bit
  port(
       in_input1 : in STD_LOGIC_VECTOR(15 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(15 downto 0);
       out_output : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component ALU
  port(
       in_src1 : in STD_LOGIC_VECTOR(7 downto 0);
       in_src2 : in STD_LOGIC_VECTOR(7 downto 0);
       out_result : out STD_LOGIC_VECTOR(7 downto 0);
       in_SREG_clk : in STD_LOGIC;
       in_reset : in STD_LOGIC;
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       out_SREG_flags : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component Clock_Prescaler
  port(
       in_CLK_12MHz : in STD_LOGIC;
       out_CLK : out STD_LOGIC
  );
end component;
component constant_values
  port(
       out_0 : out STD_LOGIC_VECTOR(15 downto 0);
       out_1 : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component Control_unit
  port(
       in_SREG_flags : in STD_LOGIC_VECTOR(7 downto 0);
       in_instruction_type : in STD_LOGIC_VECTOR(5 downto 0);
       out_control : out STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component Data_memory
  port(
       in_reg1_addr : in STD_LOGIC_VECTOR(4 downto 0);
       in_reg2_addr : in STD_LOGIC_VECTOR(4 downto 0);
       in_write_addres : in STD_LOGIC_VECTOR(15 downto 0);
       in_write_data : in STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_clk : in STD_LOGIC;
       in_reset : in STD_LOGIC;
       out_reg1_data : out STD_LOGIC_VECTOR(7 downto 0);
       out_reg2_data : out STD_LOGIC_VECTOR(7 downto 0);
       out_read_data : out STD_LOGIC_VECTOR(7 downto 0);
       io_GPIO : inout STD_LOGIC_VECTOR(31 downto 0);
       in_reg3_addr : in STD_LOGIC_VECTOR(4 downto 0)
  );
end component;
component Instruction_decoder
  port(
       in_instruction : in STD_LOGIC_VECTOR(31 downto 0);
       out_instruction_type : out STD_LOGIC_VECTOR(5 downto 0);
       out_reg1_addr : out STD_LOGIC_VECTOR(4 downto 0);
       out_reg2_addr : out STD_LOGIC_VECTOR(4 downto 0);
       out_reg3_addr : out STD_LOGIC_VECTOR(4 downto 0);
       out_immediate : out STD_LOGIC_VECTOR(7 downto 0);
       out_sram_address : out STD_LOGIC_VECTOR(15 downto 0);
       out_branch_address : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component MUX2_16bit_addr
  port(
       in_input1 : in STD_LOGIC_VECTOR(15 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(15 downto 0);
       out_output : out STD_LOGIC_VECTOR(15 downto 0);
       in_reset : in STD_LOGIC
  );
end component;
component MUX2_16bit_branch
  port(
       in_input1 : in STD_LOGIC_VECTOR(15 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(15 downto 0);
       out_output : out STD_LOGIC_VECTOR(15 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component MUX2_16bit_PC
  port(
       in_input1 : in STD_LOGIC_VECTOR(15 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(15 downto 0);
       out_output : out STD_LOGIC_VECTOR(15 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component MUX2_8bit_src1
  port(
       in_input1 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(7 downto 0);
       out_output : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component MUX2_8bit_src2
  port(
       in_input1 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(7 downto 0);
       out_output : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component MUX4_8bit
  port(
       in_input1 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input3 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input4 : in STD_LOGIC_VECTOR(7 downto 0);
       out_output : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component Program_counter
  port(
       in_clk : in STD_LOGIC;
       in_reset : in STD_LOGIC;
       in_next_instruction : in STD_LOGIC_VECTOR(15 downto 0);
       out_current_instruction : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component Program_memory
  port(
       in_instruction_number : in STD_LOGIC_VECTOR(15 downto 0);
       in_clk : in STD_LOGIC;
       in_prog_trigger : in STD_LOGIC;
       in_prog_data : in STD_LOGIC_VECTOR(7 downto 0);
       out_instruction : out STD_LOGIC_VECTOR(31 downto 0)
  );
end component;
component Reset_LED
  port(
       in_reset : in STD_LOGIC;
       green_led_1 : out STD_LOGIC;
       green_led_2 : out STD_LOGIC
  );
end component;
component UART_Rx
  port(
       in_clk : in STD_LOGIC;
       in_tx_bit : in STD_LOGIC;
       in_reset : in STD_LOGIC;
       out_rx_data : out STD_LOGIC_VECTOR(UART_DATA_LENGTH-1 downto 0);
       out_byte_received : out STD_LOGIC;
       out_data_address : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;
component UART_Tx
  port(
       in_clk : in STD_LOGIC;
       in_tx_data : in STD_LOGIC_VECTOR(UART_DATA_LENGTH-1 downto 0);
       in_begin_send : in STD_LOGIC;
       out_tx_bit : out STD_LOGIC
  );
end component;

----     Constants     -----
constant DANGLING_INPUT_CONSTANT : STD_LOGIC := 'Z';

---- Signal declarations used on the diagram ----

signal CLK : STD_LOGIC;
signal s_uart_byte_received : STD_LOGIC;
signal CONST_0 : STD_LOGIC_VECTOR(15 downto 0);
signal CONST_1 : STD_LOGIC_VECTOR(15 downto 0);
signal CONTROL : STD_LOGIC_VECTOR(31 downto 0);
signal s_alu_src1 : STD_LOGIC_VECTOR(7 downto 0);
signal s_alu_src2 : STD_LOGIC_VECTOR(7 downto 0);
signal s_branch_address : STD_LOGIC_VECTOR(15 downto 0);
signal s_current_pc : STD_LOGIC_VECTOR(15 downto 0);
signal s_data_memory_read_data : STD_LOGIC_VECTOR(7 downto 0);
signal s_data_memory_write_data : STD_LOGIC_VECTOR(7 downto 0);
signal s_immediate : STD_LOGIC_VECTOR(7 downto 0);
signal s_instructions : STD_LOGIC_VECTOR(31 downto 0);
signal s_instruction_number : STD_LOGIC_VECTOR(15 downto 0);
signal s_instruction_type : STD_LOGIC_VECTOR(5 downto 0);
signal s_next_pc : STD_LOGIC_VECTOR(15 downto 0);
signal s_reg1_addr : STD_LOGIC_VECTOR(4 downto 0);
signal s_reg1_data : STD_LOGIC_VECTOR(7 downto 0);
signal s_reg2_addr : STD_LOGIC_VECTOR(4 downto 0);
signal s_reg2_data : STD_LOGIC_VECTOR(7 downto 0);
signal s_reg3_addr : STD_LOGIC_VECTOR(4 downto 0);
signal s_sram_addr : STD_LOGIC_VECTOR(15 downto 0);
signal s_sreg_flags : STD_LOGIC_VECTOR(7 downto 0);
signal s_uart_data_address : STD_LOGIC_VECTOR(15 downto 0);
signal s_uart_incomming_data : STD_LOGIC_VECTOR(7 downto 0);

---- Declaration for Dangling input ----
signal Dangling_Input_Signal : STD_LOGIC;

begin

----  Component instantiations  ----

U10 : MUX2_16bit_branch
  port map(
       in_input1(15) => Dangling_Input_Signal,
       in_input1(14) => Dangling_Input_Signal,
       in_input1(13) => Dangling_Input_Signal,
       in_input1(12) => Dangling_Input_Signal,
       in_input1(11) => Dangling_Input_Signal,
       in_input1(10) => Dangling_Input_Signal,
       in_input1(9) => Dangling_Input_Signal,
       in_input1(8) => Dangling_Input_Signal,
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2 => CONST_0,
       in_control => CONTROL(31 downto 0)
  );

U15 : constant_values
  port map(
       out_0 => CONST_0,
       out_1 => CONST_1
  );

U16 : Clock_Prescaler
  port map(
       in_CLK_12MHz => CLK_12MHz,
       out_CLK => CLK
  );

U17 : UART_Rx
  port map(
       in_clk => CLK_12MHz,
       in_tx_bit => UART_data_in,
       in_reset => RESET,
       out_rx_data => s_uart_incomming_data(7 downto 0),
       out_byte_received => s_uart_byte_received,
       out_data_address => s_uart_data_address
  );

U18 : UART_Tx
  port map(
       in_clk => CLK_12MHz,
       in_tx_data => s_uart_incomming_data(7 downto 0),
       in_begin_send => s_uart_byte_received,
       out_tx_bit => UART_data_out
  );

U19 : MUX2_16bit_addr
  port map(
       in_input1 => s_uart_data_address,
       in_input2(15) => Dangling_Input_Signal,
       in_input2(14) => Dangling_Input_Signal,
       in_input2(13) => Dangling_Input_Signal,
       in_input2(12) => Dangling_Input_Signal,
       in_input2(11) => Dangling_Input_Signal,
       in_input2(10) => Dangling_Input_Signal,
       in_input2(9) => Dangling_Input_Signal,
       in_input2(8) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal,
       out_output => s_instruction_number,
       in_reset => RESET
  );

U20 : Program_counter
  port map(
       in_clk => CLK,
       in_reset => RESET,
       in_next_instruction => s_next_pc,
       out_current_instruction => s_current_pc
  );

U21 : MUX2_16bit_PC
  port map(
       in_input1(15) => Dangling_Input_Signal,
       in_input1(14) => Dangling_Input_Signal,
       in_input1(13) => Dangling_Input_Signal,
       in_input1(12) => Dangling_Input_Signal,
       in_input1(11) => Dangling_Input_Signal,
       in_input1(10) => Dangling_Input_Signal,
       in_input1(9) => Dangling_Input_Signal,
       in_input1(8) => Dangling_Input_Signal,
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2(15) => Dangling_Input_Signal,
       in_input2(14) => Dangling_Input_Signal,
       in_input2(13) => Dangling_Input_Signal,
       in_input2(12) => Dangling_Input_Signal,
       in_input2(11) => Dangling_Input_Signal,
       in_input2(10) => Dangling_Input_Signal,
       in_input2(9) => Dangling_Input_Signal,
       in_input2(8) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal,
       out_output => s_next_pc,
       in_control => CONTROL(31 downto 0)
  );

U22 : Adder_16bit
  port map(
       in_input1 => s_current_pc,
       in_input2(15) => Dangling_Input_Signal,
       in_input2(14) => Dangling_Input_Signal,
       in_input2(13) => Dangling_Input_Signal,
       in_input2(12) => Dangling_Input_Signal,
       in_input2(11) => Dangling_Input_Signal,
       in_input2(10) => Dangling_Input_Signal,
       in_input2(9) => Dangling_Input_Signal,
       in_input2(8) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal
  );

U23 : Adder_16bit
  port map(
       in_input1(15) => Dangling_Input_Signal,
       in_input1(14) => Dangling_Input_Signal,
       in_input1(13) => Dangling_Input_Signal,
       in_input1(12) => Dangling_Input_Signal,
       in_input1(11) => Dangling_Input_Signal,
       in_input1(10) => Dangling_Input_Signal,
       in_input1(9) => Dangling_Input_Signal,
       in_input1(8) => Dangling_Input_Signal,
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2 => CONST_1
  );

U24 : Instruction_decoder
  port map(
       in_instruction => s_instructions,
       out_instruction_type => s_instruction_type,
       out_reg1_addr => s_reg1_addr,
       out_reg2_addr => s_reg2_addr,
       out_reg3_addr => s_reg3_addr,
       out_immediate => s_immediate,
       out_sram_address => s_sram_addr,
       out_branch_address => s_branch_address
  );

U25 : Program_memory
  port map(
       in_instruction_number => s_instruction_number,
       in_clk => CLK_12MHz,
       in_prog_trigger => s_uart_byte_received,
       in_prog_data => s_uart_incomming_data,
       out_instruction => s_instructions
  );

U3 : Data_memory
  port map(
       in_reg1_addr(4) => Dangling_Input_Signal,
       in_reg1_addr(3) => Dangling_Input_Signal,
       in_reg1_addr(2) => Dangling_Input_Signal,
       in_reg1_addr(1) => Dangling_Input_Signal,
       in_reg1_addr(0) => Dangling_Input_Signal,
       in_reg2_addr(4) => Dangling_Input_Signal,
       in_reg2_addr(3) => Dangling_Input_Signal,
       in_reg2_addr(2) => Dangling_Input_Signal,
       in_reg2_addr(1) => Dangling_Input_Signal,
       in_reg2_addr(0) => Dangling_Input_Signal,
       in_write_addres(15) => Dangling_Input_Signal,
       in_write_addres(14) => Dangling_Input_Signal,
       in_write_addres(13) => Dangling_Input_Signal,
       in_write_addres(12) => Dangling_Input_Signal,
       in_write_addres(11) => Dangling_Input_Signal,
       in_write_addres(10) => Dangling_Input_Signal,
       in_write_addres(9) => Dangling_Input_Signal,
       in_write_addres(8) => Dangling_Input_Signal,
       in_write_addres(7) => Dangling_Input_Signal,
       in_write_addres(6) => Dangling_Input_Signal,
       in_write_addres(5) => Dangling_Input_Signal,
       in_write_addres(4) => Dangling_Input_Signal,
       in_write_addres(3) => Dangling_Input_Signal,
       in_write_addres(2) => Dangling_Input_Signal,
       in_write_addres(1) => Dangling_Input_Signal,
       in_write_addres(0) => Dangling_Input_Signal,
       in_write_data => s_data_memory_write_data,
       in_control => CONTROL(31 downto 0),
       in_clk => CLK,
       in_reset => RESET,
       out_reg1_data => s_reg1_data,
       out_reg2_data => s_reg2_data,
       out_read_data => s_data_memory_read_data,
       io_GPIO => io_GPIO,
       in_reg3_addr(4) => Dangling_Input_Signal,
       in_reg3_addr(3) => Dangling_Input_Signal,
       in_reg3_addr(2) => Dangling_Input_Signal,
       in_reg3_addr(1) => Dangling_Input_Signal,
       in_reg3_addr(0) => Dangling_Input_Signal
  );

U4 : Control_unit
  port map(
       in_SREG_flags(7) => Dangling_Input_Signal,
       in_SREG_flags(6) => Dangling_Input_Signal,
       in_SREG_flags(5) => Dangling_Input_Signal,
       in_SREG_flags(4) => Dangling_Input_Signal,
       in_SREG_flags(3) => Dangling_Input_Signal,
       in_SREG_flags(2) => Dangling_Input_Signal,
       in_SREG_flags(1) => Dangling_Input_Signal,
       in_SREG_flags(0) => Dangling_Input_Signal,
       in_instruction_type(5) => Dangling_Input_Signal,
       in_instruction_type(4) => Dangling_Input_Signal,
       in_instruction_type(3) => Dangling_Input_Signal,
       in_instruction_type(2) => Dangling_Input_Signal,
       in_instruction_type(1) => Dangling_Input_Signal,
       in_instruction_type(0) => Dangling_Input_Signal,
       out_control => CONTROL(31 downto 0)
  );

U5 : ALU
  port map(
       in_src1 => s_alu_src1,
       in_src2 => s_alu_src2,
       in_SREG_clk => CLK,
       in_reset => RESET,
       in_control => CONTROL(31 downto 0),
       out_SREG_flags => s_sreg_flags
  );

U6 : MUX2_8bit_src2
  port map(
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal,
       out_output => s_alu_src2,
       in_control => CONTROL(31 downto 0)
  );

U7 : MUX2_8bit_src1
  port map(
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal,
       out_output => s_alu_src1,
       in_control => CONTROL(31 downto 0)
  );

U8 : MUX4_8bit
  port map(
       in_input1(7) => Dangling_Input_Signal,
       in_input1(6) => Dangling_Input_Signal,
       in_input1(5) => Dangling_Input_Signal,
       in_input1(4) => Dangling_Input_Signal,
       in_input1(3) => Dangling_Input_Signal,
       in_input1(2) => Dangling_Input_Signal,
       in_input1(1) => Dangling_Input_Signal,
       in_input1(0) => Dangling_Input_Signal,
       in_input2(7) => Dangling_Input_Signal,
       in_input2(6) => Dangling_Input_Signal,
       in_input2(5) => Dangling_Input_Signal,
       in_input2(4) => Dangling_Input_Signal,
       in_input2(3) => Dangling_Input_Signal,
       in_input2(2) => Dangling_Input_Signal,
       in_input2(1) => Dangling_Input_Signal,
       in_input2(0) => Dangling_Input_Signal,
       in_input3(7) => Dangling_Input_Signal,
       in_input3(6) => Dangling_Input_Signal,
       in_input3(5) => Dangling_Input_Signal,
       in_input3(4) => Dangling_Input_Signal,
       in_input3(3) => Dangling_Input_Signal,
       in_input3(2) => Dangling_Input_Signal,
       in_input3(1) => Dangling_Input_Signal,
       in_input3(0) => Dangling_Input_Signal,
       in_input4(7) => Dangling_Input_Signal,
       in_input4(6) => Dangling_Input_Signal,
       in_input4(5) => Dangling_Input_Signal,
       in_input4(4) => Dangling_Input_Signal,
       in_input4(3) => Dangling_Input_Signal,
       in_input4(2) => Dangling_Input_Signal,
       in_input4(1) => Dangling_Input_Signal,
       in_input4(0) => Dangling_Input_Signal,
       out_output => s_data_memory_write_data,
       in_control => CONTROL(31 downto 0)
  );

U9 : Reset_LED
  port map(
       in_reset => RESET,
       green_led_1 => green_led_1,
       green_led_2 => green_led_2
  );


---- Dangling input signal assignment ----

Dangling_Input_Signal <= DANGLING_INPUT_CONSTANT;

end top;
