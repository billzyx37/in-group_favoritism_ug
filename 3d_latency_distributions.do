*****************************************************
* 3d_visual_latency.do
* Goal:
*   - Visualize reaction time (latency) patterns
*   - 8-panel histogram of latency distributions
*       Layout: 4 (rounds) x 2 (treatments)
*       For each round (1–4), compare:
*         - CN–CN vs CN–US
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
* 3. Latency Distributions (8-panel histogram)
*   - For each round (1–4), plot:
*       - CN–CN
*       - CN–US
*   - Combined as 4x2 grid:
*       Row = round, Column = treatment
*****************************************************

preserve

* Keep only the four game rounds and non-missing latency
keep if inlist(round, 1, 2, 3, 4)
keep if !missing(latency)
keep if inlist(opponent_nation, 0, 1)

* Common histogram options: fractions, fixed y-range, nice labels
local histopts ///
    bin(20) ///
    fraction ///
    yscale(range(0 0.4)) ///
    ylabel(0(0.1)0.4, format(%3.1f)) ///
    xtitle("Latency (ms)") ///
    ytitle("Fraction of observations")

*------------------------------
* Round 1: CN–CN vs CN–US
*------------------------------
twoway histogram latency if round == 1 & opponent_nation == 0, ///
    `histopts' ///
    title("Round 1 - CN–CN") ///
    name(lat_r1_cnc, replace)

twoway histogram latency if round == 1 & opponent_nation == 1, ///
    `histopts' ///
    title("Round 1 - CN–US") ///
    name(lat_r1_cnus, replace)

*------------------------------
* Round 2: CN–CN vs CN–US
*------------------------------
twoway histogram latency if round == 2 & opponent_nation == 0, ///
    `histopts' ///
    title("Round 2 - CN–CN") ///
    name(lat_r2_cnc, replace)

twoway histogram latency if round == 2 & opponent_nation == 1, ///
    `histopts' ///
    title("Round 2 - CN–US") ///
    name(lat_r2_cnus, replace)

*------------------------------
* Round 3: CN–CN vs CN–US
*------------------------------
twoway histogram latency if round == 3 & opponent_nation == 0, ///
    `histopts' ///
    title("Round 3 - CN–CN") ///
    name(lat_r3_cnc, replace)

twoway histogram latency if round == 3 & opponent_nation == 1, ///
    `histopts' ///
    title("Round 3 - CN–US") ///
    name(lat_r3_cnus, replace)

*------------------------------
* Round 4: CN–CN vs CN–US
*------------------------------
twoway histogram latency if round == 4 & opponent_nation == 0, ///
    `histopts' ///
    title("Round 4 - CN–CN") ///
    name(lat_r4_cnc, replace)

twoway histogram latency if round == 4 & opponent_nation == 1, ///
    `histopts' ///
    title("Round 4 - CN–US") ///
    name(lat_r4_cnus, replace)

*------------------------------
* Combine: 4 rows (rounds) x 2 columns (treatment)
*------------------------------
graph combine ///
    lat_r1_cnc lat_r1_cnus ///
    lat_r2_cnc lat_r2_cnus ///
    lat_r3_cnc lat_r3_cnus ///
    lat_r4_cnc lat_r4_cnus, ///
    rows(4) cols(2) ///
    ycommon ///
    title("Latency distributions by round and treatment") ///
    xsize(8) ysize(12)


* Save figure (adjust path/format as needed)
graph export "$figures/latency_distributions_round_treatment_4x2.png", ///
    width(3000) replace
	
restore
di as result "Latency distribution figure (4x2: round x treatment) exported to $figures/latency_distributions_round_treatment_4x2.*"

