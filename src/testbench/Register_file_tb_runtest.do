SetActiveLib -work

comp -include "$dsn\src\Register_file.vhd"
comp -include "$dsn\src\testbench\Register_file_tb.vhd"
asim +access +r TESTBENCH_FOR_REGISTER_FILE

wave -noreg in_clk
wave -noreg in_reset
wave -noreg in_control
wave -noreg in_reg1_addr
wave -noreg out_reg1_data
wave -noreg in_reg2_addr
wave -noreg out_reg2_data
wave -noreg in_reg_in_addr
wave -noreg in_reg_in_data

run 13000 ns
