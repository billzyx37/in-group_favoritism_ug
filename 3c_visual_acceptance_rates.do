*****************************************************
* 3c_visual_acceptance_rates.do
* Goal:
*   - Visualize mean acceptance rates (outcome)
*   - One grouped bar chart:
*       x-axis groups: CN–CN, CN–US
*       within each group: Round 2 and Round 4 bars
*
* Data:
*   CN_Merged.dta (round-level)
*   Key variables:
*     player_nation   - 0 = CN, 1 = US
*     opponent_nation - 0 = CN, 1 = US
*     round           - round index (1–4)
*     outcome         - acceptance dummy (1 = accept, 0 = reject)
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

* Keep only responder rounds (assuming 2 and 4)
keep if inlist(round, 2, 4)

*----------------------------------------------------
* 2. Labels for clarity
*----------------------------------------------------
label define opp_lbl 0 "CN–CN" 1 "CN–US"
label values opponent_nation opp_lbl

label define rnd_lbl 2 "Round 2" 4 "Round 4"
label values round rnd_lbl

label variable outcome "Acceptance (1 = accept)"

*----------------------------------------------------
* 3. Grouped bar chart:
*    - x-axis groups: opponent_nation (CN–CN, CN–US)
*    - bars within group: round (Round 2, Round 4)
*    - bar height: mean of outcome = acceptance rate
*----------------------------------------------------
graph bar (mean) outcome, ///
    over(round) ///
    over(opponent_nation) ///
    ytitle("Acceptance rate") ///
    ylabel(0(.2)1) ///
    title("Acceptance rates by treatment and round") ///
    legend(order(1 "Round 2" 2 "Round 4"))

* Save figure (adjust path/format as needed)
graph export "$figures/acceptance_rates_grouped_round2_4.png", replace

di as result "Grouped acceptance-rate figure exported to $figures/acceptance_rates_grouped_round2_4.*"
