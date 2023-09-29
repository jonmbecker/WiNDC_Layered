$title MCP Model with Pooled National Markets

$echo	*	Calibration assignments for the MCP model.	>MCPMODEL.GEN

nonnegative
variables
	YM(r,s)		Mutable production
	YX(r,s)		Extant production
	VA(r,s)		value added production index
	E(r,s)		Energy production index
	X(r,g)		Disposition
	A(r,g)		Absorption
	CO2(r)		co2 emissions
	MS(r,m)		Margin supply
	KS			Aggregate capital supply
	INV(r)		Investment supply
	Z(r,h)		consumption and investment
	W(r,h)		Welfare index - full consumption
	LS(r,h)		labor supply
	C(r,h)		Aggregate final demand


	

	PVA(r,s)	Value added composite price
	PE(r,s)		Energy composite price	
	PA(r,g)		Regional market (input)
	PY(r,g)		Regional market (output)
	PD(r,g)		Local market price
	PN(g)		National market
	PL(r)		Wage rate
	RK(r,s)		Rental - Mutable
	RKX(r,s)	Rental - Extant
	RKS			Aggregate Rental - Mutable
	PK
	PM(r,m)		Margin price
	PCO2		co2 factor price
	PDCO2(r)	effective co2 price
	PFX		Foreign exchange
	PINV(r)		investment price
	PZ(r,h)		consumption and investment index
	PW(r,h)		welfare full consumption price index
	PLS(r,h)		opportunity cost of working
	PC(r,h)		Consumer price index

	RA(r,h)		Representative agent
	NYSE
	GOVT

	TRANS
	
equations
	prf_YM(r,s)		mutable prod
	prf_YX(r,s)		extant prod
	prf_VA(r,s)
	prf_E(r,s)
	prf_X(r,g)		Disposition
	prf_A(r,g)		Absorption
	prf_CO2(r)
	prf_MS(r,m)		Margin supply
	prf_KS
	prf_INV(r)
	prf_Z(r,h)
	prf_W(r,h)
	prf_LS(r,h)
	prf_C(r,h)		Aggregate final demand

	mkt_PVA(r,s)
	mkt_PE(r,s)
	mkt_PA(r,g)		Regional market (input)
	mkt_PY(r,g)		Regional market (output)
	mkt_PD(r,g)		Local market price
	mkt_PN(g)		National market
	mkt_PL(r)		Wage rate
	mkt_RK(r,s)		Rental rate of capital - mutable
	mkt_RKX(r,s)	Rental rate of capital - extant
	mkt_RKS			
	mkt_PK
	mkt_PM(r,m)		Margin price
	mkt_PCO2
	mkt_PDCO2(r)
	mkt_PFX			Foreign exchange
	mkt_PINV(r)
	mkt_PZ(r,h)
	mkt_PW(r,h)
	mkt_PLS(r,h)
	mkt_PC(r,h)		Consumer price index
	
	bal_RA(r,h)		Representative agent
	bal_GOVT
	bal_NYSE

	aux_TRANS
;
* * value added
* $prod:VA(r,s)$[va_bar(r,s)] s:esub_va
*     o:PVA(r,s)  q:(va_bar(r,s))
*     i:RK(r,s)     q:(kd0(r,s))
*     i:PL(r)    q:(ld0(r,s))

* * energy
* $prod:E(r,s)$[en_bar(r,s)]  s:esub_ele(s) cgo:esub_fe(s) g.tl(cgo):0
*     o:PE(r,s)   q:(en_bar(r,s))
*     i:PA(r,g)$[ele(g)]  q:(id0(r,g,s))
*     i:PA(r,g)$[fe(g)]   q:(id0(r,g,s))  g.tl:
*     i:PDCO2(r)#(fe)   q:(dcb0(r,fe,s))    p:(1e-6)    fe.tl:

* $prod:YM(r,s)$[y_(r,s)]	s:esub_klem(s)	m:esub_ne(s) ve:esub_ve(s) g.tl(m):0
* 	o:PY(r,g)	q:ys0(r,s,g)	a:RA(r)	t:ty(r,s)	p:(1-ty0(r,s))
* 	i:PA(r,g)$[(not en(g))]		q:id0(r,g,s)	m:$((not cru(g)))	g.tl:$(cru(g))
* 	i:PE(r,s)$[en_bar(r,s)]		q:en_bar(r,s)	ve:
* 	i:PVA(r,s)$[va_bar(r,s)]	q:va_bar(r,s)	ve:
*     i:PDCO2(r)#(cru)  q:(dcb0(r,cru,s))    p:(1e-6)    cru.tl:	

parameter	lvs(r,s)	Labor value share;

$echo	lvs(r,s) = 0; lvs(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+kd0(r,s)*(1+tk0(r)));	>>MCPMODEL.GEN	

$macro	CVA(r,s)	(PL(r)**lvs(r,s) * ((RK(r,s)*((1+tk(r,s))/(1+tk0(r))))**(1-lvs(r,s))))
$macro  LD(r,s)         (ld0(r,s)*CVA(r,s)/PL(r))
$macro  KD(r,s)		(kd0(r,s)*CVA(r,s)/(RK(r,s)*((1+tk(r,s))/(1+tk0(r)))))

prf_VA(r,s)$[va_bar(r,s)]..		CVA(r,s)-PVA(r,s) =g= 0;


* Energy Nesting
parameters
	theta_fe(r,g,s)		share of g in total FE
	theta_en(r,g,s)		share of g in EN
	theta_ele(r,s)		share of ele in total EN
	theta_va(r,s) 		share of VA in total VA+EN
	theta_ene(r,s)		share of EN in total VA+EN
	theta_ne(r,g,s)		share of g in NE
	theta_kle(r,s)		share of kle in total kle+NE
	theta_m(r,s)		"(1-theta_kle)"
;

$echo	theta_fe(r,g,s)$[fe(g)$fe_bar(r,s)] = id0(r,g,s)/fe_bar(r,s);	>>MCPMODEL.GEN
$echo	theta_en(r,g,s)$[en(g)$en_bar(r,s)] = id0(r,g,s)/en_bar(r,s);	>>MCPMODEL.GEN
$echo	theta_ele(r,s) = sum(g$[ele(g)$theta_en(r,g,s)], theta_en(r,g,s));	>>MCPMODEL.GEN
$echo	theta_va(r,s)$[vaen_bar(r,s)] = va_bar(r,s)/vaen_bar(r,s);	>>MCPMODEL.GEN
$echo	theta_ene(r,s) = 1-theta_va(r,s);	>>MCPMODEL.GEN
$echo	theta_ne(r,g,s)$[nne(g)$ne_bar(r,s)] = id0(r,g,s)/ne_bar(r,s);	>>MCPMODEL.GEN
$echo	theta_kle(r,s)$[klem_bar(r,s)] = vaen_bar(r,s)/klem_bar(r,s);	>>MCPMODEL.GEN
$echo	theta_m(r,s) = 1-theta_kle(r,s);	>>MCPMODEL.GEN

$macro PID(r,g,s)	(PA(r,g)+(PDCO2(r)*cco2(r,g,s)))
$macro PCD(r,g)		(PA(r,g)+(PDCO2(r)*cco2(r,g,"fd")))

$macro CFE(r,s)	([sum(g.local$[fe(g)], theta_fe(r,g,s)*PID(r,g,s)**(1-esub_fe(s)))]**(1/(1-esub_fe(s))))
$macro CEN(r,s)	([sum(g.local$[ele(g)], theta_ele(r,s)*PID(r,g,s)**(1-esub_ele(s))) + (1-theta_ele(r,s))*CFE(r,s)**(1-esub_ele(s))]**(1/(1-esub_ele(s))))

$macro IDA_fe(r,g,s)	(([CEN(r,s)/CFE(r,s)]**esub_ele(s))*([CFE(r,s)/PID(r,g,s)]**esub_fe(s)))
$macro IDA_ele(r,g,s)	([CEN(r,s)/PID(r,g,s)]**esub_ele(s))

prf_E(r,s)$[en_bar(r,s)]..	CEN(r,s) - PE(r,s) =g= 0;

$macro CVE(r,s)	([theta_va(r,s)*CVA(r,s)**(1-esub_ve(s)) + (1-theta_va(r,s))*CEN(r,s)**(1-esub_ve(s))]**(1/(1-esub_ve(s))))
$macro CNE(r,s)	([sum(g.local$[nne(g)], theta_ne(r,g,s)*PID(r,g,s)**(1-esub_ne(s)))]**(1/(1-esub_ne(s))))
$macro CYM(r,s) ([theta_kle(r,s)*CVE(r,s)**(1-esub_klem(s)) + (1-theta_kle(r,s))*CNE(r,s)**(1-esub_klem(s))]**(1/(1-esub_klem(s))))

$macro IDA_ne(r,g,s)	(([CYM(r,s)/CNE(r,s)]**esub_klem(s))*([CNE(r,s)/PID(r,g,s)]**esub_ne(s)))
$macro IVA(r,s)	(([CYM(r,s)/CVE(r,s)]**esub_klem(s))*([CVE(r,s)/CVA(r,s)]**esub_ve(s)))
$macro IE(r,s)	(([CYM(r,s)/CVE(r,s)]**esub_klem(s))*([CVE(r,s)/CEN(r,s)]**esub_ve(s)))

* prf_YM(y_(r,s))..
* 		PVA(r,s)*va_bar(r,s)*IVA(r,s)$[va_bar(r,s)]
* 		+ PE(r,s)*en_bar(r,s)*IE(r,s)$[en_bar(r,s)]
* 		+ sum(g$[nne(g)],PID(r,g,s)*id0(r,g,s)*IDA_ne(r,g,s))
* 		=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));

* !!!! alternative unit form
* prf_YM(y_(r,s)).. CYM(r,s)
* 				  =g= sum(g,PY(r,g)*(ys0(r,s,g)/sum(gg,ys0(r,s,gg))))*(1-ty(r,s))/(1-ty0(r,s));

prf_YM(y_(r,s)).. CYM(r,s)*klem_bar(r,s)
				  =e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));


* $prod:YX(r,s)$[y_(r,s)$ks_x(r,s)]  s:0 va:0	g.tl:0
* 	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)	g.tl:$(em(g))
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:RKX(r,s)	q:kd0(r,s)	va:		a:GOVT	t:tk(r,s)	p:(1+tk0(r))
* 	i:PDCO2(r)#(em)		q:(dcb0(r,em,s))		p:(1e-6)	em.tl:


prf_YX(y_(r,s))$[ks_x(r,s)]..
		sum(g, PID(r,g,s)*id0(r,g,s)) + 
		PL(r)*ld0(r,s) + RKX(r,s)*((1+tk(r,s))/(1+tk0(r)))*kd0(r,s)*(1+tk0(r))
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
* o:PC(r)		q:c0(r)
* 	i:PA(r,g)	q:cd0(r,g)
 
alias(g,gg);
alias(r,rr);
alias(s,ss);

parameter theta_cd(r,g);
$echo theta_cd(r,g)=0; theta_cd(r,g)$[sum(gg,cd0(r,gg))] = cd0(r,g)/sum(gg,cd0(r,gg));	>>MCPMODEL.GEN

parameter theta_cd_h(r,g,h);
$echo theta_cd_h(r,g,h) = 0; theta_cd_h(r,g,h) = cd0_h(r,g,h)/sum(gg,cd0_h(r,gg,h));	>>MCPMODEL.GEN

$macro CC(r,h)	(sum(gg$theta_cd_h(r,gg,h),theta_cd_h(r,gg,h)*PCD(r,gg)**(1-esub_cd))**(1/(1-esub_cd)))
$macro CD(r,g,h)	((CC(r,h)/PCD(r,g))**esub_cd)

prf_C(r,h)..	CC(r,h) =g= PC(r,h);

* * co2 emissions
* $prod:CO2(r)
* 	o:PDCO2(r)	q:1
* 	i:PCO2		q:1		p:1
* 	i:PFX$[not carb0(r)]		q:(1e-6)

prf_CO2(r)..	PCO2 + PFX$[(not carb0(r))]*1e-6 =g= PDCO2(r);

* * investment supply
* $prod:INV(r) s:esub_inv
* 	o:PINV(r)	q:inv0(r)
* 	i:PA(r,g)	q:i0(r,g)


parameter theta_inv(r,g);
$echo theta_inv(r,g)=0; theta_inv(r,g)$[sum(gg,i0(r,gg))] = i0(r,g)/sum(gg,i0(r,gg));	>>MCPMODEL.GEN

$macro CINV(r)		(sum(gg, theta_inv(r,gg)*PA(r,gg)**(1-esub_inv))**(1/(1-esub_inv)))
$macro DINV(r,g)	((CINV(r)/PA(r,g))**esub_inv)

prf_INV(r)..	CINV(r) - PINV(r) =g= 0;


* $prod:LS(r,h)
* 	o:PL(q)	q:(le0(r,q,h))	a:GOVT	t:tl(r,h)	p:(1-tl0(r,h))
* 	i:PLS(r,h)	q:(ls0(r,h))

prf_LS(r,h)..		PLS(r,h)*ls0(r,h) - sum(q,PL(q)*le0(r,q,h)*(1-tl(r,h))) =g= 0;

* * capital transformation function
* $prod:KS	t:etaK
* 	o:RK(r,s)	q:ksrs_m0(r,s)
* 	i:RKS		q:(sum((r,s),ksrs_m0(r,s)))

parameter theta_ksm(r,s);
$echo theta_ksm(r,s)=0; theta_ksm(r,s) = ksrs_m0(r,s)/sum((rr,g),ksrs_m0(rr,g));	>>MCPMODEL.GEN

$macro CKS	(sum((rr,ss),theta_ksm(rr,ss)*RK(rr,ss)**(1+etaK))**(1/(1+etaK)))

prf_KS..	RKS - CKS =g= 0;

* $prod:Z(r,h)	s:0
* 	o:PZ(r,h)		q:z0_h(r,h)
* 	i:PC(r,h)		q:c0_h(r,h)
* 	i:PINV(r)		q:inv0_h(r,h)

parameter theta_z(r);
$echo theta_z(r)=0; theta_z(r)$z0(r) = leis_e0(r)/z0(r);	>>MCPMODEL.GEN

parameter theta_z_h(r,h);
$echo theta_z_h(r,h)=0; theta_z_h(r,h)$z0_h(r,h) = lsr0(r,h)/z0_h(r,h);	>>MCPMODEL.GEN

$macro CZ(r,h)	( (theta_z_h(r,h)*PLS(r,h)**(1-esub_zh(r,h)) + (1-theta_z_h(r,h))*PC(r,h)**(1-esub_zh(r,h)))**(1/(1-esub_zh(r,h))) )
$macro DC(r,h)	( (CZ(r,h)/PC(r,h))**esub_zh(r,h) )
$macro DLSR(r,h)	( (CZ(r,h)/PLS(r,h))**esub_zh(r,h) )

* prf_Z(r,h)..		PC(r,h)*c0_h(r,h) + PINV(r)*inv0_h(r,h) =g= PZ(r,h)*z0_h(r,h);
prf_Z(r,h)..		CZ(r,h) - PZ(r,h) =g= 0;

* $prod:W(r,h)	s:esub_zh(r,h)
* 	o:PW(r,h)		q:w0_h(r,h)
* 	i:PZ(r,h)		q:z0_h(r,h)
* 	i:PLS(r,h)		q:lsr0(r,h)

parameter theta_w(r);
$echo theta_w(r)=0; theta_w(r)$w0(r) = inv0(r)/w0(r);	>>MCPMODEL.GEN

parameter theta_w_h(r,h);
$echo theta_w_h(r,h)=0; theta_w_h(r,h)$w0_h(r,h) = inv0_h(r,h)/w0_h(r,h);	>>MCPMODEL.GEN

$macro CW(r,h)	( (theta_w_h(r,h)*PINV(r)**(1-esub_wh(r,h)) + (1-theta_w_h(r,h))*PZ(r,h)**(1-esub_wh(r,h)))**(1/(1-esub_wh(r,h))) )
$macro DZ(r,h)	( (CW(r,h)/PZ(r,h))**esub_wh(r,h) )
$macro DSAV(r,h)	( (CW(r,h)/PINV(r))**esub_wh(r,h) )

prf_W(r,h)..		CW(r,h) - PW(r,h) =g= 0;


* $demand:RA(r,h)
* 	d:PW(r,h)		q:w0_h(r,h)
* 	e:PFX			q:(sum(tp,hhtp0(r,h,tp)))	r:TRANS	
* 	e:PLS(r,h)		q:lsr0(r,h)
* 	e:PLS(r,h)		q:(ls0(r,h))
* 	e:PK			q:ke0(r,h)
* * !!!! fsav_h(r,h) has both positive and negative values
* * --- (not sure if it is technically foreign savings or some other type of adjustment)
* 	e:PFX			q:(fsav_h(r,h))
* * !!!! carbon endowment shared out according to population
* 	e:PCO2			q:(carb0(r)*(pop(r,h)/sum((hh),pop(r,hh))))
* *	e:PCO2			q:(sum(rr,carb0(rr))*(pop(r,h)/sum((hh,rr),pop(rr,hh))))


bal_RA(r,h).. 	RA(r,h)
			  	=e=
			  	PFX*sum(tp,hhtp0(r,h,tp))*TRANS
			  	+ PLS(r,h)*lsr0(r,h)
			  	+ PLS(r,h)*ls0(r,h)
			  	+ PK*ke0(r,h)
			  	+ PFX*fsav_h(r,h)
			  	+ PCO2*(carb0(r)*(pop(r,h)/sum((hh),pop(r,hh))));
*				+ PCO2*(carb0(r)*(pop(r,h)/sum((rr,hh),pop(rr,hh))));
			  
* $demand:GOVT
* 	d:PA(r,g)	q:g0(r,g)
* 	e:PFX		q:govdef0
* 	e:PFX		q:(-sum((r,h),tp0(r,h)))	r:TRANS

bal_GOVT..		sum((r,g),PA(r,g)*g0(r,g))
				=e=
				PFX*govdef0
				+ PFX*(-sum((r,h),tp0(r,h)))*TRANS
				+ sum(y_(r,s), YM(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
				+ sum(y_(r,s)$ks_x(r,s), YX(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
				+ sum(a_(r,g)$a0(r,g), A(r,g)*ta(r,g)*PA(r,g)*a0(r,g))
				+ sum(a_(r,g)$m0(r,g), A(r,g)*tm(r,g)*PFX*m0(r,g)*
						(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**esubdm(g))
				+ sum((r,s)$kd0(r,s),VA(r,s)*tk(r,s)*RK(r,s)*KD(r,s))
				+ sum((r,s)$kd0(r,s),YX(r,s)*tk(r,s)*RKX(r,s)*kd0(r,s))
				+ sum((r,h),LS(r,h)*tl(r,h)*sum(q,PL(q)*le0(r,q,h)));

* $demand:NYSE
* 	d:PK
* 	e:PY(r,g)				q:yh0(r,g)
* 	e:RKS			q:(sum(r,ks_m(r)))
* 	e:RKX(r,s)$[ks_x(r,s)]				q:ks_x(r,s)
* *	e:PREB(r,bt)$[activebt(r,bt)$swbt]	q:bse(r,"ff",bt)


bal_NYSE..		NYSE
				=e=
				sum((r,g),PY(r,g)*yh0(r,g))
				+ RKS*sum(r,ks_m(r))
				+ sum((r,s),RKX(r,s)*ks_x(r,s));

* $constraint:TRANS
* 	GOVT =e= sum((r,g), PA(r,g)*g0(r,g));

aux_TRANS..		GOVT =e= sum((r,g),PA(r,g)*g0(r,g));


*	Market clearance conditions:

mkt_PA(a_(r,g))..	A(r,g)*a0(r,g)
					=e=
					+ sum(y_(r,s), YM(r,s)*id0(r,g,s)*IDA_ne(r,g,s))$[nne(g)]
					+ sum(y_(r,s), E(r,s)*id0(r,g,s)*IDA_fe(r,g,s))$[fe(g)]
					+ sum(y_(r,s), E(r,s)*id0(r,g,s)*IDA_ele(r,g,s))$[ele(g)]
					+ sum(y_(r,s)$ks_x(r,s), YX(r,s)*id0(r,g,s))
					+ sum(h,C(r,h)*cd0_h(r,g,h)*CD(r,g,h))
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
				sum(a_(r,g), A(r,g) * dd0(r,g) * 
				(PND(r,g)/PD(r,g))**esubd(r,g) * (PMND(r,g)/PND(r,g))**esubdm(g))
				+ sum((m,gm)$sameas(g,gm), dm0(r,gm,m)*MS(r,m));

mkt_PN(g)..		sum(x_(r,g), X(r,g) * xn0(r,g) * (PN(g)/PY(r,g))**etranx(g)) =e= 
			sum(a_(r,g), A(r,g) * nd0(r,g) * (PND(R,G)/PN(g))**esubd(r,g) * (PMND(r,g)/PND(r,g))**esubdm(g))
			+ sum((r,m,gm)$sameas(g,gm), nm0(r,gm,m)*MS(r,m));


mkt_PFX..		sum(x_(r,g), X(r,g)*(x0(r,g)-rx0(r,g))*(PFX/PY(r,g))**etranx(g))
			+ sum(a_(r,g), A(r,g)*rx0(r,g)) 
			+ sum((r,h),fsav_h(r,h))
			+ sum((r,h,tp),hhtp0(r,h,tp))*TRANS
			- sum((r,h),tp0(r,h))*TRANS
			+ govdef0
			=e= 
			sum(a_(r,g), A(r,g)*m0(r,g)*(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**esubd(r,g));

mkt_PVA(r,s)$[va_bar(r,s)]..	VA(r,s)*va_bar(r,s) =g= YM(r,s)*va_bar(r,s)*IVA(r,s);

mkt_PE(r,s)$[en_bar(r,s)]..	E(r,s)*en_bar(r,s) =g= YM(r,s)*en_bar(r,s)*IE(r,s);

mkt_PL(q)..	sum((r,h),LS(r,h)*le0(r,q,h))
			=g= sum(y_(q,s), VA(q,s)*LD(q,s))
			+ sum(y_(q,s)$[ks_x(q,s)], YX(q,s)*ld0(q,s));


mkt_RK(r,s)$ksrs_m(r,s)..	KS*ksrs_m0(r,s)*((RK(r,s)/CKS)**etaK) =e= VA(r,s)*KD(r,s);

mkt_RKS..	sum(r,ks_m(r)) =g= KS*sum((r,s),ksrs_m0(r,s));

mkt_RKX(r,s)$ks_x(r,s)..	ks_x(r,s) =e= YX(r,s)*kd0(r,s);

mkt_PM(r,m)..		MS(r,m)*sum(gm,md0(r,m,gm)) =e= sum(a_(r,g),md0(r,m,g)*A(r,g));

mkt_PC(r,h).. 	C(r,h)*c0_h(r,h) =g= Z(r,h)*c0_h(r,h)*DC(r,h);

mkt_PINV(r).. 	INV(r)*inv0(r) =g= sum(h,W(r,h)*inv0_h(r,h)*DSAV(r,h));

mkt_PZ(r,h)..		Z(r,h)*z0_h(r,h) =g= W(r,h)*z0_h(r,h)*DZ(r,h);

mkt_PLS(r,h)..	(ls0(r,h)+lsr0(r,h)) =g= LS(r,h)*sum(q,le0(r,q,h)*(1-tl0(r,h))) + W(r,h)*lsr0(r,h)*DLSR(r,h);

mkt_PW(r,h)..		PW(r,h)*W(r,h)*w0_h(r,h) =g= RA(r,h);

mkt_PK..		PK*sum((r,h),ke0(r,h)) =g=	NYSE;

mkt_PCO2..		sum(r,carb0(r)) - sum(r,CO2(r)) =g= 0;

mkt_PDCO2(r)..	CO2(r)
				- (
					sum((g,s)$[y_(r,s)$ks_x(r,s)],YX(r,s)*id0(r,g,s)*cco2(r,g,s))
					+ sum((g,s)$[y_(r,s)$nne(g)],YM(r,s)*id0(r,g,s)*cco2(r,g,s)*IDA_ne(r,g,s))
					+ sum((g,s)$[y_(r,s)$fe(g)],E(r,s)*id0(r,g,s)*cco2(r,g,s)*IDA_fe(r,g,s))
					+ sum((g,s)$[y_(r,s)$ele(g)],E(r,s)*id0(r,g,s)*cco2(r,g,s)*IDA_ele(r,g,s))
					+ sum((g,h)$[cd0_h(r,g,h)],C(r,h)*cd0_h(r,g,h)*CD(r,g,h)*cco2_h(r,g,h))
				) =g= 0;


model mcpmodel /

	prf_YM.YM, prf_YX.YX, prf_X.X, prf_A.A, prf_C.C, prf_MS.MS,
	prf_LS.LS, prf_INV.INV, prf_Z.Z, prf_W.W, prf_KS.KS,
	prf_VA.VA, prf_E.E, prf_CO2.CO2,
	
	mkt_PA.PA, mkt_PY.PY, mkt_PD.PD, mkt_PN.PN, mkt_PL.PL,
	mkt_RK.RK, mkt_RKX.RKX, mkt_RKS.RKS, mkt_PK.PK
	mkt_PM.PM, mkt_PC.PC, mkt_PFX.PFX,
	mkt_PLS.PLS, mkt_PINV.PINV, mkt_PZ.PZ, mkt_PW.PW,
	mkt_PVA.PVA, mkt_PE.PE, mkt_PCO2.PCO2, mkt_PDCO2.PDCO2,

	bal_RA.RA, bal_GOVT.GOVT, bal_NYSE.NYSE
	aux_TRANS.TRANS 

/;

YX.l(r,s) = thetax;
YM.l(r,s) = 1-YX.l(r,s);
E.l(r,s) = YM.l(r,s);
VA.l(r,s) = YM.l(r,s);


CO2.l(r) = carb0(r);
PCO2.l = 1e-6;
PDCO2.l(r) = 1e-6;
