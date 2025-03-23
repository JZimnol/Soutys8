SetActiveLib -work

comp -include "$dsn\src\Instruction_decoder.vhd"
comp -include "$dsn\src\TestBench\Instruction_decoder_tb.vhd"
asim +access +r TESTBENCH_FOR_INSTRUCTION_DECODER

wave -noreg in_instruction
wave -noreg out_instruction_type
wave -noreg out_reg1_addr
wave -noreg out_reg2_addr
wave -noreg out_reg3_addr
wave -noreg out_immediate
wave -noreg out_sram_address
wave -noreg out_branch_address

run 300 ns
