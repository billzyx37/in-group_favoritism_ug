*****************************************************
* 3a_visual_offer_distributions.do
* Goal:
*   - Visualize offer distributions (respondergain)
*   - Four panels in one figure:
*       1) CN–CN, Round 1
*       2) CN–US, Round 1
*       3) CN–CN, Round 3
*       4) CN–US, Round 3
*
* Data:
*   CN_Merged.dta (round-level)
*   Key variables:
*     player_nation   - 0 = CN, 1 = US
*     opponent_nation - 0 = CN, 1 = US
*     round           - round index (1–4)
*     respondergain   - responder payoff / offer (0–100 scale)
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

* Drop missing offer values
keep if !missing(respondergain)

*----------------------------------------------------
* 2. Common histogram options
*    - x-axis standardized to 0–100 with 20-pt ticks
*----------------------------------------------------
local histopts ///
    percent ///
	width(5) start(0) ///
    xscale(range(0 40)) ///
    xlabel(0(10)40) ///
	yscale(range(0 80)) ///
	ylabel(0(20)80) ///
    xtitle("Offer (responder gain, 0–100)") ///
    ytitle("Percent")

*----------------------------------------------------
* 3. Offer distribution histograms by treatment & round
*----------------------------------------------------

* CN–CN, Round 1
histogram respondergain if opponent_nation == 0 & round == 1, ///
    `histopts' ///
    title("CN–CN, Round 1") ///
    name(g_cnc_r1, replace)

* CN–US, Round 1
histogram respondergain if opponent_nation == 1 & round == 1, ///
    `histopts' ///
    title("CN–US, Round 1") ///
    name(g_cnus_r1, replace)

* CN–CN, Round 3
histogram respondergain if opponent_nation == 0 & round == 3, ///
    `histopts' ///
    title("CN–CN, Round 3") ///
    name(g_cnc_r3, replace)

* CN–US, Round 3
histogram respondergain if opponent_nation == 1 & round == 3, ///
    `histopts' ///
    title("CN–US, Round 3") ///
    name(g_cnus_r3, replace)

*----------------------------------------------------
* 4. Combine into a 4-panel figure
*----------------------------------------------------
graph combine g_cnc_r1 g_cnus_r1 g_cnc_r3 g_cnus_r3, ///
    col(2) row(2) ///
    imargin(small) ///
    title("Offer distributions (responder gain) by treatment and round")

* Save figure (adjust path/format as needed)
graph export "$figures/offer_distributions_respondergain_4panel.png", replace
* graph export "$figures/offer_distributions_respondergain_4panel.pdf", replace

di as result "Four-panel offer distribution figure (respondergain) exported to $figures/offer_distributions_respondergain_4panel.*"
