
	clear
	*set matsize 11000

	*Valg af datasæt;
	cd "Y:\Projekt\OIM\MORA\Genestimation\Data\Estimationsresultater" 
	use DiD_estimationsdata
	
	*sti til output;
	cd "Y:\Projekt\OIM\MORA\Genestimation\Output"
	global output_1st output.tex
	
	
	
	
	gen time= (aar>=1987)
	gen did = time*treatment
	gen llon=log(lon)
	
	
	eststo clear
	eststo: qui reg llon did time treatment, beta
	
	
	esttab using ${output_1st}, label ///
	 title(Regression table\label{tab1})
	 
	
	
	