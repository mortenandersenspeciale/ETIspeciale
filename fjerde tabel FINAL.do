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
	gen logarb2=logarb*logarb
	gen logarb3=logarb*logarb*logarb
	/*gen p1logarb = logarb[_n-1]*/
	gen p2logarb = logarb[_n-2]
	gen p3logarb = logarb[_n-3]
	gen dlagarb2 = p1logarb-p2logarb
	gen dlagarb3 = p2logarb-p3logarb

/*	**SPLINES TIL LØNMODTAGERE (S-2)***
capture drop sp10plogarb*
mkspline sp10p2logarb 10=p2logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s2.do"	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"	
*/
	
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
	

/*****************************/
/****     50 procent(0)   ******/
/***************************/	
	eststo clear

eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 		
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 

esttab using output_nul_lag_hele.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))


/*****************************/
/****     50 procent(-1)   ******/
/***************************/	
	
eststo clear
eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 

esttab using output_et_lag_hele.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))



/*****************************/
/****     50 procent (-2)   ******/
/***************************/	
	eststo clear


eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 


esttab using output_to_lag_hele.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))





/*******************/
/***GODE PERIODE***/
/*****************/


drop if tiar>2010
drop if tiar<2006 & tiar>1996

/*
**SPLINES TIL LØNMODTAGERE (S-2)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=p2logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s2.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
*/

**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	




/*****************************/
/****     50 procent(0)   ******/
/***************************/	
eststo clear
eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 		
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 		
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 


esttab using output_nul_lag_gode.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))


/*****************************/
/****     50 procent(-1)   ******/
/***************************/	
	eststo clear
eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 

esttab using output_et_lag_gode.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))



/*****************************/
/****     50 procent (-2)   ******/
/***************************/	
eststo clear
eststo:  ivreg2 diffarb0 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 

esttab using output_to_lag_gode.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))


/****************************/
/**  YDERLIGERE TEST  på god periode**/
/**********************/
/**** Ingen vægt ***/
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0 diffvir_h10=diffmtr_arb_h_iv_1 diffvir_h1_iv_1) if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estad local andet "Ingen vægt"
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0 diffvir_h10=diffmtr_arb_h_iv_1 diffvir_h1_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estad local andet "Vægt"

/**** NO KINK AND INCOME EFFECTS***/
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0 diffvir_h10=diffmtr_arb_h_iv_1 diffvir_h1_iv_1) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estad local andet "No kink og indkomsteffekt"


/*****DIFFERENCE-IN-SARGAN TEST*****/
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv0 diffmtr_arb_h_iv_1 diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, robust cluster(id_nr) orthog(diffmtr_arb_h_iv0) first savefirst				
estad local andet "Diff-in-Sargan Test"
/*****DIFFERENCE-IN-SARGAN TEST*****/
eststo:  ivreg2 diffarb0 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h0=diffmtr_arb_h_iv_1 diffmtr_arb_h_iv_2) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, robust cluster(id_nr) orthog(diffmtr_arb_h_iv0) first savefirst				
estad local andet "Diff-in-Sargan Test"



esttab using Test.text, replace fragment booktabs keep(diffmtr_arb_h0) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(N N_clust cstatp widstat, label("Obs." "Personer" "halløj" "F-test"))

