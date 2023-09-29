$title loop over years

* Begin loop over future years
loop(t$(t.val gt %bmkyr%),

* update backstop technologies
$include loop_bs.gms

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

* set clean subsidy rate
cl_sub = -1*cl_sub_yr(t);

$INCLUDE MGEMODEL.GEN
SOLVE MGEMODEL using mcp;
ABORT$(MGEMODEL.objval > 1e-4) "Error solving MGE model.";

rep(r,s,t,"Y_CLBS")$[clbs_act(r,s)] = Y_CLBS.L(r,s);
rep(r,s,t,"YM")$[ele(s)] = YM.L(r,s)*sum(g,ys0(r,s,g));
rep(r,g,t,"SX") = X.l(r,g)*s0(r,g);

* end loop over t
);
