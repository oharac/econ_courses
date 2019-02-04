* ECON241B: PS3  
* Casey O'Hara
* casey.c.ohara@gmail.com
* created: February 17, 2018
* updated: February 17, 2018

set more off 
clear

// Set working directory

cd "~/github/econ_courses/econ241b/assts/asst3"

/*
The key variables:
	e1 = effort of type 1 workers 
	w1 = wage of type 1 workers 
	w2 = wage of type 2 workers
	pubwage = flag for public-wage regime
*/
clear all
use "prob_set_3.dta"

// drop unused columns
keep wrk1id wrk2id period e1 e2 w1 w2 pubwage

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
// Col 1: effort vs wage
// Col 2: effort vs wage and relative wage (symmetric model)
// Col 3: effort vs wage and relative wage (< 0, asymmetric model)
eststo clear 

reg e1 w1            if pubwage == 1
eststo col_a1 

reg e1 w1 rel_w1     if pubwage == 1
eststo col_a2 
test rel_w1 = 0

reg e1 w1 rel_w1_low if pubwage == 1
eststo col_a3 
test rel_w1_low = 0

esttab col_a1 col_a2 col_a3 using table3a.tex, title(B: Type 1 workers) ///
	noconst b(%10.3g) se r2 nostar replace
	

	
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

reg e2 w2            if pubwage == 1
eststo col_b1 

reg e2 w2 rel_w2     if pubwage == 1
eststo col_b2 
test rel_w2 = 0

reg e2 w2 rel_w2_low if pubwage == 1
eststo col_b3 
test rel_w2_low = 0

esttab col_b1 col_b2 col_b3 using table3b.tex, title(B: Type 2 workers) ///
	noconst b(%10.3g) se r2 nostar replace

///////////////////////////////////////////////
// Export data to .csv
///////////////////////////////////////////////

outsheet period	wrk2id	wrk1id	w1	w2	e1	e2	pubwage ///
	using prob_set3.csv, comma replace
