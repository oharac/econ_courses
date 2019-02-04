* ECON241B: PS5
* Casey O'Hara
* 3/6/18


set more off
clear

// Set working directory

cd "~/github/econ_courses/econ241b/assts/asst5"

/*
The key variables:
	e1 = effort of type 1 workers 
	w1 = wage of type 1 workers 
	w2 = wage of type 2 workers
	pubwage = flag for public-wage regime
*/
clear all
use "prob_set_5.dta"

// drop non-public wages
drop if pubwage != 1

// drop unused columns
keep wrk1id wrk2id period e1 e2 w1 w2

///////////////////////////////////////////////
// Part A: Type 1 Workers (low productivity)
///////////////////////////////////////////////

// create relative wage variable
gen rel_w1 = w1 - w2

// create indicator for wage 1 <= wage 2
gen w1_low = (w1 <= w2)

// calculate rel wage * dummy
gen rel_w1_low = rel_w1 * w1_low


// regress variables for public wages for low productivity workers (1).
// Col 6: effort vs wage and relative wage (< 0, asymmetric model)
//   with fixed effects of period
// Col 7: effort vs wage and relative wage (< 0, asymmetric model)
//   with fixed effects of worker and period
eststo clear 

// For fixed effects, we use xtreg instead of reg; use xtset to set the
// panel variable(s)
/*
xtset period
xtreg e1 i.w1 rel_w1_low, fe
*/
//Nope, just use regress; add 'robust cluster()' option
xi: reg e1 i.w1 rel_w1_low i.period, robust cluster(wrk1id)
eststo col_a6


test _Iw1_1 = _Iw1_2 = _Iw1_3
/*
xtset wrk1id period
xtreg e1 i.w1 rel_w1_low i.period, fe
*/
xi: reg e1 i.w1 rel_w1_low i.period i.wrk1id, robust cluster(wrk1id)
eststo col_a7
test _Iw1_1 = _Iw1_2 = _Iw1_3


esttab col_a6 col_a7 using table3a67.tex, ///
	drop(*wrk1id* *period* *cons*) title(A: Type 1 workers) noconst b(%10.4g) ///
	se r2 nostar replace
	

///////////////////////////////////////////////
// Part B: Type 2 Workers (high productivity)
///////////////////////////////////////////////

// create relative wage variable
gen rel_w2 = w2 - w1

// create indicator for wage 1 <= wage 2
gen w2_low = (w2 <= w1)

// calculate rel wage * dummy
gen rel_w2_low = rel_w2 * w2_low

// regress variables for public wages, for high productivity workers (2).
// Col 1: effort vs wage
// Col 2: effort vs wage and relative wage (symmetric model)
// Col 3: effort vs wage and relative wage (< 0, asymmetric model)
eststo clear 

xi: reg e2 i.w2 rel_w2_low i.period, robust cluster(wrk2id)
eststo col_b6
test _Iw2_1 = _Iw2_2 = _Iw2_3 = _Iw2_4

/*
xtset wrk1id period
xtreg e1 i.w1 rel_w1_low i.period, fe
*/
xi: reg e2 i.w2 rel_w2_low i.period i.wrk2id, robust cluster(wrk2id)
eststo col_b7
test _Iw2_1 = _Iw2_2 = _Iw2_3 = _Iw2_4


esttab col_b6 col_b7 using table3b67.tex, ///
	drop(*wrk2id* *period* *cons*) title(B: Type 2 workers) noconst b(%10.4g) ///
	se r2 nostar replace
