/*********************************************************************************************************/ 
	/* Based on the final estimation data set, this STATA-program produces the estimation results in Table X */              
	/*********************************************************************************************************/
	clear
	*set matsize 11000

	*Valg af datasæt;
	*cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater" 
	cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater\KS\100%"

	global data tax84_13_fuldmodel 
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


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	
	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

/*****************************/
/****     50 procent   ******/
/***************************/	
	
eststo clear
	***Ingen socio****
eststo: qui ivreg2 diffarb3 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Nej"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo: qui ivreg2 diffarb3 logarb d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Nej"
estadd local kink "Inkl." 	
estadd local income ">0k" 
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Nej"
estadd local kink "Inkl." 	
estadd local income ">0k" 
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Nej"
estadd local kink "Inkl." 	
estadd local income ">0k" 

***Socioøkonomiske****
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 		
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 	
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 , cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">0k" 
	
*****NO KINK*****
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Ekskl." 	
estadd local income ">0k" 	
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Ekskl." 	
estadd local income ">0k" 
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Ekskl." 	
estadd local income ">0k" 
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & kink==0, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Ekskl." 	
estadd local income ">0k" 

**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>100000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	
	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>100000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

***100k>*******	
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">100k" 	
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">100k" 
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">100k"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local controls "Ja"
estadd local kink "Inkl." 	
estadd local income ">100k" 



esttab using output_50pct.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))





/*****************************/
/****     Ingen part 1   ******/
/***************************/
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & overfor0==0 & overfor3==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"		
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & overfor0==0 & overfor3==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if overfor0==0 & overfor3==0 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if overfor0==0 & overfor3==0 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if overfor0==0 & overfor3==0 & tiar<2011, cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if overfor0==0 & overfor3==0 & tiar<2011 , cluster(id_nr) first savefirst				


esttab using output_ingenpart1.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))




/*****************************/
/****     Ingen part 2   ******/
/***************************/
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0==0 & andel3==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0==0 & andel3==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0==0 & andel3==0 & tiar<2011, cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0==0 & andel3==0 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0==0 & andel3==0 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0==0 & andel3==0 & tiar<2011 , cluster(id_nr) first savefirst				

esttab using ingenpart2.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))



/*****************************/
/****     10 procent   ******/
/***************************/
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.1 & andel3>=0 & andel3<=0.1 & tiar<2011 , cluster(id_nr) first savefirst				


	esttab using output_10pct.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
	mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))



/*****************************/
/****     25 procent   ******/
/***************************/
**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"	
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
eststo clear	
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25 & tiar<2011 , cluster(id_nr) first savefirst				
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0>=0 & andel0<=0.25 & andel3>=0 & andel3<=0.25 & tiar<2011 , cluster(id_nr) first savefirst				

	esttab using output_25pct.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
	mgroups("Lønmodtagere", pattern(1 0 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	star(* .1 ** .05 *** .01) brackets se nomtitles stats(controls kink income N, label("Kontrolvariable" "Skattebetalere omkring knæk" "Indkomstrestrektion" "Obs."))	
