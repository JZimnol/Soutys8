SetActiveLib -work

comp -include "$dsn\src\UART_Rx.vhd"
comp -include "$dsn\src\TestBench\UART_Rx_tb.vhd"
asim +access +r TESTBENCH_FOR_UART_RX

wave -noreg in_clk
wave -noreg in_tx_bit
wave -noreg out_rx_data
wave -noreg out_byte_received

run 60000 ns
