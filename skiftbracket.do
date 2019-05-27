	clear
	*set matsize 11000

	*Valg af datasæt;
	*cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater" 
	cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater"

	global data sbdatasaet
	global data_dta ${data}.dta


	use $data_dta, replace 

	gen Konstant=1


/*Nye varaible der opdeler i grupper*/
gen logarbny=.
local i = 9
while `i'<= 15{
display `i'
replace logarbny=`i' if logarb>=`i' & logarb<`i'+0.05
local i = `i'+ 0.05
}
by logarbny, sort: sum sb
/*Gemmer SD for hver gruppe*/
drop sdiff*
local j=1
local i = 9
while `i'<= 9.1{
display `i'
display `j'
sum yhat if logarbny==`i'
egen sdyhat`j'=sd(yhat) if logarbny==`i' 
local i = `i'+ 0.05
local j = `j'+ 1
}
by logarbny, sort: sum sdyhat*



		
		
		
drop slow shigh
drop s x se 
lpoly sdiffarb3 logarbny if logarb>10 & logarb<15, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("219 129 103")) (line slow x, lcolor("219 129 103") lpattern(dash)) (line shigh x, lcolor("219 129 103") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log skattepligtig arbejdsindkomst") ytitle("Std. Fejl i Ændirngen i Log-Indkomst") legend(off) saving(fig1fase, replace)

graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\SDFIG1.png", as(png) replace
