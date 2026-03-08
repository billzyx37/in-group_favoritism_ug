*****************************************************
* 2b_descriptives_rounds.do
* Goal:
*   - Create a single round-level descriptive table
*   - Rows: specific variables by round
*   - Two columns: CN vs CN  and  CN vs US
*   - Export to LaTeX
*
* Rows (in order):
*   Round 1 responder payoff
*   Round 1 latency
*   Round 2 acceptance
*   Round 2 latency
*   Round 3 responder payoff
*   Round 3 latency
*   Round 4 acceptance
*   Round 4 latency
*
* Data:
*   One round-level file: CN_Merged.dta
*   Key variables:
*     id                - participant ID
*     player_nation     - participant nationality (0 = CN, 1 = US)
*     opponent_nation   - opponent nationality (0 = CN, 1 = US)
*     round             - round number (1–4)
*     responderGain     - responder payoff
*     responderGain     - responder payoff / amount offered
*     outcome           - offer accepted (=1) / rejected (=0)
*     latency           - decision time in milliseconds
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
* 2. Keep only Chinese participants (if file mixes CN & US)
*    Comment out if CN_Merged.dta already contains only CN.
*----------------------------------------------------
* keep if player_nation == 0

*----------------------------------------------------
* 3. Construct round-specific variables
*    - For R1 & R3: responderGain + latency
*    - For R2 & R4: outcome + latency
*----------------------------------------------------

generate r1_respondergain = respondergain if round == 1
generate r1_latency      = latency      if round == 1

generate r2_accept       = outcome      if round == 2
generate r2_latency      = latency      if round == 2

generate r3_respondergain = respondergain if round == 3
generate r3_latency      = latency      if round == 3

generate r4_accept       = outcome      if round == 4
generate r4_latency      = latency      if round == 4

*----------------------------------------------------
* 4. Labels for round-specific variables
*    These become the row labels in the LaTeX table
*----------------------------------------------------
label variable r1_respondergain "Round 1 responder payoff"
label variable r1_latency      "Round 1 latency"

label variable r2_accept       "Round 2 acceptance (=1)"
label variable r2_latency      "Round 2 latency"

label variable r3_respondergain "Round 3 responder payoff"
label variable r3_latency      "Round 3 latency"

label variable r4_accept       "Round 4 acceptance (=1)"
label variable r4_latency      "Round 4 latency"

label variable opponent_nation "Opponent nationality (US = 1)"

* Order of rows in the table
local outcome_vars r1_respondergain r1_latency ///
                   r2_accept       r2_latency ///
                   r3_respondergain r3_latency ///
                   r4_accept       r4_latency

*----------------------------------------------------
* 5. Descriptive stats and LaTeX export (single table)
*----------------------------------------------------

eststo clear

* Column 1: CN vs CN (opponent_nation == 0)
estpost tabstat `outcome_vars' ///
    if opponent_nation == 0, ///
    stat(count mean sd) columns(stat)
eststo cncn

* Column 2: CN vs US (opponent_nation == 1)
estpost tabstat `outcome_vars' ///
    if opponent_nation == 1, ///
    stat(count mean sd) columns(stat)
eststo cnus

* Export to LaTeX (no booktabs)
esttab cncn cnus using "$tables/table_cn_rounds_outcomes.tex", ///
    replace tex ///
    cells("count(fmt(0)) mean(fmt(3)) sd(fmt(3)) min(fmt(0)) max(fmt(0))") ///
    collabels("N" "Mean" "SD") ///
    mlabels("CN vs CN" "CN vs US") ///
    nonumber noobs label ///
    title("Behavioral outcomes by round and opponent nationality (Chinese participants)")

di as result "Combined round-level descriptive table exported to: $tables/table_cn_rounds_outcomes.tex"
