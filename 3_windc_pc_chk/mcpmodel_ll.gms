$title MCP Model with Pooled National Markets

$echo	*	Calibration assignments for the MCP model.	>MCPMODEL.GEN

nonnegative
variables
*	Y(r,s)		Production
	YM(r,s)		Mutable production
	YX(r,s)		Extant production
	X(r,g)		Disposition
	A(r,g)		Absorption
	C(r)		Aggregate final demand
	MS(r,m)		Margin supply
	LS(r)		labor supply
	INV(r)		Investment supply
	Z(r)		consumption and investment
	W(r)		Welfare index - full consumption


	PA(r,g)		Regional market (input)
	PY(r,g)		Regional market (output)
	PD(r,g)		Local market price
	PN(g)		National market
	PL(r)		Wage rate
*	PK(r,s)		Rental rate of capital
	RK(r,s)		Rental - Mutable
	RKX(r,s)	Rental - Extant
	PM(r,m)		Margin price
	PC(r)		Consumer price index
	PFX		Foreign exchange
	PLS(r)		opportunity cost of working
	PINV(r)		investment price
	PZ(r)		consumption and investment index
	PW(r)		welfare full consumption price index

	RA(r)		Representative agent

equations
*	prf_Y(r,s)		Production
	prf_YM(r,s)		mutable prod
	prf_YX(r,s)		extant prod
	prf_X(r,g)		Disposition
	prf_A(r,g)		Absorption
	prf_C(r)		Aggregate final demand
	prf_MS(r,m)		Margin supply
	prf_LS(r)
	prf_INV(r)
	prf_Z(r)
	prf_W(r)

	mkt_PA(r,g)		Regional market (input)
	mkt_PY(r,g)		Regional market (output)
	mkt_PD(r,g)		Local market price
	mkt_PN(g)		National market
	mkt_PL(r)		Wage rate
*	mkt_PK(r,s)		Rental rate of capital
	mkt_RK(r,s)		Rental rate of capital - mutable
	mkt_RKX(r,s)		Rental rate of capital - extant
	mkt_PM(r,m)		Margin price
	mkt_PC(r)		Consumer price index
	mkt_PFX			Foreign exchange
	mkt_PLS(r)
	mkt_PINV(r)
	mkt_PZ(r)
	mkt_PW(r)
	
	bal_RA(r)		Representative agent;

* $prod:Y(r,s)$y_(r,s)  s:0 va:1
* 	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:PK(r,s)	q:kd0(r,s)	va:

* $prod:YM(r,s)$y_(r,s)  s:0 va:1
* 	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:RK(r,s)	q:kd0(r,s)	va:	

* $prod:YX(r,s)$[y_(r,s)$ks_x(r,s)]  s:0 va:0
* 	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:RKX(r,s)	q:kd0(r,s)	va:	


parameter	lvs(r,s)	Labor value share;

$echo	lvs(r,s) = 0; lvs(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+kd0(r,s));	>>MCPMODEL.GEN	

$macro	PVA(r,s)	(PL(r)**lvs(r,s) * RK(r,s)**(1-lvs(r,s)))

$macro  LD(r,s)         (ld0(r,s)*PVA(r,s)/PL(r))
$macro  KD(r,s)		(kd0(r,s)*PVA(r,s)/RK(r,s))

* prf_Y(y_(r,s))..
* 		sum(g, PA(r,g)*id0(r,g,s)) + 
* 		PL(r)*LD(r,s) + PK(r,s)*KD(r,s)
* 		=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));

prf_YM(y_(r,s))..
		sum(g, PA(r,g)*id0(r,g,s)) + 
		PL(r)*LD(r,s) + RK(r,s)*KD(r,s)
		=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));

prf_YX(y_(r,s))$ks_x(r,s)..
		sum(g, PA(r,g)*id0(r,g,s)) + 
		PL(r)*ld0(r,s) + RKX(r,s)*kd0(r,s)
		=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));


* $prod:X(r,g)$x_(r,g)  t:4
* 	o:PFX		q:(x0(r,g)-rx0(r,g))
* 	o:PN(g)		q:xn0(r,g)
* 	o:PD(r,g)	q:xd0(r,g)
* 	i:PY(r,g)	q:s0(r,g)

parameter	thetaxd(r,g)	Value share (output to PD market),
		thetaxn(r,g)	Value share (output to PN market),
		thetaxe(r,g)	Value share (output to PFX market);

$echo	thetaxd(r,g)$[s0(r,g)] = xd0(r,g)/s0(r,g);		>>MCPMODEL.GEN	
$echo	thetaxn(r,g)$[s0(r,g)] = xn0(r,g)/s0(r,g);		>>MCPMODEL.GEN	
$echo	thetaxe(r,g)$[s0(r,g)] = (x0(r,g)-rx0(r,g))/s0(r,g);	>>MCPMODEL.GEN	

$macro	RX(r,g)	 (( thetaxd(r,g) * PD(r,g)**(1+etranx(g)) + thetaxn(r,g) * PN(g)**(1+etranx(g)) + thetaxe(r,g) * PFX**(1+etranx(g)) )**(1/(1+etranx(g))))

prf_X(x_(r,g))..
		PY(r,g)*s0(r,g) =e= (x0(r,g)-rx0(r,g)+xn0(r,g)+xd0(r,g)) * RX(r,g);
			
* $prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
* 	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta(r,g)	p:(1-ta0(r,g))
* 	o:PFX		q:rx0(r,g)
* 	i:PN(g)		q:nd0(r,g)	d:
* 	i:PD(r,g)	q:dd0(r,g)	d:
* 	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm(r,g) 	p:(1+tm0(r,g))
* 	i:PM(r,m)	q:md0(r,m,g)
 
parameter	thetam(r,g)	Import value share
		thetan(r,g)	National value share;

$echo	thetam(r,g)=0; thetan(r,g)=0;								>>MCPMODEL.GEN
$echo	thetam(r,g)$m0(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>MCPMODEL.GEN
$echo	thetan(r,g)$nd0(r,g) = nd0(r,g) /(nd0(r,g)+dd0(r,g));					>>MCPMODEL.GEN

$macro PND(r,g)  ( (thetan(r,g)*PN(g)**(1-esubd(r,g)) + (1-thetan(r,g))*PD(r,g)**(1-esubd(r,g)))**(1/(1-esubd(r,g))) ) 
$macro PMND(r,g) ( (thetam(r,g)*(PFX*(1+tm(r,g))/(1+tm0(r,g)))**(1-esubdm(g)) + (1-thetam(r,g))*PND(r,g)**(1-esubdm(g)))**(1/(1-esubdm(g))) )

prf_A(a_(r,g))..
	 	sum(m,PM(r,m)*md0(r,m,g)) + 
			(nd0(r,g)+dd0(r,g)+m0(r,g)*(1+tm0(r,g))) * PMND(r,g)
				=e= PA(r,g)*a0(r,g)*(1-ta(r,g)) + PFX*rx0(r,g);
* $prod:MS(r,m)
* 	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
* 	i:PN(gm)	q:nm0(r,gm,m)
* 	i:PD(r,gm)	q:dm0(r,gm,m)

prf_MS(r,m)..	sum(gm, PN(gm)*nm0(r,gm,m) + PD(r,gm)*dm0(r,gm,m)) =g= PM(r,m)*sum(gm, md0(r,m,gm));
 
* $prod:C(r)  s:1
*     	o:PC(r)		q:c0(r)
* 	i:PA(r,g)	q:cd0(r,g)
 
alias(g,gg);
alias(r,rr);

parameter theta_cd(r,g);
$echo theta_cd(r,g)=0; theta_cd(r,g)$[sum(gg,cd0(r,gg))] = cd0(r,g)/sum(gg,cd0(r,gg));	>>MCPMODEL.GEN

$macro CC(r)	(sum(gg$theta_cd(r,gg),theta_cd(r,gg)*PA(r,gg)**(1-esub_cd))**(1/(1-esub_cd)))
$macro CD(r,g)	((CC(r)/PA(r,g))**esub_cd)	

*prf_C(r)..	prod(g$cd0(r,g), PA(r,g)**(cd0(r,g)/c0(r))) =g= PC(r);
*prf_C(r)..	sum(g$cd0(r,g),PA(r,g)*cd0(r,g)/c0(r)) =g= PC(r);
prf_C(r)..	CC(r) =g= PC(r);

* * investment supply
* $prod:INV(r) s:esub_inv
* 	o:PINV(r)	q:inv0(r)
* 	i:PA(r,g)	q:i0(r,g)

parameter theta_inv(r,g);
$echo theta_inv(r,g)=0; theta_inv(r,g)$[sum(gg,i0(r,gg))] = i0(r,g)/sum(gg,i0(r,gg));	>>MCPMODEL.GEN

$macro CINV(r)		(sum(gg, theta_inv(r,gg)*PA(r,gg)**(1-esub_inv))**(1/(1-esub_inv)))
$macro DINV(r,g)	((CINV(r)/PA(r,g))**esub_inv)

prf_INV(r)..	CINV(r) - PINV(r) =g= 0;

* * labor supply
* $prod:LS(r)
* 	o:PL(r)		q:(lab_e0(r)*gprod)
* 	i:PLS(r)	q:(lab_e0(r)*gprod)

prf_LS(r)..		PLS(r)*lab_e0(r) - PL(r)*lab_e0(r) =g= 0;

* * consumption + investment
* $prod:Z(r)	s:0
* 	o:PZ(r)		q:z0(r)
* 	i:PC(r)		q:c0(r)
* 	i:PINV(r)	q:inv0(r)

prf_Z(r)..		PC(r)*c0(r) + PINV(r)*inv0(r) =g= PZ(r)*z0(r);

* * full consumption
* $prod:W(r)	s:esub_z(r)
* 	o:PW(r)		q:w0(r)
* 	i:PZ(r)		q:z0(r)
* 	i:PLS(r)	q:leis_e0(r)

parameter theta_w(r);
$echo theta_w(r)=0; theta_w(r)$w0(r) = leis_e0(r)/w0(r);	>>MCPMODEL.GEN

$macro CW(r)	( (theta_w(r)*PLS(r)**(1-esub_z(r)) + (1-theta_w(r))*PZ(r)**(1-esub_z(r)))**(1/(1-esub_z(r))) )
$macro DZ(r)	( (CW(r)/PZ(r))**esub_z(r) )
$macro DLSR(r)	( (CW(r)/PLS(r))**esub_z(r) )

prf_W(r)..		CW(r) - PW(r) =g= 0;

* * income balance
* $demand:RA(r)
* 	d:PW(r)		q:w0(r)
* 	e:PY(r,g)	q:yh0(r,g)
* 	e:PFX		q:(bopdef0(r) + hhadj(r))
* 	e:PA(r,g)	q:(-g0(r,g))
* 	e:PLS(r)	q:(lab_e0(r))
* 	e:PLS(r)	q:leis_e0(r)
* 	e:PK(r,s)	q:kd0(r,s)

bal_RA(r)..	RA(r) =e= sum(g, PY(r,g)*yh0(r,g)) + PFX*(bopdef0(r) + hhadj(r))
				- sum(g, PA(r,g)*(g0(r,g)))
				+ PLS(r)*lab_e0(r)
				+ PLS(r)*leis_e0(r)
				+ sum(s, RK(r,s)*ksrs_m(r,s) + RKX(r,s)*ks_x(r,s))
				+ sum(y_(r,s), YM(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
				+ sum(y_(r,s)$ks_x(r,s), YX(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
				+ sum(a_(r,g)$a0(r,g), A(r,g)*ta(r,g)*PA(r,g)*a0(r,g))
				+ sum(a_(r,g)$m0(r,g), A(r,g)*tm(r,g)*PFX*m0(r,g)*
						(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**esubdm(g));

* $demand:RA(r)
* 	d:PC(r)		q:c0(r)
* 	e:PY(r,g)	q:yh0(r,g)
* 	e:PFX		q:(bopdef0(r) + hhadj(r))
* 	e:PA(r,g)	q:(-g0(r,g) - i0(r,g))
* 	e:PL(r)		q:(sum(s,ld0(r,s)))
* 	e:PK(r,s)	q:kd0(r,s)

* bal_RA(r)..	RA(r) =e= sum(g, PY(r,g)*yh0(r,g)) + PFX*(bopdef0(r) + hhadj(r))
* 				- sum(g, PA(r,g)*(g0(r,g)+i0(r,g))) 
* 				+ sum(s, PL(r)*ld0(r,s)) 
* 				+ sum(s, PK(r,s)*kd0(r,s))
* 				+ sum(y_(r,s), Y(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
* 				+ sum(a_(r,g)$a0(r,g), A(r,g)*ta(r,g)*PA(r,g)*a0(r,g))
* 				+ sum(a_(r,g)$m0(r,g), A(r,g)*tm(r,g)*PFX*m0(r,g)*
* 						(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**2);

*	Market clearance conditions:

mkt_PA(a_(r,g))..	A(r,g)*a0(r,g)
					=e= sum(y_(r,s), YM(r,s)*id0(r,g,s))
					+ sum(y_(r,s)$ks_x(r,s), YX(r,s)*id0(r,g,s))
					+ C(r)*cd0(r,g)*CD(r,g)
					+ g0(r,g)
					+ INV(r)*i0(r,g)*DINV(r,g);

mkt_PY(r,g)$s0(r,g)..	sum(y_(r,s), YM(r,s)*ys0(r,s,g))
						+ sum(y_(r,s), YX(r,s)*ys0(r,s,g))
						+ yh0(r,g)
						=e= X(r,g) * s0(r,g);

mkt_PD(r,g)$xd0(r,g)..	X(r,g)*xd0(r,g) * 

*	This is a tricky piece of code.  The PIP sector in HI has a single output from the 
*	X sector into the PD market.  This output is only used in margins which have a Leontief
*	demand structure.  In a counter-factual equilibrium, the price (PD("HI","PIP")) can then
*	fall to zero, and iso-elastic compensated supply function cannot be evaluated  (0/0).
*	We therefore need to differentiate between sectors with Leontief supply and those in 
*	which outputs are produce for multiple markets.  This is the sort of numerical nuisance
*	that is avoided when using MPSGE.

			( ( (PD(r,g)/RX(r,g))**etranx(g) )$round(1-thetaxd(r,g),6) + 1$(not round(1-thetaxd(r,g),6))) =e= 
*			( (PD(r,g)/RX(r,g))**4 ) =e= 
				sum(a_(r,g), A(r,g) * dd0(r,g) * 
				(PND(r,g)/PD(r,g))**esubd(r,g) * (PMND(r,g)/PND(r,g))**esubdm(g))
				+ sum((m,gm)$sameas(g,gm), dm0(r,gm,m)*MS(r,m));

mkt_PN(g)..		sum(x_(r,g), X(r,g) * xn0(r,g) * (PN(g)/PY(r,g))**etranx(g)) =e= 
			sum(a_(r,g), A(r,g) * nd0(r,g) * (PND(R,G)/PN(g))**esubd(r,g) * (PMND(r,g)/PND(r,g))**esubdm(g))
			+ sum((r,m,gm)$sameas(g,gm), nm0(r,gm,m)*MS(r,m));

mkt_PFX..		sum(x_(r,g), X(r,g)*(x0(r,g)-rx0(r,g))*(PFX/PY(r,g))**etranx(g)) 
			+ sum(a_(r,g), A(r,g)*rx0(r,g)) 
			+ sum(r, bopdef0(r)+hhadj(r)) =e= 
			sum(a_(r,g), A(r,g)*m0(r,g)*(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**esubd(r,g));

* mkt_PL(r)..	LS(r)*lab_e0(r) =g= sum(y_(r,s), Y(r,s)*ld0(r,s)*PVA(r,s)/PL(r));
mkt_PL(r)..	LS(r)*lab_e0(r)
			=g= sum(y_(r,s), YM(r,s)*LD(r,s))
			+ sum(y_(r,s)$ks_x(r,s), YX(r,s)*ld0(r,s));

* mkt_PK(r,s)$kd0(r,s)..	kd0(r,s) =e= kd0(r,s)*Y(r,s)*PVA(r,s)/PK(r,s);
* mkt_PK(r,s)$kd0(r,s)..	kd0(r,s) =e= Y(r,s)*KD(r,s);
mkt_RK(r,s)$ksrs_m(r,s)..	ksrs_m(r,s) =e= YM(r,s)*KD(r,s);
mkt_RKX(r,s)$ks_x(r,s)..	ks_x(r,s) =e= YX(r,s)*kd0(r,s);

mkt_PM(r,m)..		MS(r,m)*sum(gm,md0(r,m,gm)) =e= sum(a_(r,g),md0(r,m,g)*A(r,g));

*mkt_PC(r)..	C(r)*c0(r)*PC(r) =e= RA(r);
mkt_PC(r).. 	C(r)*c0(r) =g= Z(r)*c0(r);

mkt_PINV(r).. 	INV(r)*inv0(r) =g= Z(r)*inv0(r);

mkt_PZ(r)..		Z(r)*z0(r) =g= W(r)*z0(r)*DZ(r);

mkt_PLS(r)..	(lab_e0(r)+leis_e0(r)) =g= LS(r)*lab_e0(r) + W(r)*leis_e0(r)*DLSR(r);

mkt_PW(r)..		PW(r)*W(r)*w0(r) =g= RA(r);

model mcpmodel /

*	prf_Y.Y,
	prf_YM.YM, prf_YX.YX, prf_X.X, prf_A.A, prf_C.C, prf_MS.MS,
	prf_LS.LS, prf_INV.INV, prf_Z.Z, prf_W.W,
	
	mkt_PA.PA, mkt_PY.PY, mkt_PD.PD, mkt_PN.PN, mkt_PL.PL,
*	mkt_PK.PK,
	mkt_RK.RK, mkt_RKX.RKX,
	mkt_PM.PM, mkt_PC.PC, mkt_PFX.PFX,
	mkt_PLS.PLS, mkt_PINV.PINV, mkt_PZ.PZ, mkt_PW.PW,

	bal_RA.RA  /;

YX.l(r,s) = thetax;
YM.l(r,s) = 1-YX.l(r,s);
