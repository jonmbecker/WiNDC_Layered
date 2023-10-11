$title MPSGE Model with Pooled National Markets

$ONTEXT
$model:mgemodel

$sectors:
	YM(r,s)$[y_(r,s)]				! Mutable production
	YX(r,s)$[y_(r,s)$ks_x(r,s)]		! Extant production
	VA(r,s)$[va_bar(r,s)]
	E(r,s)$[en_bar(r,s)]

	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	MS(r,m)			!	Margin supply

	INV(r)
	C(r,h)							! Household consumption
	Z(r,h)							! Full consumption
	W(r,h)							! Welfare index
 	LS(r,h)							! Labor supply

	KS$(not swrks)				! Aggregate capital supply
	CO2(r)			! co2 emissions
	
	Y_CLBS(r,s)$[clbs_act(r,s)]	! Generic clean backstop technology

$commodities:
	PE(r,s)$[en_bar(r,s)]
	PVA(r,s)$[va_bar(r,s)]
	PA(r,g)$a0(r,g)		!	Regional market (input)
	PY(r,g)$s0(r,g)		!	Regional market (output)
	PD(r,g)$xd0(r,g)	!	Local market price
	PN(g)			!	National market
	PL(r)			!	Wage rate

	RK(r,s)$[kd0(r,s)$(not swrks)]				! Sectoral rental rate (mutable)
	RKX(r,s)$[kd0(r,s)$ks_x(r,s)]	! Sectoral rental rate (extant)
	RKS			! Aggregate capital market price
	PK			! aggregate return to capital

	PM(r,m)			!	Margin price
	PFX			!	Foreign exchange

	PC(r,h)		! Final consumption price
	PZ(r,h)		! consumption and investment price
	PW(r,h)		! Welfare price
	PLS(r,h)	! Value of time endowment (leisure)

	PINV(r)		! investment price

	PCO2		! Carbon factor price
	PDCO2(r)	! Effective carbon price

	PR_CLBS(r,s)$[clbs_act(r,s)]	! CLBS tech-specific factor price

$consumer:
	RA(r,h)		! Representative agent
	NYSE		! Aggregate capital owner
	GOVT		! Aggregate government
	SUBA		! Subsidy handling agent

$auxiliary:
	TRANS		! Budget balance rationing constraint
	CLSUB_COST$[sw_clsub]	! clean subsidy cost
	SUBA_BAL	! Balance of SUBA
	OSUB$[sw_osub]	! Endogenous subsidy
	OSUBRAW$[sw_osub] ! raw subsidy value
	I_RKS_VA(r,s)$[va_bar(r,s)]	! mutable capital demand
	TK_SUB$[sw_tksub]	! Capital tax to cover output subsidy
	TK_SUB_RAW$[sw_tksub]

*------------------------------------------------------------------------
* Backstop CLBS - generic clean backstop tech
*------------------------------------------------------------------------

* generic clean backstop production
$prod:Y_CLBS(r,s)$[clbs_act(r,s)]	s:es_clbs(r,s)	mva:0 m(mva):0 va(mva):0
	o:PY(r,g)	q:clbs_out(r,s,g)
+		a:GOVT	t:ty(r,s)	p:(1-ty0(r,s))
* +		a:SUBA$[sw_clsub]	t:cl_sub$[sw_clsub]
+		a:GOVT$[sw_clsub]	t:cl_sub$[sw_clsub]
	i:PA(r,g)	q:(clbs_in(r,g,s)*clbs_mkup(r,s))		m:
	i:PL(r)		q:(clbs_in(r,"l",s)*clbs_mkup(r,s))		va:
	i:RK(r,s)$(not swrks)	q:(clbs_in(r,"k",s)*clbs_mkup(r,s))		va:
+		a:GOVT	t:tk(r,s)	p:(1-tk0(r))
	i:RKS$(swrks)	q:(clbs_in(r,"k",s)*clbs_mkup(r,s))		va:
+		a:GOVT	t:tk(r,s)	p:(1-tk0(r))
	i:PR_CLBS(r,s)	q:(clbs_in(r,"tsf",s)*clbs_mkup(r,s))
+		a:GOVT	t:tk(r,s)	p:(1-tk0(r))

*------------------------------------------------------------------------


* value added
$prod:VA(r,s)$[va_bar(r,s)] s:esub_va
    o:PVA(r,s)  q:(va_bar(r,s))
    i:RK(r,s)$(not swrks)     q:(kd0(r,s))
+		a:GOVT	t:tk(r,s)	p:(1+tk0(r))
* + 		a:SUBA$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
+ 		a:GOVT$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
    i:RKS$(swrks)     q:(kd0(r,s))
+		a:GOVT	t:tk(r,s)	p:(1+tk0(r))
* + 		a:SUBA$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
+ 		a:GOVT$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
    i:PL(r)    q:(ld0(r,s))

* energy
$prod:E(r,s)$[en_bar(r,s)]  s:esub_ele(s) cgo:esub_fe(s) g.tl(cgo):0
    o:PE(r,s)   q:(en_bar(r,s))
    i:PA(r,g)$[ele(g)]  q:(id0(r,g,s))
    i:PA(r,g)$[fe(g)]   q:(id0(r,g,s))  g.tl:
    i:PDCO2(r)#(fe)   q:(dcb0(r,fe,s))    p:(1e-6)    fe.tl:

$prod:YM(r,s)$[y_(r,s)]	s:esub_klem(s)	m:esub_ne(s) ve:esub_ve(s) g.tl(m):0
	o:PY(r,g)	q:ys0(r,s,g)
+		a:GOVT	t:ty(r,s)	p:(1-ty0(r,s))
* +		a:SUBA$[sw_osub]	t:o_sub$[sw_osub]
* +		a:SUBA$[sw_osub]	N:OSUB$[sw_osub] M:(-1)$[sw_osub]
* +		a:SUBA$[sw_osub_s(s)]	N:OSUB$[sw_osub_s(s)] M:(-1)$[sw_osub_s(s)]
* straight to GOVT to ease solver
* electricity specific subsidy
+		a:GOVT$[sw_osub_s(s)]	N:OSUB$[sw_osub_s(s)] M:(-1)$[sw_osub_s(s)]
* +		a:GOVT$[sw_osub]	t:o_sub$[sw_osub]
	i:PA(r,g)$[(not en(g))]		q:id0(r,g,s)	m:$((not cru(g)))	g.tl:$(cru(g))
	i:PE(r,s)$[en_bar(r,s)]		q:en_bar(r,s)	ve:
	i:PVA(r,s)$[va_bar(r,s)]	q:va_bar(r,s)	ve:
    i:PDCO2(r)#(cru)  q:(dcb0(r,cru,s))    p:(1e-6)    cru.tl:	

$prod:YX(r,s)$[y_(r,s)$ks_x(r,s)]  s:0 va:0	g.tl:0
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)    p:(1-ty0(r,s))
	i:PA(r,g)	q:id0(r,g,s)	g.tl:$(em(g))
	i:PL(r)		q:ld0(r,s)	va:
	i:RKX(r,s)	q:kd0(r,s)	va:
+		a:GOVT	t:tk(r,s)	p:(1+tk0(r))
* + 		a:SUBA$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
+ 		a:GOVT$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
	i:PDCO2(r)#(em)		q:(dcb0(r,em,s))		p:(1e-6)	em.tl:

$prod:X(r,g)$x_(r,g)  t:etranx(g)
	o:PFX		q:(x0(r,g)-rx0(r,g))
	o:PN(g)		q:xn0(r,g)
	o:PD(r,g)	q:xd0(r,g)
	i:PY(r,g)	q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:esubdm(g)  d(dm):esubd(r,g)
	o:PA(r,g)	q:a0(r,g)		a:GOVT	t:ta(r,g)	p:(1-ta0(r,g))
	o:PFX		q:rx0(r,g)
	i:PN(g)		q:nd0(r,g)	d:
	i:PD(r,g)	q:dd0(r,g)	d:
	i:PFX		q:m0(r,g)	dm: 	a:GOVT	t:tm(r,g) 	p:(1+tm0(r,g))
	i:PM(r,m)	q:md0(r,m,g)

$prod:MS(r,m)
	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
	i:PN(gm)	q:nm0(r,gm,m)
	i:PD(r,gm)	q:dm0(r,gm,m)

* final consumption
* $prod:C(r,h)	s:esub_cd	e:esub_ele("fd") cgo(e):esub_fe("fd") g.tl(cgo):0
* 	o:PC(r,h)	q:c0_h(r,h)
* 	i:PA(r,g)	q:(cd0_h(r,g,h)*aeei(r,g,"fd"))	e:$ele(g) g.tl:$em(g)
* 	i:PDCO2(r)#(em)$[swcarb]	q:(dcb0(r,em,"fd")*cd0_h_shr(r,em,h))	p:(1e-6) em.tl:

$prod:C(r,h)	s:esub_cd	g.tl:0
	o:PC(r,h)	q:c0_h(r,h)
	i:PA(r,g)	q:(cd0_h(r,g,h))	g.tl:$(em(g))
	i:PDCO2(r)#(em)	q:(dcb0(r,em,"fd")*cd0_h_shr(r,em,h))	p:(1e-6) 	em.tl:

* co2 emissions
$prod:CO2(r)
	o:PDCO2(r)	q:1
	i:PCO2		q:1		p:1
	i:PFX$[not carb0(r)]		q:(1e-6)


* investment supply
$prod:INV(r) s:esub_inv
	o:PINV(r)	q:inv0(r)
	i:PA(r,g)	q:i0(r,g)

$prod:LS(r,h)
	o:PL(q)	q:(le0(r,q,h)*gprod)	a:GOVT	t:tl(r,h)	p:(1-tl0(r,h))
	i:PLS(r,h)	q:(ls0(r,h)*gprod)

* capital transformation function
$prod:KS$(not swrks)	t:etaK
	o:RK(r,s)	q:ksrs_m0(r,s)
	i:RKS		q:(sum((r,s),ksrs_m0(r,s)))
* + 		a:GOVT$[sw_tksub]	N:TK_SUB$[sw_tksub]	m:(1)$[sw_tksub]
	

$prod:Z(r,h)	s:esub_zh(r,h)
	o:PZ(r,h)		q:z0_h(r,h)
	i:PC(r,h)		q:c0_h(r,h)
	i:PLS(r,h)		q:lsr0(r,h)

$prod:W(r,h)	s:esub_wh(r,h)
	o:PW(r,h)		q:w0_h(r,h)
	i:PZ(r,h)		q:z0_h(r,h)
	i:PINV(r)		q:inv0_h(r,h)

$demand:RA(r,h)
	d:PW(r,h)		q:w0_h(r,h)
	e:PFX			q:(sum(tp,hhtp0(r,h,tp)))	r:TRANS	
	e:PLS(r,h)		q:lsr0(r,h)
	e:PLS(r,h)		q:(ls0(r,h)*gprod)
	e:PK			q:ke0(r,h)
* !!!! fsav_h(r,h) has both positive and negative values
* --- (not sure if it is technically foreign savings or some other type of adjustment)
	e:PFX			q:(fsav_h(r,h))
* !!!! carbon endowment shared out according to population
	e:PCO2			q:(carb0(r)*(pop(r,h)/sum((hh),pop(r,hh))))
*	e:PCO2			q:(sum(rr,carb0(rr))*(pop(r,h)/sum((hh,rr),pop(rr,hh))))

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX		q:govdef0
	e:PFX		q:(-sum((r,h),tp0(r,h)))	r:TRANS
*	e:PFX$[(swjpow)]		q:(1)$[(swjpow)]		r:SUBA_BAL$[(swjpow)]
*	e:PFX		q:(-1)		r:SUBA_BAL
*	e:PFX$[(not swjpow)]		q:(-1)$[(not swjpow)]		r:SUBA_BAL$[(not swjpow)]
* offset raw output subsidy in FREE case
	e:PFX$[(swjpow)]		q:(1)$[(swjpow)]	r:OSUBRAW$[(swjpow)]

* subsidy handling agent
$demand:SUBA
	d:PFX		q:1
	e:PFX		q:1
	e:PFX		q:1	R:SUBA_BAL

* subsidy agent balance variable
$constraint:SUBA_BAL
	1 =e= SUBA;

* clean backstop subsidy cost
$constraint:CLSUB_COST$[sw_clsub]
	CLSUB_COST
	=e=
	-1*sum((r,s)$[clbs_act(r,s)],Y_CLBS(r,s)*sum(g,PY(r,g)*clbs_out(r,s,g))*cl_sub)
;

* output subsidy options
$constraint:OSUB$[sw_osub_rate$sw_osub]
	OSUB =e= o_sub
;

$constraint:OSUB$[sw_osub_raw$sw_osub]
*	sum((r,s),YM(r,s)*sum(g,PY(r,g)*ys0(r,s,g)))*OSUB =e= o_sub_raw
	sum((r,s)$[sw_osub_s(s)],YM(r,s)*sum(g,PY(r,g)*ys0(r,s,g)))*OSUB =e= o_sub_raw
;

$constraint:OSUBRAW$[sw_osub]
*	sum((r,s),YM(r,s)*sum(g,PY(r,g)*ys0(r,s,g)))*OSUB =e= o_sub_raw
	sum((r,s)$[sw_osub_s(s)],YM(r,s)*sum(g,PY(r,g)*ys0(r,s,g)))*OSUB =e= OSUBRAW
;

*------------------------------------------------------------------------
* subsidy financing mechanism
*------------------------------------------------------------------------

* mutable capital demand
$constraint:I_RKS_VA(r,s)$[va_bar(r,s)]
	I_RKS_VA(r,s)
	=e=
	kd0(r,s)*(PVA(r,s)/((RKS$(swrks)+(RK(r,s)+1e-6)$(not swrks))*((1+tk(r,s)+TK_SUB$[sw_tksub])/(1+tk0(r)))))**esub_va
*	kd0(r,s)*(PVA(r,s)/((RK(r,s)+1e-6)*((1+tk(r,s))/(1+tk0(r)))))**esub_va
;


* force capital tax rate to cover output subsidy rate
$constraint:TK_SUB$[sw_tksub]
	sum((r,s),
* Mutable --- I_RK_VA
		TK_SUB*(RKS$(swrks) + RK(r,s)$(not swrks))*VA(r,s)*I_RKS_VA(r,s)$[va_bar(r,s)$sw_tksub]
* Extant capital
		+ (TK_SUB*RKX(r,s)*YX(r,s)*kd0(r,s))$[y_(r,s)$ks_x(r,s)$sw_tksub]
	)
	=e=
	OSUBRAW$[sw_osub]
	+ CLSUB_COST$[sw_clsub]
;

* calculate value of capital tax
$constraint:TK_SUB_RAW$[sw_tksub]
	sum((r,s),
* Mutable --- I_RK_VA
		TK_SUB*(RKS$(swrks) + RK(r,s)$(not swrks))*VA(r,s)*I_RKS_VA(r,s)$[va_bar(r,s)$sw_tksub]
* Extant capital
		+ (TK_SUB*RKX(r,s)*YX(r,s)*kd0(r,s))$[y_(r,s)$ks_x(r,s)$sw_tksub]
	)
	=e=
	TK_SUB_RAW
;


$demand:NYSE
	d:PK
	e:PY(r,g)				q:yh0(r,g)
	e:RKS			q:(sum(r,ks_m(r)))
	e:RKX(r,s)$[ks_x(r,s)]				q:ks_x(r,s)
*	e:PREB(r,bt)$[activebt(r,bt)$swbt]	q:bse(r,"ff",bt)
	e:PR_CLBS(r,s)$[clbs_act(r,s)]	q:clbse(r,s)
	

$constraint:TRANS
	GOVT =e= sum((r,g), PA(r,g)*g0(r,g));


$OFFTEXT
$SYSINCLUDE mpsgeset mgemodel -mt=0

YX.l(r,s) = thetax;
YM.l(r,s) = 1-YX.l(r,s);
E.l(r,s) = YM.l(r,s);
VA.l(r,s) = YM.l(r,s);

CO2.l(r) = carb0(r);
PCO2.l = 1e-6;
PDCO2.l(r) = 1e-6;

TRANS.l = 1;
* if dynamic, must load in transfers from BaU case and fix
TRANS.fx$[swwaste] = 1;

* generic clean backstop initalization
Y_CLBS.l(r,s) = 0;
PR_CLBS.l(r,s) = 1e-6;
PR_CLBS.lo(r,s) = 1e-6;

SUBA_BAL.L = 0;
SUBA_BAL.lo = -inf;

* initialize mutable capital demand
I_RKS_VA.l(r,s)$[va_bar(r,s)] =
	kd0(r,s)*(PVA.l(r,s)/((RKS.l$(swrks) + (RK.l(r,s)+1e-6)$(not swrks))*((1+tk(r,s)+TK_SUB.l$[sw_tksub])/(1+tk0(r)))))**esub_va
;

OSUBRAW.lo = -inf;
TK_SUB.lo = -inf;
TK_SUB_RAW.lo = -inf;
