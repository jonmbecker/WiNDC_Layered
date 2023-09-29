$title MPSGE Model with Pooled National Markets

$ONTEXT
$model:mgemodel

$sectors:
*	Y(r,s)$y_(r,s)		!	Production
	YM(r,s)$[y_(r,s)]				! Mutable production
	YX(r,s)$[y_(r,s)$ks_x(r,s)]		! Extant production

	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	C(r)			!	Aggregate final demand
	MS(r,m)			!	Margin supply

	LS(r)			! labor supply
	INV(r)			! Investment supply
	Z(r)			! consumption and investment
	W(r)			! Welfare index - full consumption
	
$commodities:
	PA(r,g)$a0(r,g)		!	Regional market (input)
	PY(r,g)$s0(r,g)		!	Regional market (output)
	PD(r,g)$xd0(r,g)	!	Local market price
	PN(g)			!	National market
	PL(r)			!	Wage rate
*	PK(r,s)$kd0(r,s)	!	Rental rate of capital
	RK(r,s)$[kd0(r,s)]				! Sectoral rental rate (mutable)
	RKX(r,s)$[kd0(r,s)$ks_x(r,s)]	! Sectoral rental rate (extant)

	PM(r,m)			!	Margin price
	PC(r)			!	Consumer price index
	PFX			!	Foreign exchange

	PLS(r)		! opportunity cost of working
	PINV(r)		! investment price
	PZ(r)		! consumption and investment index
	PW(r)		! welfare full consumption price index

$consumer:
	RA(r)			!	Representative agent


$prod:YM(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
	i:PA(r,g)	q:id0(r,g,s)
	i:PL(r)		q:ld0(r,s)	va:
	i:RK(r,s)	q:kd0(r,s)	va:	

$prod:YX(r,s)$[y_(r,s)$ks_x(r,s)]  s:0 va:0
	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
	i:PA(r,g)	q:id0(r,g,s)
	i:PL(r)		q:ld0(r,s)	va:
	i:RKX(r,s)	q:kd0(r,s)	va:	

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

$prod:C(r)  s:esub_cd
    o:PC(r)		q:c0(r)
	i:PA(r,g)	q:cd0(r,g)

* investment supply
$prod:INV(r) s:esub_inv
	o:PINV(r)	q:inv0(r)
	i:PA(r,g)	q:i0(r,g)

* labor supply
$prod:LS(r)
	o:PL(r)		q:(lab_e0(r))
	i:PLS(r)	q:(lab_e0(r))

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
	e:RK(r,s)	q:ksrs_m(r,s)
	e:RKX(r,s)	q:ks_x(r,s)

$OFFTEXT
$SYSINCLUDE mpsgeset mgemodel -mt=0

YX.l(r,s) = thetax;
YM.l(r,s) = 1-YX.l(r,s);
