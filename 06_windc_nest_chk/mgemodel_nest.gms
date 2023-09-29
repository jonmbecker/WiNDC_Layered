$title MPSGE Model with Pooled National Markets

$ONTEXT
$model:mgemodel

$sectors:
*	Y(r,s)$y_(r,s)		!	Production
	YM(r,s)$[y_(r,s)]				! Mutable production
	YX(r,s)$[y_(r,s)$ks_x(r,s)]		! Extant production
	VA(r,s)$[va_bar(r,s)]
	E(r,s)$[en_bar(r,s)]

	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	C(r)			!	Aggregate final demand
	MS(r,m)			!	Margin supply

	LS(r)			! labor supply
	INV(r)			! Investment supply
	Z(r)			! consumption and investment
	W(r)			! Welfare index - full consumption

	KS				! Aggregate capital supply
	CO2(r)			! co2 emissions
	
$commodities:
	PE(r,s)$[en_bar(r,s)]
	PVA(r,s)$[va_bar(r,s)]
	PA(r,g)$a0(r,g)		!	Regional market (input)
	PY(r,g)$s0(r,g)		!	Regional market (output)
	PD(r,g)$xd0(r,g)	!	Local market price
	PN(g)			!	National market
	PL(r)			!	Wage rate
*	PK(r,s)$kd0(r,s)	!	Rental rate of capital
	RK(r,s)$[kd0(r,s)]				! Sectoral rental rate (mutable)
	RKX(r,s)$[kd0(r,s)$ks_x(r,s)]	! Sectoral rental rate (extant)
	RKS			! Aggregate return to capital

	PM(r,m)			!	Margin price
	PC(r)			!	Consumer price index
	PFX			!	Foreign exchange

	PLS(r)		! opportunity cost of working
	PINV(r)		! investment price
	PZ(r)		! consumption and investment index
	PW(r)		! welfare full consumption price index

	PCO2		! Carbon factor price
	PDCO2(r)	! Effective carbon price

$consumer:
	RA(r)			!	Representative agent


* value added
$prod:VA(r,s)$[va_bar(r,s)] s:esub_va
    o:PVA(r,s)  q:(va_bar(r,s))
    i:RK(r,s)     q:(kd0(r,s))
    i:PL(r)    q:(ld0(r,s))

* energy
$prod:E(r,s)$[en_bar(r,s)]  s:esub_ele(s) cgo:esub_fe(s) g.tl(cgo):0
    o:PE(r,s)   q:(en_bar(r,s))
    i:PA(r,g)$[ele(g)]  q:(id0(r,g,s))
    i:PA(r,g)$[fe(g)]   q:(id0(r,g,s))  g.tl:
    i:PDCO2(r)#(fe)   q:(dcb0(r,fe,s))    p:(1e-6)    fe.tl:

* $prod:YM(r,s)$[y_(r,s)$(not oil(s))]	s:esub_klem(s)	m:esub_ne(s) ve:esub_ve(s)
* 	o:PY(r,g)	q:ys0(r,s,g)	a:RA(r)	t:ty(r,s)	p:(1-ty0(r,s))
* 	i:PA(r,g)$[(not en(g))]		q:id0(r,g,s)	m:
* 	i:PE(r,s)$[en_bar(r,s)]		q:en_bar(r,s)	ve:
* 	i:PVA(r,s)$[va_bar(r,s)]	q:va_bar(r,s)	ve:	

* $prod:YM(r,s)$[y_(r,s)$oil(s)]	s:esub_klem(s)	m:esub_ne(s) ve:esub_ve(s) g.tl(m):0
* 	o:PY(r,g)	q:ys0(r,s,g)	a:RA(r)	t:ty(r,s)	p:(1-ty0(r,s))
* 	i:PA(r,g)$[(not en(g))]		q:id0(r,g,s)	m:$((not cru(g)))	g.tl:$(cru(g))
* 	i:PE(r,s)$[en_bar(r,s)]		q:en_bar(r,s)	ve:
* 	i:PVA(r,s)$[va_bar(r,s)]	q:va_bar(r,s)	ve:
*     i:PDCO2(r)#(cru)  q:(dcb0(r,cru,s))    p:(1e-6)    cru.tl:	

$prod:YM(r,s)$[y_(r,s)]	s:esub_klem(s)	m:esub_ne(s) ve:esub_ve(s) g.tl(m):0
	o:PY(r,g)	q:ys0(r,s,g)	a:RA(r)	t:ty(r,s)	p:(1-ty0(r,s))
	i:PA(r,g)$[(not en(g))]		q:id0(r,g,s)	m:$((not cru(g)))	g.tl:$(cru(g))
	i:PE(r,s)$[en_bar(r,s)]		q:en_bar(r,s)	ve:
	i:PVA(r,s)$[va_bar(r,s)]	q:va_bar(r,s)	ve:
    i:PDCO2(r)#(cru)  q:(dcb0(r,cru,s))    p:(1e-6)    cru.tl:	


* $prod:YM(r,s)$y_(r,s)  s:0 va:1	g.tl:0
* 	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)	g.tl:$(em(g))
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:RK(r,s)	q:kd0(r,s)	va:
* 	i:PDCO2(r)#(em)		q:(dcb0(r,em,s))		p:(1e-6)	em.tl:

$prod:YX(r,s)$[y_(r,s)$ks_x(r,s)]  s:0 va:0	g.tl:0
	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
	i:PA(r,g)	q:id0(r,g,s)	g.tl:$(em(g))
	i:PL(r)		q:ld0(r,s)	va:
	i:RKX(r,s)	q:kd0(r,s)	va:
	i:PDCO2(r)#(em)		q:(dcb0(r,em,s))		p:(1e-6)	em.tl:

$prod:X(r,g)$x_(r,g)  t:etranx(g)
	o:PFX		q:(x0(r,g)-rx0(r,g))
	o:PN(g)		q:xn0(r,g)
	o:PD(r,g)	q:xd0(r,g)
	i:PY(r,g)	q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:esubdm(g)  d(dm):esubd(r,g)
	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta(r,g)	p:(1-ta0(r,g))
	o:PFX		q:rx0(r,g)
	i:PN(g)		q:nd0(r,g)	d:
	i:PD(r,g)	q:dd0(r,g)	d:
	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm(r,g) 	p:(1+tm0(r,g))
	i:PM(r,m)	q:md0(r,m,g)

$prod:MS(r,m)
	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
	i:PN(gm)	q:nm0(r,gm,m)
	i:PD(r,gm)	q:dm0(r,gm,m)

* $prod:C(r)  s:esub_cd	e:esub_ele("fd") cgo(e):esub_fe("fd") g.tl(cgo):0
*     o:PC(r)		q:c0(r)
* 	i:PA(r,g)	q:cd0(r,g)	e:$(ele(g))	g.tl:$(em(g))
* 	i:PDCO2(r)#(em)		q:(dcb0(r,em,"fd"))		p:(1e-6)	em.tl:

$prod:C(r)  s:esub_cd	g.tl:0
    o:PC(r)		q:c0(r)
	i:PA(r,g)	q:cd0(r,g)	g.tl:$(em(g))
	i:PDCO2(r)#(em)		q:(dcb0(r,em,"fd"))		p:(1e-6)	em.tl:

* co2 emissions
$prod:CO2(r)
	o:PDCO2(r)	q:1
	i:PCO2		q:1		p:1
	i:PC(r)$[not carb0(r)]		q:(1e-6)


* investment supply
$prod:INV(r) s:esub_inv
	o:PINV(r)	q:inv0(r)
	i:PA(r,g)	q:i0(r,g)

* labor supply
$prod:LS(r)
	o:PL(r)		q:(lab_e0(r))
	i:PLS(r)	q:(lab_e0(r))

* capital transformation function
$prod:KS	t:etaK
	o:RK(r,s)	q:ksrs_m0(r,s)
	i:RKS		q:(sum((r,s),ksrs_m0(r,s)))

* consumption + investment
$prod:Z(r)	s:0
	o:PZ(r)		q:z0(r)
	i:PC(r)		q:c0(r)
	i:PINV(r)	q:inv0(r)

* full consumption
$prod:W(r)	s:esub_z(r)
	o:PW(r)		q:w0(r)
	i:PZ(r)		q:z0(r)
	i:PLS(r)	q:leis_e0(r)

* income balance
$demand:RA(r)
	d:PW(r)		q:w0(r)
	e:PY(r,g)	q:yh0(r,g)
	e:PFX		q:(bopdef0(r) + hhadj(r))
	e:PA(r,g)	q:(-g0(r,g))
	e:PLS(r)	q:(lab_e0(r))
	e:PLS(r)	q:leis_e0(r)
*	e:PK(r,s)	q:kd0(r,s)
*	e:RK(r,s)	q:ksrs_m(r,s)
	e:RKS		q:ks_m(r)	
	e:RKX(r,s)	q:ks_x(r,s)
	e:PCO2		q:carb0(r)

$OFFTEXT
$SYSINCLUDE mpsgeset mgemodel -mt=0

YX.l(r,s) = thetax;
YM.l(r,s) = 1-YX.l(r,s);
E.l(r,s) = YM.l(r,s);
VA.l(r,s) = YM.l(r,s);

CO2.l(r) = carb0(r);
PCO2.l = 1e-6;
PDCO2.l(r) = 1e-6;