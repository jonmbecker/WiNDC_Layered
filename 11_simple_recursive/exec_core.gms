$title load model

*load the benchmark, preprocessing scripts, replicate benchmark, and prep for recursive loop

*------------------------------------------------------------------------
* core - base year
*------------------------------------------------------------------------

* read in the benchmark dataset
$include readdata_hh.gms

* initialize clean backstop
$include init_clbs.gms

* initialize policy
$include init_pol.gms


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

o_sub = %osubval%;

o_sub_raw = %osubrawval%;

* solve benchmark
mgemodel.iterlim = 100000;
$INCLUDE MGEMODEL.GEN
SOLVE mgemodel using mcp;
ABORT$(mgemodel.objval > 1e-4) "Error in benchmark calibration of the MGE model.";

parameter rep;

* Begin loop over future years
loop(t$(t.val eq %bmkyr%),

rep(r,s,t,"Y_CLBS")$[clbs_act(r,s)] = Y_CLBS.L(r,s);
rep(r,s,t,"YM")$[ele(s)] = YM.L(r,s)*sum(g,ys0(r,s,g));
rep(r,g,t,"SX") = X.l(r,g)*s0(r,g);
rep(r,h,t,"W") = W.l(r,h);
rep("ALL",h,t,"W") = sum(r,W.l(r,h)*w0_h(r,h))/sum(r,w0_h(r,h));
rep("ALL","ALL",t,"W") = sum((r,h),W.l(r,h)*w0_h(r,h))/sum((r,h),w0_h(r,h));
rep("ALL","ALL",t,"TRANS") = TRANS.l;
rep("ALL",h,t,"C") = sum(r,C.l(r,h)*c0_h(r,h))/sum(r,c0_h(r,h));
rep("ALL","ALL",t,"C") = sum((r,h),C.l(r,h)*c0_h(r,h))/sum((r,h),c0_h(r,h));
rep("ALL",h,t,"Z") = sum(r,Z.l(r,h)*z0_h(r,h))/sum(r,z0_h(r,h));
rep("ALL","ALL",t,"Z") = sum((r,h),Z.l(r,h)*z0_h(r,h))/sum((r,h),z0_h(r,h));

);


display rep;

execute_unload "recursive_out_%scn%.gdx";

$exit



*------------------------------------------------------------------------
* loop
*------------------------------------------------------------------------

$include exec_loop.gms

*------------------------------------------------------------------------


execute_unload "recursive_out_%scn%.gdx";
