$stitle initialize policy

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

