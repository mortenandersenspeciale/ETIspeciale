*********************************************************************************************************/ 
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
	gen lagarb1 = logarb[_n-1]
	gen lagarb2 = logarb[_n-2]
	gen lagarb3 = logarb[_n-3]
	gen lagarb4 = logarb[_n-4]
	gen lagarb5 = logarb[_n-5]
	gen lagarb6 = logarb[_n-6]
	
	gen dlagarb1 = lagarb1-lagarb2
	gen dlagarb2 = lagarb2-lagarb3
	gen dlagarb3 = lagarb3-lagarb4
	gen dlagarb4 = lagarb4-lagarb5
	gen dlagarb5 = lagarb5-lagarb5

	drop ograense
	drop ngraense
	gen ngraense=11
	gen ograense=15
	label var diffarb3 "Ændring i log-indkomst"
	label var diffmtr_arb_h_iv3 "Ændring i efter-skat-raten"

**SPLINES TIL LØNMODTAGERE (S-1)***
capture drop sp10plogarb*
mkspline sp10plogarb 10=plogarb2 if alder>15 & alder<75 & andel0<=0.5 & andel3<=0.5, pctile
do "D:\OIM\mora\Genestimation\STATA\labels til splines 10.do"

/*********/
/*FARVER */
/*********/
/*
gen color1=("0 70 64")
gen color2=("0 192 175")
gen color3=("161 204 165")
gen color4=("219 129 103")
*/


/*****************************************/
/*Instrumentet prediction - første fase */
/*****************************************/
twoway fpfitci diffmtr_arb_h3 diffmtr_arb_h_iv3 if logarb>5 & logarb<15 

drop slow shigh
drop s x se 
lpoly diffmtr_arb_h3 diffmtr_arb_h_iv3 if diffmtr_arb_h_iv3<0.2 & diffmtr_arb_h_iv3>-0.2 & diffmtr_arb_h3<0.2 & diffmtr_arb_h3>-0.2 & tiar==2008, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("219 129 103")) (line slow x, lcolor("219 129 103") lpattern(dash)) (line shigh x, lcolor("219 129 103") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Mekansik log-ændring i efterskat-raten") ytitle("Log-ændring i efterskat-raten") legend(off) saving(fig1fase, replace)

graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\1stage.png", as(png) replace

/* i 2005  er p20 arb=86k p25 arb=127k p30=  */




/*****************************************/
/*   til at udregne predicted values 	*/
/****************************************/

reg diffarb3 exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13
predict yhat, xb
label var yhat "Ændring i log-indkomst renset for socioøko. var."

reg diffarb3 sp10plogarb1 sp10plogarb2 sp10plogarb3 sp10plogarb4 sp10plogarb5 sp10plogarb6 sp10plogarb7 sp10plogarb8 sp10plogarb9 sp10plogarb10 dlogarb exp exp2 born alder gift unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13
predict yhat1, xb

/*DISTRIBUTION ANALYSE **/
histogram logarb if logarb>10 & logarb<14, frequency normal 

twoway (qfitci diffarb logarb) (qfitci yhat logarb) if logarb>10 & logarb<15
twoway (qfitci diffarb logarb) (qfitci yhat logarb) (qfitci yhat1 logarb) if logarb>10 & logarb<15




/*****************************************/
/*   MEAN REVERSION 2	hver for sig	*/
/****************************************/

drop s x se slow shigh
lpoly diffarb logarb if logarb>ngraens & logarb<ograense & tiar>2002 & tiar<2006, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("0 70 64")) (line slow x, lcolor("0 70 64") lpattern(dash)) (line shigh x, lcolor("0 70 64") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(off) saving(figa, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figa.png", as(png) replace


drop s x se slow shigh
lpoly yhat logarb if logarb>ngraens & logarb<ograense & tiar>2002 & tiar<2006, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("0 192 175")) (line slow x, lcolor("0 192 175") lpattern(dash)) (line shigh x, lcolor("0 192 175") lpattern(dash)),/*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(off) saving(figb, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figb.png", as(png) replace

drop s x se slow shigh
lpoly diffarb lagarb3 if lagarb3>ngraens & lagarb3<ograense & tiar>2002 & tiar<2006, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("161 204 165")) (line slow x, lcolor("161 204 165") lpattern(dash)) (line shigh x, lcolor("161 204 165") lpattern(dash)),/*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-indkomst") ytitle("Ændringen i logarbejde") legend(off) saving(figc, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\figc.png", as(png) replace

drop s x se slow shigh
lpoly yhat lagarb3 if lagarb3>ngraens & lagarb3<ograense & tiar>2002 & tiar<2006, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("219 129 103")) (line slow x, lcolor("219 129 103") lpattern(dash)) (line shigh x, lcolor("219 129 103") lpattern(dash)),/*
*/graphregion(color(white) fcolor(white)) xtitle("Log-indkomst") ytitle("Ændringen i logarbejde") legend(off) saving(figd, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\figd.png", as(png) replace

graph combine figa.gph figb.gph figc.gph figd.gph, graphregion(color(white)) rows(4) xsize(8) ysize(12) saving(figur.gph, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\First stage\figsamlet.png", as(png) replace


/*****************************************/
/*   MEAN REVERSION 2	LPOLY			*/
/****************************************/

/*********************/
/**INDKOMST basisåret**/
/*********************/
drop s x se slow shigh s2 x2 se2 slow2 shigh2
lpoly diffarb logarb if logarb>ngraens & logarb<ograense & diffarb<0.75 & diffarb>-0.75 /*& tiar>2002 & tiar<2006*/, gen (x s) se(se) noscatter degree(4) 
lpoly yhat logarb if logarb>ngraens & logarb<ograense & diffarb<0.75 & diffarb>-0.75/*& tiar>2002 & tiar<2006*/, gen (x2 s2) se(se2) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
gen slow2=s2-1.96*se2
gen shigh2=s2+1.96*se2
sort x

twoway (line s x, lwidth(thick) lcolor("0 70 64")) (line slow x, lcolor("0 70 64") lpattern(dash)) (line shigh x, lcolor("0 70 64") lpattern(dash)) /*
*/(line s2 x2, lwidth(thick) lcolor("0 192 175")) (line slow2 x2, lcolor("0 192 175") lpattern(dash)) (line shigh2 x2, lcolor("0 192 175") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 4) label (1 "Ingen kontrol") label (4 "Kontrol")) saving(figur1a, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur1a075075og114.png", as(png) replace


/***ØVRIGE*******/
twoway (fpfit s x, lwidth(thick) lcolor("0 70 64")) /*
*/(fpfit s2 x2, lwidth(thick) lcolor("0 192 175")) , /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 2) label (1 "Ingen kontrol") label (2 "Kontrol")) saving(figur1b, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur1b.png", as(png) replace
twoway (lfit s x, lwidth(thick) lcolor("0 70 64"))  /*
*/(lfit s2 x2, lwidth(thick) lcolor("0 192 175")) , /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 2) label (1 "Ingen kontrol") label (2 "Kontrol")) saving(figur1c, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur1c.png", as(png) replace



/*********************/
/**LAGGET INDKOMST***/
/********************/
drop s x se slow shigh s2 x2 se2 slow2 shigh2
lpoly diffarb lagarb3 if lagarb3>ngraens & lagarb3<ograense & tiar>2002 & tiar<2006, gen (x s) se(se) noscatter degree(4) 
lpoly yhat lagarb3 if lagarb3>ngraens & lagarb3<ograense & tiar>2002 & tiar<2006, gen (x2 s2) se(se2) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
gen slow2=s2-1.96*se2
gen shigh2=s2+1.96*se2
sort x

twoway (line s x, lwidth(thick) lcolor("0 70 64")) (line slow x, lcolor("0 70 64") lpattern(dash)) (line shigh x, lcolor("0 70 64") lpattern(dash)) /*
*/(line s2 x2, lwidth(thick) lcolor("0 192 175")) (line slow2 x2, lcolor("0 192 175") lpattern(dash)) (line shigh2 x2, lcolor("0 192 175") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Lagget Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 4) label (1 "Ingen kontrol") label (4 "Kontrol")) saving(figur2a, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur2a.png", as(png) replace


/***ØVRIGE*******/
twoway (fpfit s x, lwidth(thick) lcolor("0 70 64")) /*
*/(fpfit s2 x2, lwidth(thick) lcolor("0 192 175")) , /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 2) label (1 "Ingen kontrol") label (2 "Kontrol")) saving(figur2b, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur2b.png", as(png) replace
twoway (lfit s x, lwidth(thick) lcolor("0 70 64"))  /*
*/(lfit s2 x2, lwidth(thick) lcolor("0 192 175")) , /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-Indkomst") ytitle("Ændring i Log-Indkomst") ylabel(-1 (1) 1) legend(order(1 2) label (1 "Ingen kontrol") label (2 "Kontrol")) saving(figur2c, replace)
graph export "D:\OIM\mora\Genestimation\Programmer\Figurer\Figur mean reversion\figur2c.png", as(png) replace







/*****************************************/
/*            MEAN REVERSION X			*/
/****************************************/

drop slow shigh
drop s x se 
lpoly diffarb3 diffmtr_arb_h3 if tiar==2009, gen (x s) se(se) noscatter degree(4) 
gen slow=s-1.96*se
gen shigh=s+1.96*se
sort x
twoway (line s x, lwidth(thick) lcolor("219 129 103")) (line slow x, lcolor("219 129 103") lpattern(dash)) (line shigh x, lcolor("219 129 103") lpattern(dash)), /*
*/ graphregion(color(white) fcolor(white)) xtitle("Log-indkomst") ytitle("Ændringen i logarbejde") legend(off) saving(figc, replace)

export excel x s se slow shigh using "D:\OIM\mora\Genestimation\Programmer\Figurer\et.xls"  if !missing(x)




/*   !!!!!OLD!!!!
twoway (fpfit diffarb3 logarb if logarb>ngraens & logarb<ograense & tiar==2009, lwidth(thick) lcolor("0 70 64") yaxis(1)), graphregion(color(white) fcolor(white)) xtitle("Log-indkomst") ytitle("Ændringen i logarbejde")
twoway (fpfit diffarb3 logarb if logarb>ngraens & logarb<ograense)   (fpfit diffarb3 lagarb2 if lagarb2>ngraens & lagarb2<ograense) (fpfit diffarb3 lagarb3 if lagarb3>ngraens & lagarb3<ograense) (fpfit diffarb3 lagarb4 if lagarb4>ngraens & lagarb4<ograense) if tiar==2009
*/
