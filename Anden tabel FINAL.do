/*********************************************************************************************************/ 
	/* Based on the final estimation data set, this STATA-program produces the estimation results in Table 3 */              
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
	gen col=0
	replace col=1 if udd4==1 | udd5==1 
	gen alder2=alder*alder
	gen alud1=alder*udd1
	gen alud2=alder*udd2
	gen alud3=alder*udd3
	gen alud4=alder*udd4
	gen alud5=alder*udd5
	gen alud0=alder*udd0
	gen logarb2=logarb*logarb
	gen logarb3=logarb*logarb*logarb
	gen logarb4=logarb*logarb*logarb*logarb
	gen logarb5=logarb*logarb*logarb*logarb*logarb	
	gen arbgraense=0


**SPLINES TIL LØNMODTAGERE (S-1)***
	capture drop sp10plogarb*
	mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense, pctile
	do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
	***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
	capture drop sp10logarb*
	mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense, pctile
	do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

eststo clear
/**** SAMLET *****/
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "SAMLET"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "SAMLET"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "SAMLET"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "SAMLET"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "SAMLET"

/***ØVRIGE KONTROLVARIABLE****/
eststo: qui ivreg2 diffarb3 exp exp2 born alder alder2 alud1 alud2 alud3 alud4 alud5 alud0 gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "KONTROLVAR"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder alder2 alud1 alud2 alud3 alud4 alud5 alud0 gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "KONTROLVAR"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder alder2 alud1 alud2 alud3 alud4 alud5 alud0 gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "KONTROLVAR"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder alder2 alud1 alud2 alud3 alud4 alud5 alud0 gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "KONTROLVAR"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder alder2 alud1 alud2 alud3 alud4 alud5 alud0 gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "KONTROLVAR"

	/***BRED INDKOMST****/
eststo: qui ivreg2 diffbroad3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "BRED I"
eststo: qui ivreg2 diffbroad3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "BRED I"
eststo: qui ivreg2 diffbroad3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "BRED I"
eststo: qui ivreg2 diffbroad3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "BRED I"
eststo: qui ivreg2 diffbroad3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense, cluster(id_nr) first savefirst				
estadd local type "BRED I"

esttab using forste.text, replace fragment booktabs keep(diffmtr_arb_h3 diffmtr_kap_h3 diffvir_h13) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))



**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & kapstatus==1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & kapstatus==1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

	/***KRYDSSKAT****/
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffmtr_kap_h3=diffmtr_arb_h_iv3 diffmtr_kap_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & kapstatus==1, cluster(id_nr) first savefirst				
estadd local type "KRYDSSKAT" 
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffmtr_kap_h3=diffmtr_arb_h_iv3 diffmtr_kap_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & kapstatus==1, cluster(id_nr) first savefirst				
estadd local type "KRYDSSKAT" 
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffmtr_kap_h3=diffmtr_arb_h_iv3 diffmtr_kap_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & kapstatus==1, cluster(id_nr) first savefirst				
estadd local type "KRYDSSKAT" 
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffmtr_kap_h3=diffmtr_arb_h_iv3 diffmtr_kap_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & kapstatus==1, cluster(id_nr) first savefirst				
estadd local type "KRYDSSKAT"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffmtr_kap_h3=diffmtr_arb_h_iv3 diffmtr_kap_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & kapstatus==1, cluster(id_nr) first savefirst				
estadd local type "KRYDSSKAT" 

esttab using krydsskat.text, replace fragment booktabs keep(diffmtr_arb_h3 diffmtr_kap_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>100000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>100000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

/***INDKOSMTEFFEKT****/
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffvir_h13=diffmtr_arb_h_iv3 diffvir_h1_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local type "INDKOMSTEFFEKT"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffvir_h13=diffmtr_arb_h_iv3 diffvir_h1_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local type "INDKOMSTEFFEKT"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffvir_h13=diffmtr_arb_h_iv3 diffvir_h1_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local type "INDKOMSTEFFEKT"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffvir_h13=diffmtr_arb_h_iv3 diffvir_h1_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local type "INDKOMSTEFFEKT"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3 diffvir_h13=diffmtr_arb_h_iv3 diffvir_h1_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>100000, cluster(id_nr) first savefirst				
estadd local type "INDKOMSTEFFEKT"

esttab using indkomsteffekt.text, replace fragment booktabs keep(diffmtr_arb_h3 diffvir_h13) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & born>0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & born>0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
	/***BØRN****/
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & born>0, cluster(id_nr) first savefirst				
estadd local type "BØRN"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & born>0, cluster(id_nr) first savefirst				
estadd local type "BØRN"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & born>0, cluster(id_nr) first savefirst				
estadd local type "BØRN"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & born>0, cluster(id_nr) first savefirst				
estadd local type "BØRN"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & born>0, cluster(id_nr) first savefirst				
estadd local type "BØRN"

esttab using BORN.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))



**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & alder>=20 & alder<=60 , pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & alder>=20 & alder<=60 , pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

	/***ALDER****/
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "ALDER"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "ALDER"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "ALDER"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "ALDER"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "ALDER"
esttab using alder.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>175000 & arb<1500000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>175000 & arb<1500000, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

	/***INDKOMST****/
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>175000 & arb<1500000, cluster(id_nr) first savefirst				
estadd local type "INDKOMST"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>175000 & arb<1500000, cluster(id_nr) first savefirst				
estadd local type "INDKOMST"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>175000 & arb<1500000 & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "INDKOMST"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>175000 & arb<1500000 & alder>=20 & alder<=60 , cluster(id_nr) first savefirst				
estadd local type "INDKOMST"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>175000 & arb<1500000, cluster(id_nr) first savefirst				
estadd local type "INDKOMST"

esttab using Indkomstrestrk.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))


**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & mand==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & mand==0, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"

	/***KVINDER****/
eststo clear
eststo: qui ivreg2 diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & mand==0 , cluster(id_nr) first savefirst				
estadd local type "KVINDER"
eststo: qui ivreg2 diffarb3 logarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & mand==0 , cluster(id_nr) first savefirst				
estadd local type "KVINDER"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & mand==0 , cluster(id_nr) first savefirst				
estadd local type "KVINDER"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & mand==0 , cluster(id_nr) first savefirst				
estadd local type "KVINDER"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & mand==0 , cluster(id_nr) first savefirst				
estadd local type "KVINDER"

esttab using Kvinder.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))




**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & col==1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"
***SPLINES TIL LØNMODTAGERE AF INDKOMST(S)****
capture drop sp10logarb*
mkspline sp10logarb 10=logarb if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5 & arb>arbgraense & col==1, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10_s.do"
	/***UDDANNELSE1****/
eststo clear
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & col==1, cluster(id_nr) first savefirst				
estadd local type "UDD1"	
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & col==1, cluster(id_nr) first savefirst				
estadd local type "UDD1"
eststo: qui ivreg2 diffarb3 sp10logarb1 sp10logarb2 sp10logarb3 sp10logarb4 sp10logarb5 sp10logarb6 sp10logarb7 sp10logarb8 sp10logarb9 sp10logarb10 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & col==1, cluster(id_nr) first savefirst				
estadd local type "UDD1"
eststo: qui ivreg2 diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & col==1, cluster(id_nr) first savefirst				
estadd local type "UDD1"
eststo: qui ivreg2 diffarb3 logarb logarb2 logarb3 logarb4 logarb5 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 /*
*/ d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13  (diffmtr_arb_h3=diffmtr_arb_h_iv3) [aw=arb] if andel0<=0.5 & andel3<=0.5 & tiar<2011 & arb>arbgraense & col==1, cluster(id_nr) first savefirst				
estadd local type "UDD1"
	

esttab using Uddannelse.text, replace fragment booktabs keep(diffmtr_arb_h3) label ///
mgroups("Lønmodtagere", pattern(1 0 0 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
star(* .1 ** .05 *** .01) brackets se nomtitles stats(type N, label("type" "Obs."))


			

	






