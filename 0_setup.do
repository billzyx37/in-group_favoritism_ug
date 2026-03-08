*****************************************************
* 0_setup.do  - Global settings & utilities
* Project: Econ Honors Thesis Experiment
*****************************************************

*-----------------------------
* 1. Basic Stata preferences
*-----------------------------
version 18.0
set more off
set linesize 120
set maxvar 10000
set scheme s1color

*-----------------------------
* 2. Confirm key globals exist
*-----------------------------
*capture confirm global root
*if _rc {
*    di as error "Global ROOT is not defined. Run master.do, not this file directly."
*    exit 198
*}

* (Optional: show them)
di as text "Project root:  $root"
di as text "Raw data:      $raw"
di as text "Clean data:    $clean"
di as text "Do-files:      $dofiles"
di as text "Logs:          $logs"
di as text "Output:        $output"

*-----------------------------
* 3. Install / check user packages
*-----------------------------
capture which esttab
if _rc ssc install estout

capture which outreg2
if _rc ssc install outreg2

*-----------------------------
* 4. Project-wide labels (optional)
*-----------------------------
capture label drop natl
label define natl 0 "US" 1 "China"

*-----------------------------
* 5. Seed for reproducibility
*-----------------------------
set seed 123456

*-----------------------------
* 6. Done
*-----------------------------
di as result "0_setup.do completed."
