SetActiveLib -work

comp -include "$dsn\src\Program_counter.vhd"
comp -include "$dsn\src\TestBench\Program_counter_tb.vhd"
asim +access +r TESTBENCH_FOR_PROGRAM_COUNTER

wave -noreg in_clk
wave -noreg in_reset
wave -noreg in_next_instruction
wave -noreg out_current_instruction

run 10000 ns
