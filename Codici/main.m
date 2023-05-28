%% MAIN SCRIPT
% Clearing previous data and closing all the windows if any

clc;close all;clear;

%% Setting the environment

% Set working path
    if(getenv('COMPUTERNAME')=="FILIPPO") % se sei sul computer di filippo
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

    %else 
        %DatasetPath = "default"; %put your path here;

    end
    
%% Generate Atrial Fibrillation Cumulative Distribution

% The generation of the cumulative distribution is done only once from a selection of patients AF.

% This is the folder where the AF patients data are stored
AF_Distribution_Folder =  'Dataset/AF_Distribution_Patients/';
% The call to the function that generates the cumulative distribution
generate_af_cumulative_distribution(AF_Distribution_Folder, -1, true)
% Parameters:
% AF_Distribution_Folder: the folder where the AF patients data are stored
% -1: all the patients in the reference .csv file are used
% true: the plot of the cumulative distribution is shown

%% Loading data
% Let's pick a patient
SelectedPatient='A02345';

SelectedPatientPath=[DatasetFolderPrefix SelectedPatient];

% Reading selected patient infos

% Let's load patient's informations
[signal, Fs, time_axis] = load_patient(SelectedPatientPath);


%% Preprocessing 
ecg = signal;
verbose= 0;

% (1.1) Filtering
ecg_cleaned = preprocessing(ecg, Fs, time_axis, verbose); 

% (1.2) Correct possible inversion
ptg = 0.7; % define the threshold as 70% of the max oscillation
[ecg_checked, inverted] = correct_if_inverted(ecg_cleaned, ptg, time_axis, verbose);

%% Feature Extraction

% (2) Feature vector extraction on the processed signal
verbose=1;
[morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector, noisy] = feature_extraction(ecg_checked, Fs, time_axis, verbose);    
feature_vector = [morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector, noisy];

%%
%ecgpuwave

% may be usefull to check results:
% 
wfdbRecordViewer
