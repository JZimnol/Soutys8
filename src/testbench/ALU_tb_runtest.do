SetActiveLib -work

comp -include "$dsn\src\ALU.vhd"
comp -include "$dsn\src\testbench\ALU_tb.vhd"
asim +access +r TESTBENCH_FOR_ALU

wave -noreg in_SREG_clk
wave -noreg in_reset
wave -noreg in_src1
wave -noreg in_src2
wave -noreg out_result
wave -noreg out_SREG_flags
wave -noreg in_control

run 3000 ns
