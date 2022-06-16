onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sad_tb/dut/clk
add wave -noupdate /sad_tb/dut/rst
add wave -noupdate /sad_tb/dut/en
add wave -noupdate /sad_tb/dut/PA
add wave -noupdate /sad_tb/dut/PB
add wave -noupdate /sad_tb/dut/sad
add wave -noupdate /sad_tb/dut/PA_REG/q
add wave -noupdate /sad_tb/dut/PB_REG/q
add wave -noupdate /sad_tb/dut/data_valid
add wave -noupdate /sad_tb/dut/counter_overflow
add wave -noupdate /sad_tb/testing
add wave -noupdate /sad_tb/dut/counter_output
add wave -noupdate /sad_tb/dut/COUNTER_DEF/output_reg
add wave -noupdate /sad_tb/dut/COUNTER_DEF/o
add wave -noupdate /sad_tb/dut/accumulator_input
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26371845 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {25375337 ps} {26453930 ps}
