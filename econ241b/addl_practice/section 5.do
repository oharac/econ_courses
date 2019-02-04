/*
Author: Jaime Ramirez-Cuellar
Date: February 16, 2018
Purpose: section 5
*/

clear all 
set more off // memory 

cd // what's my cd?

help help // help

* this is a comment

// this is a comment

/*
this is 
a
comment
*/


sysuse census //call data from census

keep state // keep variable state

gen country = "US" // generate string

save myfile.dta, replace // save data to cd

clear all
set obs 1
gen state = "Puerto Rico"  

save toappend, replace


drop _all // drops all variables
*drop x

preserve
di "Hola"
restore

* Scalar
scalar a = 1

* Matrix
matrix a = 0,0

* Macros
local abcd "a b c d e rest"
global abcd "ab cd"

* Loops of lists
foreach v of local abcd { // very important!!
di "`v'" 	// calling a local
di "$abcd" // calling a global
}

* Loops of numbers
scalar t = 0
forvalues i=1/10{ // very important!!
scalar t = t + `i'
di t
}

use myfile, clear // calls data from cd

sysuse census

* Merge
merge 1:1 state using myfile, gen(mymerge) // this is a merge
tab mymerge // nice merge?

* Append
append using toappend

* Generate variables
gen death2 = death^2

* Replace
replace death2 = . if state=="California"

* Values of a variable???
tab death // short for tabulate
tab state 
sum death // short for summary
des death // short for describe
des *

* Histogram
histogram pop // check pop up menu

* Scatter
scatter pop death
scatter death medage

* Regress
regress death medage i.region [aw=pop]
estimates store e3 // save estimates in e3
* install outreg2 (outreg.ado)
outreg2 [e3] using ../data/type1.tex, tex label replace pvalue // saves tables in nice form

* Temporal files
tempfile temp1 
save `temp1'
clear all 
use `temp1'

