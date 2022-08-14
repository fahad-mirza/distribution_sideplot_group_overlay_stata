	clear all
	
	* Necessary Package Installations (One time only)
	* net install grc1leg, from("http://www.stata.com/users/vwiggins") replace
	* ssc install schemepack, replace
	* ssc install palettes, replace
	* ssc install colrspace, replace
	
	* Loading the example dataset from GitHub
	import delimited "https://raw.githubusercontent.com/tidyverse/ggplot2/master/data-raw/mpg.csv", clear

	* Using loop to write and store the plotting commands and syntax by class
	levelsof class, local(classes)
	foreach class of local classes {
	
		local sctr `sctr' scatter cty hwy if class == "`class'", mcolor(%60) mlwidth(0) ||
		
		quietly summarize cty if class == "`class'"
		local cty `cty' function normalden(x, `r(mean)', `r(sd)') , horizontal range(cty) base(0) n(500) xlabel(, nogrid) recast(area) fcolor(%50) lwidth(0) ||
		
		quietly summarize hwy if class == "`class'"
		local hwy `hwy' function normalden(x, `r(mean)', `r(sd)') , range(hwy) base(0) n(500) ylabel(, nogrid) recast(area) fcolor(%50) lwidth(0) ||	
	}
	
	* Plotting each of the above saved commands and storing them for combining later using name()
	twoway `sctr' || lowess cty hwy ||, legend(off) name(lowess) ytitle("City MPG") xtitle("Highway MPG") ysc(r(10(5)35)) xsc(r(10(10)40)) xlabel(, nogrid) ylabel(, nogrid)
	twoway `cty', graphregion(margin(b=0)) name(cty) leg(off) fxsize(25) ytitle("") ylabel(none) xtitle("⠀") ysc(r(10(5)35))
	twoway `hwy', graphregion(margin(b=0)) name(hwy) leg(label(1 "2 Seater") label(2 "Compact") label(3 "Mid-Size") label(4 "Minivan") label(5 "Pickup") label(6 "Sub-Compact") label(7 "SUV") size(2) row(2) col(4)) fysize(25) xtitle("") xla(none) ytitle("⠀") xsc(r(10(10)50))
	
	* Combining all the plots saved above
	grc1leg hwy lowess cty, title("{bf}Fuel Economy by Vehicle Type", color(navy) size(3) j(left) pos(11) margin(l=6)) subtitle("Side plots for density", size(2) pos(11) margin(l=6)) legendfrom(hwy) span hole(2) rows(3) imargin(zero) commonscheme scheme(white_tableau)
	
	* Exporting the visual 
	graph export "~/Desktop/Sideplots_Distribution_by_Group_Stata.png", as(png) name("Graph") width(1920) replace
