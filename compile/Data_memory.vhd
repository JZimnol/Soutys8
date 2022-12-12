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

entity Data_memory is
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
end Data_memory;

architecture Data_memory of Data_memory is

---- Component declarations -----

component MMIO
  port(
       io_GPIO : inout STD_LOGIC_VECTOR(31 downto 0);
       out_read_data : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_write_data : in STD_LOGIC_VECTOR(7 downto 0);
       in_write_address : in STD_LOGIC_VECTOR(15 downto 0);
       in_reset : in STD_LOGIC;
       in_clk : in STD_LOGIC
  );
end component;
component MUX2_8bit_read_data
  port(
       in_input1 : in STD_LOGIC_VECTOR(7 downto 0);
       in_input2 : in STD_LOGIC_VECTOR(7 downto 0);
       out_output : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0)
  );
end component;
component Register_file
  port(
       in_clk : in STD_LOGIC;
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_reset : in STD_LOGIC;
       in_reg1_addr : in STD_LOGIC_VECTOR(4 downto 0);
       out_reg1_data : out STD_LOGIC_VECTOR(7 downto 0);
       in_reg2_addr : in STD_LOGIC_VECTOR(4 downto 0);
       out_reg2_data : out STD_LOGIC_VECTOR(7 downto 0);
       in_reg_in_addr : in STD_LOGIC_VECTOR(4 downto 0);
       in_reg_in_data : in STD_LOGIC_VECTOR(7 downto 0)
  );
end component;
component SRAM
  port(
       in_clk : in STD_LOGIC;
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_reset : in STD_LOGIC;
       in_address : in STD_LOGIC_VECTOR(15 downto 0);
       in_write_data : in STD_LOGIC_VECTOR(7 downto 0);
       out_read_data : out STD_LOGIC_VECTOR(7 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

signal BUS498 : STD_LOGIC_VECTOR(7 downto 0);
signal BUS502 : STD_LOGIC_VECTOR(7 downto 0);

begin

----  Component instantiations  ----

U1 : Register_file
  port map(
       in_clk => in_clk,
       in_control => in_control(CONTROL_BUS_WIDTH-1 downto 0),
       in_reset => in_reset,
       in_reg1_addr => in_reg1_addr,
       out_reg1_data => out_reg1_data,
       in_reg2_addr => in_reg2_addr,
       out_reg2_data => out_reg2_data,
       in_reg_in_addr => in_reg3_addr,
       in_reg_in_data => in_write_data
  );

U2 : MMIO
  port map(
       io_GPIO => io_GPIO,
       out_read_data => BUS498,
       in_control => in_control(CONTROL_BUS_WIDTH-1 downto 0),
       in_write_data => in_write_data,
       in_write_address => in_write_addres,
       in_reset => in_reset,
       in_clk => in_clk
  );

U3 : SRAM
  port map(
       in_clk => in_clk,
       in_control => in_control(CONTROL_BUS_WIDTH-1 downto 0),
       in_reset => in_reset,
       in_address => in_write_addres,
       in_write_data => in_write_data,
       out_read_data => BUS502
  );

U5 : MUX2_8bit_read_data
  port map(
       in_input1 => BUS498,
       in_input2 => BUS502,
       out_output => out_read_data,
       in_control => in_control(CONTROL_BUS_WIDTH - 1 downto 0)
  );


end Data_memory;
