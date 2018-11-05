// Simulate SP

cap program drop sim_sp
program define sim_sp , rclass

	syntax , [sps(integer 25)] [provs(integer 100)] [interactions(string asis)] [ratio(real 1)] [reps(integer 100)]

	// Main loop
	cap mat drop results
	qui forvalues i = 1/`reps' {

		// Generate SP roster
		clear
			set obs `sps'
			gen sp_id = _n
			gen sp_fe = rnormal()
			gen rand = rnormal()
				xtile sp_male = rand , n(2)
				replace sp_male = 2 - sp_male
				drop rand

			tempfile sp
				save `sp'

		// Provider schedule
		clear
			set obs `provs'
			gen clin_fe = rnormal() * `ratio'

		// More interactions if specified
		if "`interactions'" != "" {
			expand `interactions'
		}

		// Assign SPs
		gen sp_id = 1 + mod(_n,`sps')
			merge m:1 sp_id using `sp' , nogen

		// Interaction outcome
		gen Y = rnormal() + .1 * sp_male + clin_fe + sp_fe
			reg Y sp_male , cl(sp_id)
			mat results = nullmat(results) ///
				\ [_b[sp_male] , _se[sp_male], 1]
			reg Y sp_male
			mat results = nullmat(results) ///
				\ [_b[sp_male] , _se[sp_male], 0]
	}

	return matrix results = results

end

// Loop over it

	clear
	tempfile a
	save `a' , emptyok

	cap mat drop results
	qui forvalues sps = 4(2)24 {
		qui forvalues provs = 200(200)2000 {

		sim_sp , provs(`provs') sps(`sps') reps(100)
			mat a = r(results)
			clear
			svmat a
			gen sps = `sps'
			gen provs = `provs'
			collapse (sd) a1 (mean) a2, by(sps provs a3)
			append using `a'
			save `a' , replace
		}
	}

	// Clean

		rename (a1 a2 a3) (sd_actual se_asymp cluster)
		label var sd_actual " "
		label var se_asymp  " "

	// Contours

		tw contour sd_actual sps provs if cluster == 0 ///
		,  ${graph_opts} ccuts(.3(.1)1) title("True {&beta} errors") xtit("Facilities") ytit("Individual SPs")
			graph save "a.gph" , replace
		tw contour se_asymp  sps provs if cluster == 0 ///
		,  ${graph_opts} title("Asymptotic {&beta} SEs") xtit("Facilities") ytit("Individual SPs")
			graph save "b.gph" , replace
		tw contour se_asymp  sps provs if cluster == 1 ///
		,  ${graph_opts} ccuts(.3(.1)1) title("Asymptotic clustered {&beta} SEs") xtit("Facilities") ytit("Individual SPs")
			graph save "c.gph" , replace

		tw ///
		 	(lpoly sd_actual sps if cluster == 0 , lw(thick) degree(1)) ///
			(lpoly se_asymp  sps if cluster == 0 , lw(thick) degree(1)) ///
			(lpoly se_asymp  sps if cluster == 1 , lw(thick) degree(1)) ///
		, ${graph_opts} ytit("") xtit("SPs") legend(r(1) order(1 "True" 2 "Asymptotic" 3 "Clustered")) ylab(0(.25)1)
			graph save "d.gph" , replace

		graph combine a.gph c.gph b.gph d.gph, ${comb_opts}
			graph export "/users/bbdaniels/desktop/sp-clusters.png" , replace

		!rm a.gph
		!rm b.gph
		!rm c.gph
		!rm d.gph

// Have a lovely day!
