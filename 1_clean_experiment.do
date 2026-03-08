*****************************************************
* 1_clean_experiment.do
* Light version: Python already did the cleaning
* Role:
*   - Load cleaned datasets from Python
*   - Put them in 02_clean/ with standardized names
*****************************************************

clear

*capture confirm global root
*if _rc {
*    di as error "Global ROOT is not defined. Run master.do, not this file directly."
*    exit 198
*}

* Import Python-cleaned CSV
import delimited "$clean/CN_Merged.csv", clear varnames(1)

* Make variable names lower case for consistency
rename *, lower

* Save as Stata .dta for future use
compress
save "$clean/CN_Merged.dta", replace

di as result "1_clean_experiment.do completed: CSV → CN_Merged.dta"
