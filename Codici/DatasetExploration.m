% Dataset Exploration

% ECG recordings, collected using the AliveCor device.
% The training set contains 8,528 single lead ECG recordings lasting from 9 s 
% to just over 60 s.
% ECG recordings were sampled as 300 Hz and they have been band pass filtered 
% by the AliveCor device.

% All data are provided in MATLAB V4 WFDB-compliant format (each including 
% a .mat file containing the ECG and a .hea file containing the waveform information). 

% The patients name are similiar to the following:
% - A00001
% - A00002 
% ...

clear all;

%% Set working path
    if(getenv('COMPUTERNAME')=="FILIPPO") % se sei sul computer di filippo
        PROJECT_DIRECTORY = 'E:/ProgettiGithub/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("E:/ProgettiGithub/CaBoLo/Codici/WFDB_Toolbox"));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
        
    else 
        %DatasetPath = "default"; %put your path here;
    end

%% Demonstrative purposes

% Let's pick the first patient
SelectedPatient='A00001';

SelectedPatientPath=[DatasetFolderPrefix SelectedPatient];

%% Reading selected patient infos

% Let's load patient's informations
[signal, sampling_frequency, time_axis] = Load_Patient(SelectedPatientPath);

% Let's plot patient's signal
plot(time_axis,signal)
