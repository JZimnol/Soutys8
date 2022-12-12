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

---- Signal declarations used on the diagram ----

signal CLK : STD_LOGIC;
signal NET805 : STD_LOGIC;
signal BUS1087 : STD_LOGIC_VECTOR(4 downto 0);
signal BUS1091 : STD_LOGIC_VECTOR(4 downto 0);
signal BUS1105 : STD_LOGIC_VECTOR(5 downto 0);
signal BUS1147 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1151 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1228 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1263 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1358 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1361 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS1517 : STD_LOGIC_VECTOR(4 downto 0);
signal BUS1738 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS2126 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS2135 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS2918 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS5174 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS678 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS726 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS740 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS764 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS777 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS7793 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS7814 : STD_LOGIC_VECTOR(15 downto 0);
signal BUS814 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS835 : STD_LOGIC_VECTOR(31 downto 0);
signal CONST_0 : STD_LOGIC_VECTOR(15 downto 0);
signal CONST_1 : STD_LOGIC_VECTOR(15 downto 0);
signal CONTROL : STD_LOGIC_VECTOR(31 downto 0);

begin

----  Component instantiations  ----

U10 : MUX2_16bit_branch
  port map(
       in_input1 => BUS7814,
       in_input2 => CONST_0,
       out_output => BUS1738,
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
       out_rx_data => BUS814(7 downto 0),
       out_byte_received => NET805,
       out_data_address => BUS678
  );

U18 : UART_Tx
  port map(
       in_clk => CLK_12MHz,
       in_tx_data => BUS814(7 downto 0),
       in_begin_send => NET805,
       out_tx_bit => UART_data_out
  );

U19 : MUX2_16bit_addr
  port map(
       in_input1 => BUS678,
       in_input2 => BUS777,
       out_output => BUS7793,
       in_reset => RESET
  );

U20 : Program_counter
  port map(
       in_clk => CLK,
       in_reset => RESET,
       in_next_instruction => BUS726,
       out_current_instruction => BUS777
  );

U21 : MUX2_16bit_PC
  port map(
       in_input1 => BUS764,
       in_input2 => BUS7814,
       out_output => BUS726,
       in_control => CONTROL(31 downto 0)
  );

U22 : Adder_16bit
  port map(
       in_input1 => BUS777,
       in_input2 => BUS1738,
       out_output => BUS740
  );

U23 : Adder_16bit
  port map(
       in_input1 => BUS740,
       in_input2 => CONST_1,
       out_output => BUS764
  );

U24 : Instruction_decoder
  port map(
       in_instruction => BUS835,
       out_instruction_type => BUS1105,
       out_reg1_addr => BUS1087,
       out_reg2_addr => BUS1091,
       out_reg3_addr => BUS1517,
       out_immediate => BUS1358,
       out_sram_address => BUS2135,
       out_branch_address => BUS7814
  );

U25 : Program_memory
  port map(
       in_instruction_number => BUS7793,
       in_clk => CLK_12MHz,
       in_prog_trigger => NET805,
       in_prog_data => BUS814,
       out_instruction => BUS835
  );

U3 : Data_memory
  port map(
       in_reg1_addr => BUS1087,
       in_reg2_addr => BUS1091,
       in_write_addres => BUS2135,
       in_write_data => BUS2126,
       in_control => CONTROL(31 downto 0),
       in_clk => CLK,
       in_reset => RESET,
       out_reg1_data => BUS5174,
       out_reg2_data => BUS1151,
       out_read_data => BUS2918,
       io_GPIO => io_GPIO,
       in_reg3_addr => BUS1517
  );

U4 : Control_unit
  port map(
       in_SREG_flags => BUS1263,
       in_instruction_type => BUS1105,
       out_control => CONTROL(31 downto 0)
  );

U5 : ALU
  port map(
       in_src1 => BUS1228,
       in_src2 => BUS1147,
       out_result => BUS1361,
       in_SREG_clk => CLK,
       in_reset => RESET,
       in_control => CONTROL(31 downto 0),
       out_SREG_flags => BUS1263
  );

U6 : MUX2_8bit_src2
  port map(
       in_input1 => BUS1151,
       in_input2 => BUS1358,
       out_output => BUS1147,
       in_control => CONTROL(31 downto 0)
  );

U7 : MUX2_8bit_src1
  port map(
       in_input1 => BUS5174,
       in_input2 => BUS2918,
       out_output => BUS1228,
       in_control => CONTROL(31 downto 0)
  );

U8 : MUX4_8bit
  port map(
       in_input1 => BUS1358,
       in_input2 => BUS1151,
       in_input3 => BUS2918,
       in_input4 => BUS1361,
       out_output => BUS2126,
       in_control => CONTROL(31 downto 0)
  );

U9 : Reset_LED
  port map(
       in_reset => RESET,
       green_led_1 => green_led_1,
       green_led_2 => green_led_2
  );


end top;
