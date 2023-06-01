%% Pre-ops

% Clearing previous data and closing all the windows if any
clc; close all; clear;

% Setting the environment
[PROJECT_DIRECTORY, DatasetFolderPath,DatasetFolderPrefix] = set_environment();

%% Extract test filenames 

reference_filepath = [PROJECT_DIRECTORY '/train_data.csv'];
[train_patients, labels] = get_filenames(reference_filepath);

%% Create the csv file to write the features

% Define the csv filename using the date and time
filename = ['features_' datestr(now,'dd-mm-yyyy_HH-MM-SS') '.csv'];

% Define the header of the csv file
header = {  'patient_id',  ...
            'QRS_duration', 'PR_duration', 'QT_duration', 'QS_duration', 'ST_duration', 'P_amplitude', 'Q_amplitude', 'R_amplitude', 'S_amplitude', 'T_amplitude', ...
            'AFEv', 'Radius', 'ShannonEntropy', 'KSTestValue', ...
            'median_RRinterval', 'ifa_index_ratio', ...
            'QRS_similarity', 'R_similarity', 'HighBeats_similarity', 'SQindex', 'noisy', 'label' };
            
% Write the header on the csv file
fid = fopen(filename,'w');
fprintf(fid,'%s,',header{1,1:end-1});
fprintf(fid,'%s\n',header{1,end});
fclose(fid); 

%% Get data
filename = 'features_27-05-2023_14-58-35.csv';

N = length(train_patients);
verbose = 0;

% Define for the inversion check
ptg = 0.7; % threshold as 70% of the max oscillation

for i= 4819:N
    disp(['Processing patient ', num2str(i), ' of ', num2str(N)]);
    file = [DatasetFolderPrefix train_patients{i}];
    disp(file);
    [ecg, Fs, time_axis] = load_patient([DatasetFolderPrefix train_patients{i}]);

    % (1.1) Filtering
    ecg_cleaned = preprocessing(ecg, Fs, time_axis, verbose);

    % (1.2) Correct possible inversion
    [ecg_checked, inverted] = correct_if_inverted(ecg_cleaned, ptg, time_axis, verbose);

    % (2) Feature vector extraction on the processed signal
    [morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector, noisy] = feature_extraction(ecg_checked, Fs, time_axis, verbose);  

    feature_vector = [morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector, noisy];

    disp(['Noisy: ', num2str(noisy)])

    % (3) Write on file the feature vector
    fid = fopen(filename,'a');
    fprintf(fid,'%s,',train_patients{i});
    fprintf(fid,'%f,',feature_vector(1,1:end));
    fprintf(fid,'%s\n',labels{i});
    fclose(fid);
end 





