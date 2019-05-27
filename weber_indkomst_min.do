
/*********************************************************************************************************/ 
	/* Based on the final estimation data set, this STATA-program produces the estimation results in Table 3 */              
	/*********************************************************************************************************/

	clear
	*set matsize 11000

	*Valg af datasæt;
	*cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater" 
	cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater"

	global data tax89_13_fuld_weber
	global data_dta ${data}.dta


	use $data_dta, replace 

	gen Konstant=1

	*do "D:\OIM\mora\Genestimation\STATA\labels til variable.do"

	doedit "D:\OIM\mora\Genestimation\STATA\startaar_amt.do"

	*Output destination
	cd "Y:\Projekt\OIM\MORA\Genestimation\Output"

	set more off, perm
	drop if arbstatus==0
	drop if arb<0
	drop if occ<=1
	drop if tiar>2010

	
	


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"

eststo clear
			
local i = 0
while `i'<= 2000000{
display `i'
eststo: ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder /*
				*/ gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 /*
				*/ind7 ind8 ind9 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13 (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & arb>=`i'/*
				*/, cluster(id_nr) 	
estadd local loop "Min indkomst `i'"
local i = `i'+ 100000
}
			

esttab using indkomstMINweber100FULD.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(loop N, label("max I" "Obs."))



