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

entity MMIO is
  port(
       io_GPIO : inout STD_LOGIC_VECTOR(31 downto 0);
       out_read_data : out STD_LOGIC_VECTOR(7 downto 0);
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_write_data : in STD_LOGIC_VECTOR(7 downto 0);
       in_write_address : in STD_LOGIC_VECTOR(15 downto 0);
       in_reset : in STD_LOGIC;
       in_clk : in STD_LOGIC
  );
end MMIO;

architecture MMIO of MMIO is

---- Component declarations -----

component GPIO
  port(
       in_clk : in STD_LOGIC;
       in_control : in STD_LOGIC_VECTOR(CONTROL_BUS_WIDTH-1 downto 0);
       in_reset : in STD_LOGIC;
       in_address : in STD_LOGIC_VECTOR(15 downto 0);
       out_read_data : out STD_LOGIC_VECTOR(7 downto 0);
       in_write_data : in STD_LOGIC_VECTOR(7 downto 0);
       io_GPIO : inout STD_LOGIC_VECTOR(31 downto 0)
  );
end component;

begin

----  Component instantiations  ----

U1 : GPIO
  port map(
       in_clk => in_clk,
       in_control => in_control(CONTROL_BUS_WIDTH-1 downto 0),
       in_reset => in_reset,
       in_address => in_write_address,
       out_read_data => out_read_data,
       in_write_data => in_write_data,
       io_GPIO => io_GPIO
  );


end MMIO;
