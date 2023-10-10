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
* switch to enable output subsidy
$if not set sw_osub_rawval $setglobal sw_osub_rawval 0
* switch to enable output subsidy
$if not set sw_osub_rateval $setglobal sw_osub_rateval 0
* output subsidy rate
$if not set osubval $setglobal osubval 0.05
* output subsidy raw val billions
$if not set osubrawval $setglobal osubrawval 100

scalar sw_osub "switch for output subsidy" /%sw_osubval%/;
scalar sw_osub_raw "switch for output subsidy based on value" /%sw_osub_rawval%/;
scalar sw_osub_rate "switch for output subsidy based on rate" /%sw_osub_rateval%/;

parameters
	o_sub
	o_sub_raw
;

o_sub = 0;
o_sub_raw = 0;

parameter sw_osub_s(s)	sector specific switch;

sw_osub_s(s)$ele(s) = sw_osub;

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




