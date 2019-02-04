
set more off 
clear

cd "~/github/econ_courses/econ241b/assts/asst3"

/*
Read through the paper by Charness and Kuhn listed on the syllabus. Write
programs in both Matlab and Stata (the results from each program should match) 
that estimate the model in columns (1), (2) and (3) of Table 3 of Charness and 
Kuhn. Calculate classic standard errors (the authors report cluster-robust 
standard errors, so your estimated standard errors will not match those in the 
table).
    
Finally, for the models of columns (2) and (3) test the hypothesis that the 
coefficient on relative wage equals zero and provide the p-value for the 
estimated test statistic.
The key variables:

e1 = effort of type 1 workers 
w1 = wage of type 1 workers 
w2 = wage of type 2 workers

From the paper, Table 3:
Effects of Wages on WorkersÕ Effort, Public-Wage Regime
pubwage = flag for public-wage regime

*/
clear all
use "prob_set_3.dta"

******************
**Table 1 A
******************

eststo clear 

eststo: quietly reg e1 w1 if pubwage==1

*Generate relative wage
gen r_w1 = w1-w2

eststo: quietly reg e1 w1 r_w1 if pubwage==1

*Test for value 0
test r_w1=0

*Generate relative wage X dummmy
gen d_r_w1 = r_w1
replace d_r_w1 = 0 if r_w1>0

eststo: quietly reg e1 w1 d_r_w1 if pubwage==1

test d_r_w1=0

esttab, noconst b(%10.3g) se r2 nostar replace

****************
**Table 1 B
****************

eststo clear 

eststo: quietly reg e2 w2 if pubwage==1

gen r_w2 = w2-w1

eststo: quietly reg e2 w2 r_w2 if pubwage==1

*Test for value 0
test r_w2=0

*Generate relative wage X dummmy
gen d_r_w2 = r_w2
replace d_r_w2 = 0 if r_w2>0

eststo: quietly reg e2 w2 d_r_w2 if pubwage==1

test d_r_w2=0

esttab, noconst b(%10.3g) se r2 nostar replace
esttab using reg1.tex , noconst b(%10.3g) se r2 nostar replace
