$title Check Consistency of the WiNDC Accounting Models (MGE and MCP)

$if not set ds $set ds WiNDC_bluenote_cps_census_2017.gdx

$if not set gdxdir $set gdxdir gdx%system.dirsep%

*	Solve sequence is either mcpmge or mgemcp

$if not set sequence $set sequence mcpmge

*	Read the dataset:

*$include windc_coredata
$include readdata_nest.gms

*	Read the MGE model:
* $exit

$include mgemodel_nest

* $exit

*	Read the MCP model:

$include mcpmodel_nest

*$exit

*	Replicate the benchmark equilibrium in both formats:

mgemodel.workspace = 100;
mgemodel.iterlim = 0;

*mgemodel.iterlim = 100000;
$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;
ABORT$(mgemodel.objval > 1e-4) "Error in benchmark calibration of the MGE model.";

* carb0(r) = carb0(r)*0.8;
* mgemodel.iterlim = 100000;
* $INCLUDE MGEMODEL.GEN
* SOLVE mgemodel using mcp;
* ABORT$(mgemodel.objval > 1e-4) "Error in benchmark calibration of the MGE model.";

execute_unload "mgeout.gdx";

$exit

mcpmodel.iterlim = 0;
$INCLUDE MCPMODEL.GEN
SOLVE mcpmodel using mcp;
ABORT$(mcpmodel.objval > 1e-4) "Error in benchmark calibration of the MCP model.";
* $exit

*	Calculate a tariff shock (unilateral free trade):
PFX.FX = 1;

$INCLUDE MCPMODEL.GEN

SOLVE mcpmodel using mcp;
ABORT$(mcpmodel.objval > 1e-4) "Error in benchmark calibration of the MCP model.";

display tm;
* tm(r,g) = 0;
carb0(r) = cb0(r)*0.8;
* tk(r,s) = tk0(r)*1.1;

set	seqopt			Sequence options /mcpmge, mgemcp/,
	sequence(seqopt)	Chosen sequence (domain check) /%sequence%/;

$goto %sequence%

*	Solve the MCP model first and verify that the resulting point solves the MGE model.

$label mcpmge

*	Fix an income level to normalize prices in the MCP model (this is done 
*	automatically in the MGE model):

alias (r,rr);
*RA.FX(r)$(RA.L(r)=smax(rr,RA.L(rr))) = RA.L(r);

mcpmodel.iterlim = 100000;

*$onecho > path.opt
*scale option 2
*completion partial
*$offecho
mcpmodel.OptFile = 1;
mgemodel.OptFile = 1;

$INCLUDE MCPMODEL.GEN
SOLVE mcpmodel using mcp;

abort$round(mgemodel.objval,3)	"Counterfactural calculation error with MCPMODEL.";

execute_unload "mcpout.gdx";
*	Save the solution to speed up subsequent runs:

mgemodel.iterlim = 0;

$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;

abort$round(mgemodel.objval,3)	"Replication error with MGEMODEL.";

execute_unload "mgeout.gdx";

display "Model replication check for mcpmge successful.";

$exit

*	Solve the MGE model first and verify that the resulting point solves the MCP model.

$label mgemcp

mgemodel.iterlim = 100000;
$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;

abort$round(mgemodel.objval,3)	"Counterfactural calculation error with MGEMODEL.";

mcpmodel.iterlim = 0;
SOLVE mcpmodel using mcp;

abort$round(mcpmodel.objval,3)	"Replication error with MCPMODEL.";

display "Model replication check for mgemcp successful.";
