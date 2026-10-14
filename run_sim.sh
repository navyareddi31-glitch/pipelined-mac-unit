#!/usr/bin/env sh
set -eu
iverilog -g2012 -o mac_sim.vvp rtl/mac_comb.v rtl/mac_pipeline.v tb/mac_tb.v
vvp mac_sim.vvp
