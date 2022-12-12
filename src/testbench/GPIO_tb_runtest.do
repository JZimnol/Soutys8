SetActiveLib -work

comp -include "$dsn\src\GPIO.vhd"
comp -include "$dsn\src\testbench\GPIO_tb.vhd"
asim +access +r TESTBENCH_FOR_GPIO

wave -color red -height 40 -bold -noreg in_clk
wave -noreg in_reset
wave -noreg in_control
wave -noreg in_address
wave -noreg in_write_data
wave  out_read_data
wave -noreg io_GPIO

run 1000 ns
