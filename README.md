# Cultural Influences on In-Group Favoritism

## Project Overview
This repository contains the replication code for my senior honors thesis in Economics. The study utilizes an Ultimatum Game experiment involving Chinese and American participants to investigate the causal impact of cultural identity on economic decision-making and in-group favoritism. The do files here are not at the final stage: they show some preliminary visualization and analysis, as shown in my writing sample. 


## Repository Structure
The analysis is modularized to ensure clarity and ease of replication. The scripts should be executed in the following order:

* `master.do`: The central script that sets global file paths and runs the entire pipeline in sequence.
* `0_setup.do`: Installs necessary Stata packages and defines the research environment.
* `1_clean_experiment.do`: Performs data management, including variable standardization and merging experimental results with survey data.
* `2a_descrip_demographic.do` & `2b_descrip_experiment.do`: Generates summary statistics for survey and experiment data.
* `3a_visual_offer_distribution.do` through `3e_visual_latency_means.do`: Produces all visualizations.
* `4_baseline_reg.do`: Executes a preliminary regression analysis.

## Data Privacy Note
In compliance with IRB procedures, the raw participant data is not included in this public repository. However, the provided scripts demonstrate the full logic of the data cleaning and analysis process.
