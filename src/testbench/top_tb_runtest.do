SetActiveLib -work

comp -include "$dsn\compile\top.vhd"
comp -include "$dsn\src\testbench\top_tb.vhd"
asim +access +r TESTBENCH_FOR_TOP

wave -noreg CLK_12MHz 
wave -noreg /top_tb/UUT/U16/out_CLK
wave -noreg RESET
wave -noreg UART_data_in
wave -noreg io_GPIO

run 1000 us
