*****************************************************
* 3e_visual_latency_means.do
* Goal:
*   - Visualize mean reaction time (latency)
*   - One grouped bar chart:
*       x-axis groups: CN–CN, CN–US
*       within each group: four bars (Rounds 1–4)
*
* Data:
*   CN_Merged.dta (round-level)
*   Key variables:
*     player_nation   - 0 = CN, 1 = US
*     opponent_nation - 0 = CN, 1 = US
*     round           - round index (1–4)
*     latency         - reaction time (e.g., milliseconds)
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

* Keep only Chinese participants if dataset mixes CN & US
* (comment out if CN_Merged already contains only CN)
* keep if player_nation == 0

*----------------------------------------------------
* 2. Labels for clarity
*----------------------------------------------------
label define opp_lbl 0 "CN–CN" 1 "CN–US", replace
label values opponent_nation opp_lbl

label define rnd_lbl 1 "Round 1" 2 "Round 2" 3 "Round 3" 4 "Round 4", replace
label values round rnd_lbl

label variable latency "Latency (ms)"

*****************************************************
* 3. Mean latency comparison:
*    - One grouped bar chart
*    - x-axis: opponent_nation (CN–CN, CN–US)
*    - bars within group: rounds 1–4
*****************************************************

preserve

* Keep only relevant rounds, treatments, and non-missing latency
keep if inlist(round, 1, 2, 3, 4)
keep if inlist(opponent_nation, 0, 1)
keep if !missing(latency)

graph bar (mean) latency, ///
    over(round) ///
    over(opponent_nation) ///
    ytitle("Mean latency (ms)") ///
    title("Mean latency by treatment and round") ///
    legend(order(1 "Round 1" 2 "Round 2" 3 "Round 3" 4 "Round 4"))

* Save figure (adjust path/format as needed)
graph export "$figures/latency_means_rounds1_4_by_treatment.png", replace

restore

di as result "Mean-latency figure (Rounds 1–4 by treatment) exported to $figures/latency_means_rounds1_4_by_treatment.*"
