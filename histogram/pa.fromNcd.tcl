
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name histogram -dir "C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram/planAhead_run_1" -part xc6slx25ftg256-2
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram} }
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram/top.ncd"
if {[catch {read_twx -name results_1 -file "C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram/top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/Users/gvene/Documents/Year 4/NEUDOSE/Code/histogram/top.twx\": $eInfo"
}
