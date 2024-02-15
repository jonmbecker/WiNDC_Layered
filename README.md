# WiNDC_Layered
 Layer features into WiNDC model

In each directory there is:

* an mcp version of the model (mcpmodel_*.gms)

* an mpsge version (mgemodel_*.gms)

* a script to read the benchmark data (readdata_*.gms)

* and a script to run everything and compare (replicate_*.gms) --- this basically just runs a test that makes sure the mcp and mpsge models produce identical results.

Listed in order of features added:
1)	Windc_core_chk – core dataset and model from WiNDC
2)	Windc_ll_chk – labor leisure added (and updates to bluenote benchmark dataset instead)
3)	Windc_PC_chk – Extant capital/production (strips out capital taxes for now, reintroduces in #7)
4)	Windc_RKS_chk – Flexible capital (transformation)
5)	Windc_CO2_chk – CO2 emissions
6)	Windc_Nest_chk – energy nesting
7)	Windc_Tk_chk – capital taxes re-included (incorrect)
8)	Windc_HH_chk – Adds household income groups to model (incorrect)
9)	Windc_Tk_chk – inv (swaps leisure and investment nesting) (correct)
10)	Windc_HH_chk – inv (swaps leisure and investment nesting) (correct)
11)	simple_recursive - a simple recursive dynamic setup - see commit history for layered recursive features

The bmk_data directory contains the windc benchmark which the model is calibrated to.
If you are curious about differences between these files use a file comparison tool to easily inspect.
