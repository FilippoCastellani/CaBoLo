%% Pre-ops

% Clearing previous data and closing all the windows if any
clc; close all; clear;

%% Setting the environment

% Set environment for host
% Remember to set '/' also at the end
host_path = 'C:/Users/.../Boscarino_Castellani_Lombardi_ProjectBSPLab/'; 

% Set working path
    if (~isempty(host_path)) 
        PROJECT_DIRECTORY = host_path;
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath([PROJECT_DIRECTORY 'WFDB_Toolbox']));

        % add functions folder to search path
        addpath(genpath([PROJECT_DIRECTORY 'Functions']));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
        disp('Environment set to hostpath');

    elseif(getenv('COMPUTERNAME')=="FILIPPO") % se sei sul computer di filippo
        PROJECT_DIRECTORY = 'E:/ProgettiGithub/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("E:/ProgettiGithub/CaBoLo/Codici/WFDB_Toolbox"));

        % add functions folder to search path
        addpath(genpath("E:/ProgettiGithub/CaBoLo/Codici/Functions"));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    elseif(getenv('COMPUTERNAME')=="DESKTOP-T9UVACS")
        PROJECT_DIRECTORY = 'C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici/WFDB_Toolbox"));

        % add functions folder to search path
        addpath(genpath("C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici/Functions"));
         
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
        
        elseif(getenv('COMPUTERNAME')=="F-C")
        PROJECT_DIRECTORY = 'C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/WFDB_Toolbox"));

        % add functions folder to search path
        addpath(genpath("C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/Functions"));
         
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
        
      
    elseif(getenv('COMPUTERNAME')=="") % Computer Nelly
         PROJECT_DIRECTORY = '/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/';
         cd(PROJECT_DIRECTORY);

         addpath(genpath("/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/WFDB_Toolbox"));
         addpath(genpath("/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/Functions"));
         
         DatasetFolderPrefix = 'Dataset/training2017/';
         DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    elseif(getenv('COMPUTERNAME')=="HEAL26821") % Computer Bosca
        PROJECT_DIRECTORY = 'C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/WFDB_Toolbox"));

        % add functions folder to search path
        addpath(genpath("C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/Functions"));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];

    end

%% Set what you want to run 
extract_train = 1;
extract_test = 0;

%% Extract train filenames 
if (extract_train)
    reference_filepath = [PROJECT_DIRECTORY 'Data/train_data.csv'];

    % Define the csv filename using the date and time
    filename = ['Data/train_features_' datestr(now,'dd-mm-yyyy_HH-MM-SS') '.csv'];

elseif (extract_test)
    reference_filepath = [PROJECT_DIRECTORY 'Data/test_data.csv'];

    % Define the csv filename using the date and time
    filename = ['Data/test_features_' datestr(now,'dd-mm-yyyy_HH-MM-SS') '.csv'];

else 
    disp("Set to 1 either the train or the test feature extraction");
end 

[train_patients, labels] = get_filenames(reference_filepath);

%% Create the csv file to write the features

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

% if you want to continue a previous extraction set here the csv file were
% to write and properly set the start of the cycle to the first
% sample to be processed
% filename = ''Data/train_features_15-06-2023_22-37-12.csv'';

N = length(train_patients);
verbose = 0;
start = 1;

% Define for the inversion check
ptg = 0.7; % threshold as 70% of the max oscillation

for i= start:N
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





