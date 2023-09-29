$stitle clean backstop initialization

scalar swclbs	generic clean backstop switch	/%swclbsval%/;

parameter clbs_act(r,s)	clean (cl) backstop (bs) active or inactive;
clbs_act(r,s) = no;

* choose sectors to create clean backstop substitute
* only electricity for now
clbs_act(r,s)$[swclbs$(sum(g,ys0(r,s,g)))$ele(s)] = yes;
display swclbs, clbs_act;

parameters
	c_clbs0		store costs original
	c_clbs		store costs	new
	cs_clbs		store cost chares new
	tax			taxes raw

	clbs_in		backstop input (enters model)
	clbs_out	backstop output(enters model)
	chk_clbs_bal	balance checking

* tech specific factor and backstop evolution setup
	clbs_mkup	markup factor
	es_clbs 	substitution elasticity with fixed tech specific factor
	clbse0		base year backstop resource endowment
	clbse		backstop resource endowment
	clTSF0		base year backstop tech specific factor supply
	clTSF		backstop tech specific factor supply
	q_clbs		backstop quantity produced

;

alias(xx,*);

* store benchmark costs
c_clbs0(r,"k",s) = (kd0(r,s)*(1+tk0(r))); 
c_clbs0(r,"l",s) = ld0(r,s); 
* c_clbs0(r,"fr",s) = fr0(r,s)*(1+tk0(r)); 
c_clbs0(r,"fr",s) = 0; 
c_clbs0(r,g,s) = id0(r,g,s); 
c_clbs0(r,"total",s) = sum(xx,c_clbs0(r,xx,s)); 
c_clbs0(r,"va",s) = c_clbs0(r,"k",s)+c_clbs0(r,"l",s); 

* populate new costs
c_clbs(r,"k",s) = c_clbs0(r,"k",s) ;
c_clbs(r,"l",s) = c_clbs0(r,"l",s) ;
c_clbs(r,"fr",s) = c_clbs0(r,"fr",s) ;
c_clbs(r,g,s) = c_clbs0(r,g,s) ;

* !!!! store raw taxes in case we need to recompute rate (keep simple for now)
tax(r,"k",s) = kd0(r,s)*tk0(r);

* remove fossil fuels energy from costs and replace with capital and labor
* share out value added by k/l and distribute energy accordingly
c_clbs(r,g,s)$[fe(g)] = 0;
c_clbs(r,"k",s)$[c_clbs0(r,"va",s)] = c_clbs0(r,"k",s)
	+ sum(fe, c_clbs0(r,fe,s))*(c_clbs0(r,"k",s)/c_clbs0(r,"va",s));
c_clbs(r,"l",s)$[c_clbs0(r,"va",s)] = c_clbs0(r,"l",s)
	+ sum(fe, c_clbs0(r,fe,s))*(c_clbs0(r,"l",s)/c_clbs0(r,"va",s));


* store total cost new
c_clbs(r,"total",s) = sum(xx,c_clbs(r,xx,s));

* store cost shares new
cs_clbs(r,"k",s)$[c_clbs(r,"total",s)] = c_clbs(r,"k",s)/c_clbs(r,"total",s);
cs_clbs(r,"l",s)$[c_clbs(r,"total",s)] = c_clbs(r,"l",s)/c_clbs(r,"total",s);
cs_clbs(r,"fr",s)$[c_clbs(r,"total",s)] = c_clbs(r,"fr",s)/c_clbs(r,"total",s);
cs_clbs(r,g,s)$[c_clbs(r,"total",s)] = c_clbs(r,g,s)/c_clbs(r,"total",s);
cs_clbs(r,"total",s) = sum(xx,cs_clbs(r,xx,s));

* begin assigning backstop values

* output in share form
clbs_out(r,s,g)$[clbs_act(r,s)$(sum(g.local,ys0(r,s,g)))] = (ys0(r,s,g)/sum(g.local,ys0(r,s,g)))/(1-ty0(r,s));

* inputs in share form
clbs_in(r,"k",s)$[clbs_act(r,s)] = cs_clbs(r,"k",s)/(1+tk0(r));
clbs_in(r,"l",s)$[clbs_act(r,s)] = cs_clbs(r,"l",s);
clbs_in(r,"fr",s)$[clbs_act(r,s)] = cs_clbs(r,"fr",s)/(1+tk0(r));
clbs_in(r,g,s)$[clbs_act(r,s)] = cs_clbs(r,g,s);

* balance check (this is a check on the cost structure that will enter the model)
chk_clbs_bal(r,s) = sum(g,clbs_out(r,s,g))*(1-ty0(r,s))
	- clbs_in(r,"k",s)*(1+tk0(r))
	- clbs_in(r,"l",s)
	- clbs_in(r,"fr",s)*(1+tk0(r))
	- sum(g,clbs_in(r,g,s))
;

display chk_clbs_bal;

* calibration method loosely based on:
* Advanced Technologies in energy-economy models for climate change assessment
* J.F. Morris, J. Reilly, Y. Chen
* https://www.sciencedirect.com/science/article/pii/S0140988319300490

* add technology specific factor and rebalance
* !!!! could readjust capital tax rate in future, not going to mess with it for now
clbs_in(r,"tsf",s)$[clbs_act(r,s)] = 0.01;
clbs_in(r,"k",s)$[clbs_act(r,s)] = clbs_in(r,"k",s)-clbs_in(r,"tsf",s);

* add back in "fr" for now as well - since no backstop on resource extraction sectors
clbs_in(r,"k",s)$[clbs_act(r,s)] = clbs_in(r,"k",s) + clbs_in(r,"fr",s);

* set markup factor
* greater than 1 for initially non-binding backstop
clbs_mkup(r,s)$[clbs_act(r,s)] = 1.1;

* set tsf substitution elasticity (top level nest)
* this nest makes it so you can't build infinitely, can only build so much without prohibitive costs
es_clbs(r,s) = 0.30;

* initialize tsf endowment updating process
* the factor accumulation process in loop_bs.gms increases the endowment each year
* meant to represent technological change as new technologies emerge
loop(yr$(yr.val eq %bmkyr%),

clTSF0(r,s,yr)$[clbs_act(r,s)] = clbs_in(r,"tsf",s)*clbs_mkup(r,s)*0.014*sum(g,ys0(r,s,g))*(1-ty0(r,s));
* clTSF0(r,s,yr)$[clbs_act(r,s)] = 1e-6;
clTSF(r,s,yr) = clTSF0(r,s,yr);

clbse0(r,s)$[clbs_act(r,s)] = clTSF(r,s,yr);
clbse(r,s) = clbse0(r,s);

);
