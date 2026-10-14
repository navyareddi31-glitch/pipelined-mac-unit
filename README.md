# Pipelined MAC Unit (Verilog)

Starter portfolio project comparing a combinational unsigned MAC with a two-stage pipelined MAC.

## Operation
`Y = (A * B) + C`

A, B, and C are 16-bit unsigned inputs. The product and output are 32 bits.

## Files
- `rtl/mac_comb.v`: combinational MAC
- `rtl/mac_pipeline.v`: two-stage pipelined MAC
- `tb/mac_tb.v`: self-checking testbench with directed and repeatable pseudo-random tests
- `run_sim.bat`: Windows run script
- `run_sim.sh`: Linux/macOS run script

## Run on Windows
Open a terminal in this folder and run `run_sim.bat`, or:
```
iverilog -g2012 -o mac_sim.vvp rtl/mac_comb.v rtl/mac_pipeline.v tb/mac_tb.v
vvp mac_sim.vvp
```

## Run on Linux/macOS
```
chmod +x run_sim.sh
./run_sim.sh
```

GTKWave is optional; open `mac_tb.vcd` to inspect signals.

## Pipeline behavior
Stage 1 registers `A*B` and the matching `C`. Stage 2 registers their sum. `out_valid` indicates a valid output. Reset is synchronous and active-high. Once full, the pipeline can accept one input per cycle.

## Next steps
1. Run the simulation and confirm `ALL TESTS PASSED`.
2. Inspect the waveform.
3. Add more corner cases.
4. Synthesize both designs with the same target library and constraints before reporting area or timing. Do not claim PPA improvements until measured.

This is unsigned fixed-width arithmetic; it is not a floating-point MAC or a running accumulator.
