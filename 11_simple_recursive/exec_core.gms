$title load model

*load the benchmark, preprocessing scripts, replicate benchmark, and prep for recursive loop

*------------------------------------------------------------------------
* core - base year
*------------------------------------------------------------------------

* read in the benchmark dataset
$include readdata_hh.gms

* initialize clean backstop
$include init_clbs.gms

*	Read the MGE model:
$include mgemodel_hh

*	Replicate the benchmark equilibrium:
mgemodel.workspace = 100;
mgemodel.iterlim = 0;

*mgemodel.iterlim = 100000;
$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;
ABORT$(mgemodel.objval > 1e-4) "Error in benchmark calibration of the MGE model.";

* set numeraire -- SOE
PFX.FX = 1;

* solve benchmark
mgemodel.iterlim = 100000;
$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;
ABORT$(mgemodel.objval > 1e-4) "Error in benchmark calibration of the MGE model.";

* $exit

*------------------------------------------------------------------------
* loop
*------------------------------------------------------------------------

$include exec_loop.gms