$title load model

*load the benchmark, preprocessing scripts, replicate benchmark, and prep for recursive loop

*------------------------------------------------------------------------
* core - base year
*------------------------------------------------------------------------

* read in the benchmark dataset
$include readdata_hh.gms

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

* Begin loop over future years
loop(t$(t.val gt %bmkyr%),

* !!!! benchmark should probably be recalibrated for proper dynamic benchmark
* Hack for projection model
newcap(r,t) = (ktot0(r) - ktot0(r)*srvt(t))*inv.l(r);
* puts capital closer to a steady state after first period if growing other necessary endowments
* newcap(r,t) = (ktot0(r)*(1+eta) - ktot0(r)*srvt(t))*inv.l(r);

* Total mutable capital: new capital, plus existing putty net of depreciation
* ... eventually minus frozen putty moved to clay
totalcap(r,t) =
	newcap(r,t)
	+ ks_m(r)*srvt(t)
;

* Update mutable capital
ks_m(r) = totalcap(r,t);

* Vintaged capital update: vintaged capital net of depreciation,
* ... eventually plus putty moved to clay
ks_x(r,s) = kd0(r,s)*thetax*(srv**(t.val-%bmkyr%));

* assign productivity growth factor for current year
gprod = prodf(t);

$INCLUDE MGEMODEL.GEN
SOLVE MGEMODEL using mcp;
ABORT$(MGEMODEL.objval > 1e-4) "Error solving MGE model.";

* end loop over t
);
