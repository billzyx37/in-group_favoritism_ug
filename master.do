*****************************************************
* master.do  - Honors Thesis: Experiment Pipeline
*****************************************************

version 18.0
clear all
set more off

*----------------------------------------------------
* 1. Set project root
*----------------------------------------------------
global root "/Users/bill_zyx/Desktop/Econ Thesis/STATA"

cd "$root"

*----------------------------------------------------
* 2. Define subfolder globals
*----------------------------------------------------
global raw     "$root/01_raw"
global clean   "$root/02_clean"
global dofiles "$root/03_do"
global logs    "$root/04_logs"
global output  "$root/05_output"
global tables  "$root/05_output/tables"
global figures "$root/05_output/figures"

capture mkdir "$raw"
capture mkdir "$clean"
capture mkdir "$dofiles"
capture mkdir "$logs"
capture mkdir "$output"
capture mkdir "$tables"
capture mkdir "$figs"

*----------------------------------------------------
* 3. Start project log
*----------------------------------------------------
log using "$logs/master_`c(current_date)'.smcl", replace

* (Optional debug line to reassure us root is set)
di as result "DEBUG: root is '$root'"

*----------------------------------------------------
* 4. Run all project do-files
*----------------------------------------------------
do "$dofiles/0_setup.do"
do "$dofiles/1_clean_experiment.do"
do "$dofiles/2a_descriptives_demographic.do"
do "$dofiles/2b_descriptives_experiment.do"
do "$dofiles/3a_visual_offer_distribution.do"
do "$dofiles/3b_visual_offer_means.do"
do "$dofiles/3c_visual_acceptance_rates.do"
do "$dofiles/3d_latency_distributions.do"
do "$dofiles/3e_visual_latency_means.do"
do "$dofiles/4_baseline_reg.do"

*----------------------------------------------------
* 5. Close log and finish
*----------------------------------------------------
log close
display as text "Master do-file completed successfully."
