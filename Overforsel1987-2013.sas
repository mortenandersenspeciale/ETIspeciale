libname bif  "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater";
libname div  "Y:\Projekt\OIM\MORA\Genestimation\Data\Diverse";
libname div2 "Y:\Projekt\FM\Skatteelasticiteter\Diverse";

*%let date = %sysfunc(today(),ddmmyyn6.);
%let date = 240419;
%let indkomstbegreb=LOENMV; *Bruges kun til navngivning;
%let datanavn=tax89_13_Fuldmodel_&date.;

%let keep= id_nr arbstatus arb parb occ alder tiar plogarb2 diffarb: diffkap: dlogarb2 exp exp2 born gift KOM unem gdp mand udd1 udd2 udd3 udd4 udd5 udd0 amt1 amt2 amt3 amt4 amt5 amt6 amt7 amt8 amt9 amt10 
		   amt11 amt12 amt13 amt14 amt15 ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04
		   d05 d06 d07 d08 d09 d10 d11 d12 d13 diffmtr_arb_h: diffmtr_arb_h_iv: diffvir_h1: diffvir_h1_IV: diffmtr_kap_h: diffMTR_kap_h_IV: broad taxable kapstatus dummycap dummyear logarb kink;
		   *ANLUJ: Denne skal ændres hvis vi vil estimere på kapitalindkomst;



data tax89_13 (Keep=&keep);
set bif.&datanavn.;
run;
/*ANLUJ: Dette step blev brugt til at merge timeløn og LOENMV på. I fremtiden skal vi nok kun merge timeløn på*/
data tax89_13; merge 
tax89_13 (/*drop=arb parb plogarb2 diffarb dlogarb2*/ where=(tiar >= 1987) in=a) 
/*div2.loenmv (keep=id_nr tiar arb parb plogarb2 diffarb dlogarb2)*/
div2.loentimer (keep=id_nr tiar loentimer andel_besk loentimer3 andel_besk3);
by tiar id_nr;
if a;
run;

proc sort data=tax89_13;
by id_nr tiar;
run;



/*
%macro over(start,slut);
%do i=&start %to &slut;

libname FT&i.   "D:\MB\Fuldtællinger\&i." access=readonly;

data overforsel&i (keep= id_nr overfor&i);
set ft&i..ind ;
Overfor&i=1;
if adagp in (.,0)
& ANDAKAS in (.,0)
& andbistandyd in (.,0)
& ANDOVERFORSEL in (.,0)
& arblhu in (.,0)
& arblhumv in (.,0)
& BARNEP in (.,0)
& bdagp in (.,0)
& DAGPENGE_KONTANT_13 in (.,0)
& delpens in (.,0)
& eftloen in (.,0)
& FLEXYD in (.,0)
& FOLKEFORTID_13 in (.,0)
& INTGRAYD in (.,0)
& KONTANTHJ_13 in (.,0)
& KONTHJ in (.,0)
& KONTSKFRI in (.,0)
& kont_gl in (.,0)
& LEDIGHEDSYDELSE in (.,0)
& offpens in (.,0)
& OFFPENS_EFTERLON_13 in (.,0)
& overforsindk in (.,0)
& OVERG in (.,0)
& OVRIG_DAGPENGE_AKAS_13 in (.,0)
& OVRIG_KONTANTHJALP_13 in (.,0)
& QARBLOS in (.,0)
& QBISTYD in (.,0)
& QBISTYD2 in (.,0)
& QEFTLON in (.,0)
& qmidyd in (.,0)
& qpensny in (.,0)
& qtilpens in (.,0)
& QUDDYDL in (.,0)
& REVAL in (.,0)
& stip in (.,0)
& UDD_YD in (.,0)
& VIRKSOMHEDS_PRAKTIK in (.,0)
then overfor&i=0;
run;

proc sort data=overforsel&i;
by id_nr;
run;
%end; 
%mend;
%over(1984,2016);


%macro over2(start,slut);
%do i=&start %to &slut;

%let i3=%eval(&i+3);

data over&i;
merge
overforsel&i (rename=(overfor&i=overfor0) in=a)
overforsel&i3 (rename=(overfor&i3=overfor3) in=b);
tiar=&i;
by id_nr;
if a;
if b=0 then overfor3=1;
run;
%end;
%mend over2;

%over2(1984,2013);

data div.overfor;
set over1984-over2013;
run;

proc sort data=div.overfor;
by id_nr tiar;
run;
*/

data bif.&datanavn._&indkomstbegreb.;
merge tax89_13 (in=a) div.overfor (keep= id_nr tiar overfor0 overfor3 in=b) div.overforandel (keep=id_nr tiar andel0 andel3 in=c);
by id_nr tiar;
if a;
if b=0 then overfor0=1;
if b=0 then overfor3=1;
if c=0 then andel0=1;
if c=0 then andel3=1;
run;



proc sort data=bif.&datanavn._&indkomstbegreb. nodupkey;
by id_nr tiar;
run;
proc export data=bif.&datanavn._&indkomstbegreb. file="Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater\&datanavn._&indkomstbegreb..dta" dbms=stata replace;
run;


