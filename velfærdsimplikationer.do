
/*********************************************************************************************************/ 
	/* Based on the final estimation data set, this STATA-program produces the estimation results in Table 3 */              
	/*********************************************************************************************************/

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
	drop if arbstatus==0
	drop if arb<0
	drop if occ<=1
	drop if tiar>2010
drop arbhj* gnsarb* alpha*
/*******************/
/****Hele periode***/
/*******************/
gen arbhj1=arb if arb>350000
sum arbhj1
gen gnsarb1=r(mean)

gen arbhj2=arb if arb>400000
sum arbhj2
gen gnsarb2=r(mean)

gen arbhj3=arb if arb>750000
sum arbhj3
gen gnsarb3=r(mean)

gen arbhj4=arb if arb>1000000
sum arbhj4
gen gnsarb4=r(mean)

/*alpha=gns/(gns-grænse)*/
gen alpha1=gnsarb1/(gnsarb1-350000)
gen alpha2=gnsarb2/(gnsarb2-400000)
gen alpha3=gnsarb3/(gnsarb3-750000)
gen alpha4=gnsarb4/(gnsarb4-1000000)


/*******************/
/****Nyere tid***/
/*******************/
gen arbhj1ny=arb if arb>350000 & tiar>2008
sum arbhj1ny
gen gnsarb1ny=r(mean)

gen arbhj2ny=arb if arb>400000 & tiar>2008
sum arbhj2ny
gen gnsarb2ny=r(mean)

gen arbhj3ny=arb if arb>750000 & tiar>2008
sum arbhj3ny
gen gnsarb3ny=r(mean)

gen arbhj4ny=arb if arb>1000000 & tiar>2008
sum arbhj4ny
gen gnsarb4ny=r(mean)

/*alpha=gns/(gns-grænse)*/
gen alpha1ny=gnsarb1ny/(gnsarb1ny-350000)
gen alpha2ny=gnsarb2ny/(gnsarb2ny-400000)
gen alpha3ny=gnsarb3ny/(gnsarb3ny-750000)
gen alpha4ny=gnsarb4ny/(gnsarb4ny-1000000)
sum alpha*



drop alpha* p* arbhj* gnsarb*				

local i = 1
while `i'<= 99{
display `i'
egen p`i'=pctile(arb), p(`i')
gen arbhj`i'=arb if arb>=p`i'
sum arbhj`i'
gen gnsarb`i'=r(mean)
gen alpha`i'=gnsarb`i'/(gnsarb`i'-p`i')
local i = `i'+ 1
}

sum alpha*


drop alpha* p* arbhj* gnsarb*				

local i = 1
while `i'<= 99{
display `i'
egen p`i'=pctile(arb) if tiar>2008, p(`i')
gen arbhj`i'=arb if arb>=p`i' & tiar>2008
sum arbhj`i'
gen gnsarb`i'=r(mean)
gen alpha`i'=gnsarb`i'/(gnsarb`i'-p`i')
local i = `i'+ 1
}

sum alpha*

	