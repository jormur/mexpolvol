//111266012 Jordan A. Murillo
//Causal Inference Term Project

use "/Users/jordan/Documents/uni/Year 1/Semester 2/Causal Inference/term project/final/merged_dataset.dta"

//summary stats
tabstat mpoff1000, stats(n mean median  min max) by(aggr_dummy)
tabstat cvmr1000, stats(n mean median  min max) by(aggr_dummy)


twoway kdensity mpoff1000 if aggr_dummy==1, xtitle("Public Prosecutors per Capita") ytitle(Density) ///
color(blue*.5) lcolor(blue)  lwidth(medthick) || ///
kdensity mpoff1000 if aggr_dummy==0, color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Violence Exposed" 2 "Non-Violence Exposed") col(1) pos(1) ring(0))

twoway kdensity cvmr1000 if aggr_dummy==1, xtitle("Drug-murders per Capita") ytitle(Density) ///
color(blue*.5) lcolor(blue)  lwidth(medthick) || ///
kdensity cvmr1000 if aggr_dummy==0, color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Violence Exposed" 2 "Non-Violence Exposed") col(1) pos(1) ring(0))

twoway kdensity aggr_sum if alternancia_mun==1, xtitle("Political Violence Incidents") ytitle(Density) ///
color(blue*.5) lcolor(blue)  lwidth(medthick) || ///
kdensity aggr_sum if alternancia_mun==0, color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Party Change" 2 "No Change") col(1) pos(1) ring(0))

twoway kdensity cvmr1000 if alternancia_mun==1, xtitle("Drug-murders per Capita") ytitle(Density) ///
color(blue*.5) lcolor(blue)  lwidth(medthick) || ///
kdensity cvmr1000 if alternancia_mun==0, color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Party Change" 2 "No Change") col(1) pos(1) ring(0))


estpost summarize alternancia_mun aggr_sum cvmr1000 enp_mun enp_st elect_fed alternancia_st perc_tax mpoff1000

//esttab, cells("mean(fmt(2)) sd(fmt(2))") nonum

// Save the table as a LaTeX file
esttab using summary_stats.tex, replace ////
 cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) ") nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Mean" "SD")


//model

//dropping of non-election years
drop if elect_local==0

reg alternancia_mun aggr_sum enp_mun perc_tax mpoff1000 cvmr1000

// Panel data regression of electoral violence on party change
xtset cve_inegi year
xtreg alternancia_mun aggr_sum cvmr1000 enp_mun enp_st elect_fed alternancia_st perc_tax mpoff1000 total_pop, fe robust

est clear

eststo: xtreg alternancia_mun aggr_sum cvmr1000 enp_mun enp_st elect_fed alternancia_st perc_tax mpoff1000, fe robust

esttab using "fixed_effects_results.tex", replace   ///
 b(3) se(3) ///
 keep($controls) ///
 star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs noobs nonotes nomtitle collabels(none) compress alignment(D{.}{.}{-1})
