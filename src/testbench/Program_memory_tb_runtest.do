SetActiveLib -work

comp -include "$dsn\src\Program_memory.vhd"
comp -include "$dsn\src\TestBench\Program_memory_tb.vhd"
asim +access +r TESTBENCH_FOR_PROGRAM_MEMORY

wave -noreg in_clk
wave -noreg in_reset
wave -noreg in_prog_trigger
wave -noreg in_prog_data
wave -noreg in_instruction_number
wave -noreg out_instruction

run 36000 ns
