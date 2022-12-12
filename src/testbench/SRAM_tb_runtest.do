SetActiveLib -work

comp -include "$dsn\src\SRAM.vhd"
comp -include "$dsn\src\testbench\SRAM_tb.vhd"
asim +access +r TESTBENCH_FOR_SRAM

wave -noreg in_clk
wave -noreg in_reset
wave -noreg in_address
wave -noreg in_write_data
wave -noreg out_read_data
wave -noreg in_control

run 420000  ns
