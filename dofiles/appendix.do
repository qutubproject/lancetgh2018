
* Table A1

	use  "${directory}/data/analysis.dta" , clear

	weightab ///
		correct treat_refer dr_1 re_1 re_3 re_4 med_any med_l_any_1 med_l_any_2 med_l_any_3 med_k_any_9 ///
	using "${directory}/appendix/Table_A1.xlsx" ///
		[pweight=weight_city] ///
	, replace over(sp_gender_group) stats(b se ll ul)

* Table A2

	use  "${directory}/data/analysis.dta" , clear

	rctreg ///
	ce_1 ce_2 ce_3 ce_4 ce_5 ce_6 ce_7 ///
	sp1_h_1 sp1_h_2 sp1_h_3 sp1_h_4 sp1_h_5 sp1_h_6 sp1_h_7 sp1_h_8 sp1_h_9 sp1_h_10 ///
		sp1_h_11 sp1_h_12 sp1_h_13 sp1_h_14 sp1_h_15 sp1_h_16 sp1_h_17 sp1_h_18 sp1_h_19 ///
		sp1_h_20 sp1_h_21 ///
	sp2_h_1 sp2_h_2 sp2_h_3 sp2_h_4 sp2_h_5 sp2_h_6 sp2_h_7 sp2_h_8 sp2_h_9 sp2_h_10 ///
		sp2_h_11 sp2_h_12 sp2_h_13 sp2_h_14 sp2_h_15 sp2_h_16 sp2_h_17 sp2_h_18 sp2_h_19 ///
		sp2_h_20 sp2_h_21 sp2_h_22 sp2_h_23 sp2_h_24 sp2_h_25 sp2_h_26 sp2_h_27 sp2_h_28 ///
	sp3_h_1 sp3_h_2 sp3_h_3 sp3_h_4 sp3_h_5 sp3_h_6 sp3_h_7 sp3_h_8 sp3_h_9 sp3_h_10 ///
		sp3_h_11 sp3_h_12 sp3_h_13 sp3_h_14 sp3_h_15 sp3_h_16 sp3_h_17 sp3_h_18 sp3_h_19 ///
		sp3_h_20 sp3_h_21 sp3_h_22 sp3_h_23 ///
	sp4_h_1 sp4_h_2 sp4_h_3 sp4_h_4 sp4_h_5 sp4_h_6 sp4_h_7 sp4_h_8 sp4_h_9 sp4_h_10 ///
		sp4_h_11 sp4_h_12 sp4_h_13 sp4_h_14 sp4_h_15 sp4_h_16 sp4_h_17 sp4_h_18 sp4_h_19 ///
		sp4_h_20 sp4_h_21 sp4_h_22 sp4_h_23 sp4_h_24 sp4_h_25 sp4_h_26 sp4_h_27 sp4_h_28 ///
		sp4_h_29 sp4_h_30 sp4_h_31 ///
	using "${directory}/appendix/Table_A2.xlsx" [pweight=weight_city] ///
	,  treatment(sp_male) controls(city_? case_? cp_5) title("History Questions") cl(facilitycode)

* Have a lovely day!
