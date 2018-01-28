proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.cache/wt [current_project]
  set_property parent.project_path /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.xpr [current_project]
  set_property ip_repo_paths /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.cache/ip [current_project]
  set_property ip_output_repo /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.cache/ip [current_project]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/synth_1/Pico_Toplevel.dcp
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/pcie3_ultrascale_0_synth_1/pcie3_ultrascale_0.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/pcie3_ultrascale_0_synth_1/pcie3_ultrascale_0.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/coregen_fifo_32x128_synth_1/coregen_fifo_32x128.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/coregen_fifo_32x128_synth_1/coregen_fifo_32x128.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/fifo_generator_0_synth_1/fifo_generator_0.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/fifo_generator_0_synth_1/fifo_generator_0.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/fifo_generator_1_synth_1/fifo_generator_1.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/fifo_generator_1_synth_1/fifo_generator_1.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/gtwizard_ultrascale_0_synth_1/gtwizard_ultrascale_0.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/gtwizard_ultrascale_0_synth_1/gtwizard_ultrascale_0.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/gtwizard_ultrascale_l3_0_synth_1/gtwizard_ultrascale_l3_0.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/gtwizard_ultrascale_l3_0_synth_1/gtwizard_ultrascale_l3_0.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0.dcp]
  add_files -quiet /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/async_fifo144_prim_synth_1/async_fifo144_prim.dcp
  set_property netlist_only true [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.runs/async_fifo144_prim_synth_1/async_fifo144_prim.dcp]
  read_xdc -mode out_of_context -ref pcie3_ultrascale_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/synth/pcie3_ultrascale_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/synth/pcie3_ultrascale_0_ooc.xdc]
  read_xdc -ref pcie3_ultrascale_0_gt -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/synth/pcie3_ultrascale_0_gt.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/ip_0/synth/pcie3_ultrascale_0_gt.xdc]
  read_xdc -ref pcie3_ultrascale_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0-PCIE_X0Y0.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/pcie3_ultrascale_0/source/pcie3_ultrascale_0-PCIE_X0Y0.xdc]
  read_xdc -mode out_of_context -ref coregen_fifo_32x128 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_ooc.xdc]
  read_xdc -ref coregen_fifo_32x128 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128/coregen_fifo_32x128.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128/coregen_fifo_32x128.xdc]
  read_xdc -mode out_of_context -ref fifo_generator_0 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_ooc.xdc]
  read_xdc -ref fifo_generator_0 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0/fifo_generator_0.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0/fifo_generator_0.xdc]
  read_xdc -mode out_of_context -ref fifo_generator_1 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_ooc.xdc]
  read_xdc -ref fifo_generator_1 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1/fifo_generator_1.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1/fifo_generator_1.xdc]
  read_xdc -mode out_of_context -ref gtwizard_ultrascale_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/synth/gtwizard_ultrascale_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/synth/gtwizard_ultrascale_0_ooc.xdc]
  read_xdc -ref gtwizard_ultrascale_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/synth/gtwizard_ultrascale_0.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/synth/gtwizard_ultrascale_0.xdc]
  read_xdc -mode out_of_context -ref gtwizard_ultrascale_l3_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_l3_0/synth/gtwizard_ultrascale_l3_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_l3_0/synth/gtwizard_ultrascale_l3_0_ooc.xdc]
  read_xdc -ref gtwizard_ultrascale_l3_0 -cells inst /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_l3_0/synth/gtwizard_ultrascale_l3_0.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_l3_0/synth/gtwizard_ultrascale_l3_0.xdc]
  read_xdc -mode out_of_context -ref blk_mem_gen_0 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc]
  read_xdc -mode out_of_context -ref async_fifo144_prim -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim_ooc.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim_ooc.xdc]
  read_xdc -ref async_fifo144_prim -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim/async_fifo144_prim.xdc
  set_property processing_order EARLY [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim/async_fifo144_prim.xdc]
  read_xdc /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/constrs_1/new/M510_KU060_FFVA1156_E.xdc
  read_xdc /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/constrs_1/new/m510_hmc.xdc
  read_xdc /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/constrs_1/new/hmc_l3.xdc
  read_xdc /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/constrs_1/new/m510ku060_hmc.xdc
  read_xdc -unmanaged /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/imports/new/clocks.xdc
  read_xdc -ref fifo_generator_0 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0/fifo_generator_0_clocks.xdc
  set_property processing_order LATE [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0/fifo_generator_0_clocks.xdc]
  read_xdc -ref fifo_generator_1 -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1/fifo_generator_1_clocks.xdc
  set_property processing_order LATE [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1/fifo_generator_1_clocks.xdc]
  read_xdc -ref async_fifo144_prim -cells U0 /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim/async_fifo144_prim_clocks.xdc
  set_property processing_order LATE [get_files /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim/async_fifo144_prim_clocks.xdc]
  link_design -top Pico_Toplevel -part xcku060-ffva1156-2-e
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force Pico_Toplevel_opt.dcp
  report_drc -file Pico_Toplevel_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file Pico_Toplevel.hwdef}
  place_design 
  write_checkpoint -force Pico_Toplevel_placed.dcp
  report_io -file Pico_Toplevel_io_placed.rpt
  report_utilization -file Pico_Toplevel_utilization_placed.rpt -pb Pico_Toplevel_utilization_placed.pb
  report_control_sets -verbose -file Pico_Toplevel_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force Pico_Toplevel_routed.dcp
  report_drc -file Pico_Toplevel_drc_routed.rpt -pb Pico_Toplevel_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file Pico_Toplevel_timing_summary_routed.rpt -rpx Pico_Toplevel_timing_summary_routed.rpx
  report_power -file Pico_Toplevel_power_routed.rpt -pb Pico_Toplevel_power_summary_routed.pb
  report_route_status -file Pico_Toplevel_route_status.rpt -pb Pico_Toplevel_route_status.pb
  report_clock_utilization -file Pico_Toplevel_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force Pico_Toplevel.mmi }
  write_bitstream -force Pico_Toplevel.bit 
  catch { write_sysdef -hwdef Pico_Toplevel.hwdef -bitfile Pico_Toplevel.bit -meminfo Pico_Toplevel.mmi -file Pico_Toplevel.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

