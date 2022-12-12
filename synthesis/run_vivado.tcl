create_project -force top {D:\Programy\ActiveHDL\My_Designs\Soutys8_GitHub\Soutys8\synthesis} -part 7s50csga324-1
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/softprocessor_constants.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/ALU.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Clock_prescaler.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/constant_values.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Control_unit.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/compile/Data_memory.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/GPIO.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Instruction_decoder.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/compile/MMIO.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_8bit_read_data.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_8bit_src1.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_8bit_src2.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_16bit_addr.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_16bit_branch.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX2_16bit_PC.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/MUX4_8bit.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Program_counter.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Program_memory.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Register_file.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Reset_LED.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/SRAM.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/UART_Rx.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/UART_Tx.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/src/Adder_16bit.vhd}
add_files -norecurse {D:/Programy/ActiveHDL/My_Designs/Soutys8_GitHub/Soutys8/compile/top.vhd}
set_property top top [current_fileset]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]

synth_design -top top -incremental off -flatten_hierarchy rebuilt -gated_clock_conversion off -fsm_extraction auto -bufg 12 -shreg_min_size 3 -max_bram -1 -max_uram -1 -max_dsp -1 -max_bram_cascade_height -1 -max_uram_cascade_height -1 -cascade_dsp auto -directive default -resource_sharing auto -control_set_opt_threshold auto -debug_log
report_utilization -file {top_utilization_synth.rpt}
report_qor_suggestions -file {top_rqs_synth.rpt}
write_qor_suggestions -force -file {top_synth.rqs}
write_edf -force {top.edn}
write_vhdl -force {top.vhd}
write_xdc -force {top.xdc}
write_checkpoint -force top_synth.dcp
