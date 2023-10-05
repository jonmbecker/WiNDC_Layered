$title initialize policy

*------------------------------------------------------------------------
* clean subsidy
*------------------------------------------------------------------------
* switch to enable clean subsidy
$if not set sw_clsubval $setglobal sw_clsubval 0
* clean subsidy rate
$if not set clsubval $setglobal clsubval 0.2

scalar sw_clsub	"switch for subsidy on cl" /%sw_clsubval%/;

parameters
	cl_sub_yr		subsidy rate on clean electricity backstop
	cl_sub			subsidy rate on clean electricity backstop
;

cl_sub = 0;
cl_sub_yr(t) = 0;

* date to start the subsidy
loop(t$[t.val>2020],
cl_sub_yr(t) = %clsubval%;
);

*------------------------------------------------------------------------
* output subsidy
*------------------------------------------------------------------------
* switch to enable output subsidy
$if not set sw_osubval $setglobal sw_osubval 0
* output subsidy rate
$if not set osubval $setglobal osubval 0.05

scalar sw_osub "switch for output subsidy" /%sw_osubval%/;

parameters
	o_sub
;

o_sub = 0;


*------------------------------------------------------------------------
* closure rule
*------------------------------------------------------------------------

* switch to enable free deficit subsidy
$if not set swjpowval $setglobal swjpowval 0
* switch to enable government waste
$if not set swwasteval $setglobal swwasteval 0

parameters
	swjpow
	swwaste
;

swjpow = %swjpowval%;
swwaste = %swwasteval%;




