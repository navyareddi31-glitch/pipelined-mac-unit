@echo off
setlocal
iverilog -g2012 -o mac_sim.vvp rtl/mac_comb.v rtl/mac_pipeline.v tb/mac_tb.v
if errorlevel 1 exit /b 1
vvp mac_sim.vvp
endlocal
