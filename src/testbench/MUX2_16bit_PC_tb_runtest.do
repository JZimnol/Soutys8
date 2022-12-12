SetActiveLib -work

comp -include "$dsn\src\MUX2_16bit_PC.vhd"
comp -include "$dsn\src\TestBench\MUX2_16bit_PC_tb.vhd"
asim +access +r TESTBENCH_FOR_MUX2_16BIT_PC

wave -noreg in_input1
wave -noreg in_input2
wave -noreg in_control
wave -noreg out_output

run 1000 ns
