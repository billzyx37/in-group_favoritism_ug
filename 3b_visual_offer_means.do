*****************************************************
* 3b_visual_offer_means.do
* Goal:
*   - Visualize mean offers (proposergain) as bars
*   - One grouped bar chart:
*       x-axis groups: CN–CN, CN–US
*       within each group: Round 1 and Round 3 bars side by side
*
* Data:
*   CN_Merged.dta (round-level)
*   Key variables:
*     player_nation   - 0 = CN, 1 = US
*     opponent_nation - 0 = CN, 1 = US
*     round           - round index (1–4)
*     proposergain    - proposer payoff / offer
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

* Keep only proposer rounds (assuming 1 and 3)
keep if inlist(round, 1, 3)

*----------------------------------------------------
* 2. Labels for clarity
*----------------------------------------------------
label define opp_lbl 0 "CN–CN" 1 "CN–US"
label values opponent_nation opp_lbl

label define rnd_lbl 1 "Round 1" 3 "Round 3"
label values round rnd_lbl

label variable respondergain "Offer (responder gain)"

*----------------------------------------------------
* 3. Grouped bar chart:
*    - x-axis groups: opponent_nation (CN–CN, CN–US)
*    - bars within group: round (Round 1, Round 3)
*----------------------------------------------------
graph bar (mean) respondergain, ///
    over(round) ///
    over(opponent_nation) ///
    ytitle("Mean offer (responder gain)") ///
    title("Mean offers by treatment and round") ///
    legend(order(1 "Round 1" 2 "Round 3"))

graph export "$figures/offer_means_grouped_round1_3.png", replace

di as result "Grouped mean-offer figure exported to $figures/offer_means_grouped_round1_3.*"
