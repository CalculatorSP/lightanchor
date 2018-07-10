set_property SRC_FILE_INFO {cfile:/home/ilim/Desktop/adv7511_zed/adv7511_zed.srcs/sources_1/bd/system/ip/system_sys_ps7_0/system_sys_ps7_0.xdc rfile:../../../adv7511_zed.srcs/sources_1/bd/system/ip/system_sys_ps7_0/system_sys_ps7_0.xdc id:1 order:EARLY scoped_inst:i_system_wrapper/system_i/sys_ps7/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/ilim/Desktop/adv7511_zed/adv7511_zed.srcs/sources_1/bd/system/ip/system_sys_audio_clkgen_0/system_sys_audio_clkgen_0.xdc rfile:../../../adv7511_zed.srcs/sources_1/bd/system/ip/system_sys_audio_clkgen_0/system_sys_audio_clkgen_0.xdc id:2 order:EARLY scoped_inst:i_system_wrapper/system_i/sys_audio_clkgen/inst} [current_design]
set_property SRC_FILE_INFO {cfile:/home/ilim/Desktop/adv7511_zed/adv7511_zed.srcs/sources_1/ipshared/analog.com/axi_i2s_adi_v1_0/4c7b9390/axi_i2s_adi_constr.xdc rfile:../../../adv7511_zed.srcs/sources_1/ipshared/analog.com/axi_i2s_adi_v1_0/4c7b9390/axi_i2s_adi_constr.xdc id:3 order:LATE scoped_inst:i_system_wrapper/system_i/axi_i2s_adi} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_1 0.15
set_property src_info {type:SCOPED_XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_0 0.3
set_property src_info {type:SCOPED_XDC file:2 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.05
set_property src_info {type:SCOPED_XDC file:3 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_i2s_adi/S_AXI_ACLK]] -to [get_cells -hier out_data_reg* -filter {PRIMITIVE_SUBGROUP == flop && NAME =~ *tx_sync*}] [get_property PERIOD [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_i2s_adi/DATA_CLK_I]]] -datapath_only
set_property src_info {type:SCOPED_XDC file:3 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -from [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_i2s_adi/DATA_CLK_I]] -to [get_cells -hier out_data_reg* -filter {PRIMITIVE_SUBGROUP == flop && NAME =~ *rx_sync*}] [get_property PERIOD [get_clocks -of_objects [get_pins i_system_wrapper/system_i/axi_i2s_adi/S_AXI_ACLK]]] -datapath_only
