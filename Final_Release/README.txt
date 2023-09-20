BIOMEDICAL SIGNAL PROCESSING LABORATORY − 2022/23
Detection of Atrial Fibrillation using Decision Tree Ensemble

Instructions:
This folder contains all the scripts produced for the development of the project. 

To run through all the steps required for data preparation, preliminary analysis, and feature extraction for a single recording you can use the script 'main.m'. It will only be necessary to set the right environment by defining the already present variable 'host_path' with the path of this folder.
To then define which parts of the code to run, set the flags at the beginning of the script:
- train_test_split = 1; % Performs the split of the CSV file to create training and test set.
- af_distribution_extraction= 1; % computes the cumulative distribution for a set of 9 AF patients, needed as standard for one of the features. When the splitting criteria will be met, and the distribution is created, the code will notify and the process stopped.
- filter_design_study = 1; % Performs the filter design study, comparing and visualizing different filter orders performances.
To actually test the preprocessing and feature extraction phase on a specific patient first set in the section 'Loading data' the 'SelectedPatient' variable to the patient id, then run the sections below. 

Conversely, to test the complete feature extraction loop you can use the script 'main_feature_extraction'.
Set the environment as before, and then define the extraction desired from the flags:
- extraction_train = 1; % to extract train set
- extraction_test = 1; % to extract test set
Then run the sections below.

In the folder 'Functions' you will find all the functions needed to preprocess the signals and extract the feature.
- 'generate_af_cumulative_distribution.m' = computes the standard cumulative distribution for AF patient, uses:
	- 'get_cumulative_distribution.m';
- 'preprocessing.m' = computes the preprocessing on the signal.
	- 'correct_if_inverted.m';
- 'pan_tompkin.m' = returns amplitudes and indexes of R peaks in the record.
- 'load_patient.m' = reads the WFDB record and returns all the information.
- 'feature_extraction.m' = computes all the extractions, using the following functions:
	- 'get_AF_features', that uses:
		- 'get_cumulative_distribution_from_signal.m';
		- 'get_AFEV_metrics.m';
	- 'get_morphological_features.m', that uses:
		- 'get_fiducial_point.m';
		- 'find_first_rise.m';
	- 'get_rr_features.m';
	- 'get_similarity_features.m', that uses:
		- 'get_fiducial_point.m';
		- 'get_beat_similarity.m';






