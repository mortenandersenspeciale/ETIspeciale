	clear
	*set matsize 11000

	*Valg af datasæt;
	*cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater" 
	cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater\KS"

	global data tax84_13_KS_NY
	global data_dta ${data}.dta


	use $data_dta, replace 

	gen Konstant=1

	do "D:\OIM\mora\Genestimation\STATA\labels til variable.do"

	doedit "D:\OIM\mora\Genestimation\STATA\startaar_amt.do"

	*Output destination
	cd "Y:\Projekt\OIM\MORA\Genestimation\Output"

	set more off, perm
	
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
	

/*****************************************/
/*   til at udregne predicted values 	*/
/****************************************/

reg diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13
predict yhat, xb
label var yhat "Ændring i log-indkomst renset for socioøko. var."	
	

/*Nye varaible der opdeler i grupper*/
gen logarbny=.
local i = 9
while `i'<= 15{
display `i'
replace logarbny=`i' if logarb>=`i' & logarb<`i'+0.05
local i = `i'+ 0.05
}
by logarbny, sort: sum logarb
/*Gemmer SD for hver gruppe*/
drop sdiff*
local j=1
local i = 9
while `i'<= 9.1{
display `i'
display `j'
sum diffarb3 if logarbny==`i'
egen sdiffarb3`j'=sd(diffarb) if logarbny==`i' 
local i = `i'+ 0.05
local j = `j'+ 1
}
sum sdiff*

/*Laver samlet variabel af SD*/
gen sdiffarb3=.
local i = 9
while `i'<= 15{
display `i'
replace sdiffarb3=sdiffarb3`i' if logarbny==`i'
local i = `i'+ 1
}

/**/

		
		
		
drop slow shigh
drop s x se 
lpoly sdiffarb3 logarbny if logarb>10 & logarb<15, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("219 129 103")) (line slow x, lcolor("219 129 103") lpattern(dash)) (line shigh x, lcolor("219 129 103") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log skattepligtig arbejdsindkomst") ytitle("Std. Fejl i Ændirngen i Log-Indkomst") legend(off) saving(fig1fase, replace)

graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\SDFIG1.png", as(png) replace
