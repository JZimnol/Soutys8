create_project -force top {D:\Programy\ActiveHDL\My_Designs\Soutys8_GitHub\Soutys8\implement} -part 7s50csga324-1
set_property design_mode GateLvl [current_fileset]
set_property top top [current_fileset]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
add_files -norecurse {D:\Programy\ActiveHDL\My_Designs\Soutys8_GitHub\Soutys8\synthesis\top.edn}
read_xdc {D:\Programy\ActiveHDL\My_Designs\Soutys8_GitHub\Soutys8\src\constraints\Arty-S7-50-Master.xdc}
link_design

opt_design -verbose -directive Default
write_checkpoint -force {top_opt.dcp}
write_qor_suggestions -force {top_opt.rqs}
catch { report_drc -file {top_opted.rpt} }
catch { report_qor_suggestions -file {top_rqs_opted.rpt} }

place_design -verbose -directive Default
catch { write_pcf -force {top.pcf} }
write_checkpoint -force {top_placed.dcp}
write_qor_suggestions -force {top_placed.rqs}
catch { report_io -file {top_io_placed.rpt} }
catch { report_clock_utilization -file {top_clock_utilization_placed.rpt} }
catch { report_utilization -file {top_utilization_placed.rpt} }
catch { report_control_sets -verbose -file {top_control_sets_placed.rpt} }
catch { report_timing_summary -file {top_timing_summary_placed.rpt} }
catch { report_qor_suggestions -file {top_rqs_placed.rpt} }

power_opt_design -verbose
write_checkpoint -force {top_postplace_pwropt.dcp}
catch { report_drc -file {top_postplace_pwropted.rpt} }

route_design -verbose -directive Default
write_checkpoint -force {top_routed.dcp}
write_qor_suggestions -force {top_routed.rqs}
write_verilog -mode timesim -sdf_anno false -force {top.v}
write_sdf -mode timesim -force {top.sdf}
catch { report_drc -file {top_drc_routed.rpt} }
catch { report_power -file {top_power_routed.rpt} }
catch { report_route_status -file {top_route_status_routed.rpt} }
catch { report_timing_summary -file {top_timing_summary_routed.rpt} }
catch { report_qor_suggestions -file {top_rqs_routed.rpt} }

write_bitstream -force -file {top.bit}
