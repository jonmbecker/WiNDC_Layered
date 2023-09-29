$stitle update backstop techs

*------------------------------------------------------------------------
* loop_clbs.gms - generic clean backstop tsf accumulation
*------------------------------------------------------------------------

q_clbs(r,s,t-1)$[clbs_act(r,s)] = eps + Y_CLBS.l(r,s)*sum(g,clbs_out(r,s,g));

clTSF(r,s,t)$[clbs_act(r,s)$(t.val eq %bmkyr%)] =
	clTSF(r,s,t-1)*((1-delta)**tstep(t))
	+ clbs_in(r,"tsf",s)*clbs_mkup(r,s)*(q_clbs(r,s,t-1))
;

clTSF(r,s,t)$[clbs_act(r,s)$(t.val > %bmkyr%)] =
	clTSF(r,s,t-1)*((1-delta)**tstep(t))
	+ clbs_in(r,"tsf",s)*clbs_mkup(r,s)*(q_clbs(r,s,t-1) - q_clbs(r,s,t-2)*((1-delta)**tstep(t)))
;

clTSF(r,s,t)$[clbs_act(r,s)] = max(clTSF0(r,s,"%bmkyr%"),clTSF(r,s,t));
clTSF(r,s,t)$[clbs_act(r,s)] = max(1e-6,clTSF(r,s,t));
clbse(r,s)$[clbs_act(r,s)] = clTSF(r,s,t);
