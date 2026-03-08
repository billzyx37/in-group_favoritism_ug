*****************************************************
* 2a_descriptives_demographic.do
* Goal:
*   - Create a participant-level demographic table
*   - Two columns: CN vs CN  and  CN vs US
*   - Export to LaTeX (booktabs)
*
* Data:
*   One round-level file: CN_Merged.dta
*   Variables (from Python):
*     id                - participant ID
*     player_nation     - participant nationality (0 = CN, 1 = US)
*     opponent_nation   - opponent nationality (0 = CN, 1 = US)
*     age               - age
*     gender            - 0/1 (we'll treat 1 = female)
*     ethniticy_cn      - dummy: ethnically Chinese
*     birth_region_cn   - region in China (coded numeric)
*     religion_importance
*     num_siblings
*     study_abroad_exp
*     major             - string, not used in tabstat
*****************************************************

clear

*capture confirm global root
*if _rc {
*    di as error "Global ROOT is not defined. Run master.do, not this file directly."
*    exit 198
*}

*----------------------------------------------------
* 1. Load merged dataset (round-level)
*----------------------------------------------------
use "$clean/CN_Merged.dta", clear

*----------------------------------------------------
* 2. Collapse to participant level
*    One row per id, demographics taken from first round
*----------------------------------------------------
collapse (first) age gender ethniticy_cn birth_region_cn ///
        religion_importance num_siblings study_abroad_exp ///
        (first) opponent_nation, by(id)

*----------------------------------------------------
* 3. Variable labels & convenient recodes
*----------------------------------------------------
label variable age                 "Age"
label variable gender              "Male"
label variable ethniticy_cn        "Majority ethnicity"
label variable birth_region_cn     "Urban"
label variable religion_importance "Religion important"
label variable num_siblings        "Number of siblings"
label variable study_abroad_exp    "Study abroad experience (=1)"
label variable opponent_nation     "Opponent nationality (US = 1)"

*----------------------------------------------------
* 5. Descriptive stats and LaTeX export
*----------------------------------------------------

eststo clear

* Column 1: CN vs CN (opponent_nation == 0)
estpost tabstat age gender ethniticy_cn birth_region_cn ///
        religion_importance num_siblings study_abroad_exp ///
        if opponent_nation == 0, ///
        stat(count mean sd) columns(stat)
eststo cncn

* Column 2: CN vs US (opponent_nation == 1)
estpost tabstat age gender ethniticy_cn birth_region_cn ///
        religion_importance num_siblings study_abroad_exp ///
        if opponent_nation == 1, ///
        stat(count mean sd) columns(stat)
eststo cnus

* Export to LaTeX
esttab cncn cnus using "$tables/table_cn_demographics.tex", ///
    replace tex ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3))") ///
    collabels("N" "Mean" "SD") ///
    mlabels("CN vs CN" "CN vs US") ///
    nonumber noobs label ///
    title("Demographic characteristics by opponent nationality (Chinese participants)")

di as result "Descriptive table exported to: $tables/demographics_CN_CN_vs_CN_US.tex"
