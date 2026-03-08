*****************************************************
* 4_baseline_reg.do
* Goal:
*   - Estimate baseline treatment effects for Chinese sample:
*         y = β * opponent_nation
*   - Four outcomes:
*       Round 1: respondergain
*       Round 2: outcome (LPM)
*       Round 3: respondergain
*       Round 4: outcome (LPM)
*   - For each outcome:
*       (1) Baseline (no controls)
*       (2) Baseline + controls
*   - Export a single LaTeX table via esttab
*
* Data:
*   $clean/CN_Merged.dta  (round-level)
*   Key variables:
*     id                - participant ID (for clustering)
*     player_nation     - 0 = CN, 1 = US
*     opponent_nation   - 0 = CN, 1 = US
*     round             - 1–4
*     respondergain     - proposer gain in offer rounds (1 & 3)
*     outcome           - 1 = accepted, 0 = rejected (rounds 2 & 4)
*****************************************************

clear

*capture confirm global root
*if _rc {
*    di as error "Global ROOT is not defined. Run master.do, not this file directly."
*    exit 198
*}

*----------------------------------------------------
* 1. Load data
*----------------------------------------------------
use "$clean/CN_Merged.dta", clear

*----------------------------------------------------
* 2. Define treatment and controls
*----------------------------------------------------

* Since sample is only Chinese participants:
*   treatment = opponent nationality only
global treat "i.opponent_nation"

* Controls
global controls "age gender ethniticy_cn birth_region_cn num_siblings study_abroad_exp religion_importance"


*****************************************************
* 3. Baseline regressions by round
*****************************************************

est clear

*------------------------
* Round 1: respondergain
*------------------------
reg respondergain $treat if round == 1, vce(cluster id)
est store r1_base

reg respondergain $treat $controls if round == 1, vce(cluster id)
est store r1_ctrl

*------------------------
* Round 2: outcome (LPM)
*------------------------
reg outcome $treat if round == 2, vce(cluster id)
est store r2_base

reg outcome $treat $controls if round == 2, vce(cluster id)
est store r2_ctrl

*------------------------
* Round 3: respondergain
*------------------------
reg respondergain $treat if round == 3, vce(cluster id)
est store r3_base

reg respondergain $treat $controls if round == 3, vce(cluster id)
est store r3_ctrl

*------------------------
* Round 4: outcome (LPM)
*------------------------
reg outcome $treat if round == 4, vce(cluster id)
est store r4_base

reg outcome $treat $controls if round == 4, vce(cluster id)
est store r4_ctrl

*****************************************************
* 5. Export LaTeX table (4 outcomes × 2 specs)
*****************************************************

esttab r1_base r1_ctrl r2_base r2_ctrl r3_base r3_ctrl r4_base r4_ctrl ///
    using "$tables/4_baseline_reg.tex", replace                      ///
    se star(* 0.10 ** 0.05 *** 0.01)                                ///
    b(%9.3f) se(%9.3f)                                               ///
    label booktabs                                                   ///
    title("Effect of Opponent Nationality on Offers and Acceptance") ///
    mgroups("R1" "R2" "R3" "R4",                                    ///
        pattern(1 0 1 0 1 0 1 0) span                              ///
        prefix("\multicolumn{@span}{c}{")                          ///
        suffix("}"))                                               ///
    mtitles("Baseline" "+Controls" "Baseline" "+Controls"          ///
            "Baseline" "+Controls" "Baseline" "+Controls")         ///

di as result "Baseline regression table exported to $tables/4_baseline_reg.tex"
