BIOMEDICAL SIGNAL PROCESSING LABORATORY − 2022/23
Detection of Atrial Fibrillation using Decision Tree Ensemble

Authors: 
- Chiara Boscarino - 10648163 
- Filippo Castellani - 10784227 
- Antonella Lombardi - 10618195

Instructions:
This folder contains all the scripts produced for the development of the project. 

To run through all the steps required for data preparation, preliminary anlysis and feature extraction for a single recording you can use the script 'main.m'. It will only be necessary to set the right environment by defining the already present variable 'host_path' with the path of this folder.
To then define which parts of the code to run, set the flags at the beginning of the script:
- train_test_split = 1; % Performs the split of the csv file to create training and test set.
- af_distribution_extraction= 1; % computes the cumulative distribution for a set of 10 AF patients, needed as standard for one of the feature.
- filter_design_study = 1; % Performs the filter design study, comparing and visualizing different filter orders performances.
To actually test the preprocessing and feature extraction phase on a specific patient first set in the section 'Loading data' the 'SelectedPatient' variable to the patient id, then run sections below. 

Conversely, to test the complete feature extraction loop you can use the script 'main_feature_extraction





