%% MAIN SCRIPT
% Clearing previous data and closing all the windows if any

clc;close all;clear;

%% Set what you want to run 
train_test_split = 1;
af_distribution_extraction = 1;
filter_design_study = 1;

%% Setting the environment

% Set environment for host
host_path = ''; 

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

%% Dataset split 

if (train_test_split)
    % Load the CSV file
    dataset_folder = DatasetFolderPrefix;
    reference_filepath = dataset_folder + "REFERENCE.csv";
    data = readtable(reference_filepath','ReadVariableNames', false); 
    data.Properties.VariableNames = {'FileName', 'Label'};
    
    % Extract the file names and labels
    fileNames = data.FileName; 
    labels = data.Label; 
    
    % Perform a stratified partition based on the labels
    cvp = cvpartition(labels, 'Holdout', 0.2, 'Stratify', true); 
    
    % Generate logical indices for the training and testing sets
    trainIndices = training(cvp);
    testIndices = test(cvp);
    
    % Split the data into training and testing sets
    trainData = data(trainIndices, :);
    testData = data(testIndices, :);
    
    % Save the training and testing sets as separate CSV files
    writetable(trainData, 'train_data.csv');
    writetable(testData, 'test_data.csv');
end 

%% Generate Atrial Fibrillation Cumulative Distribution

if (af_distribution_extraction)
    % The generation of the cumulative distribution is done only once from a selection of patients AF.
    
    % This is the folder where the AF patients data are stored
    AF_Distribution_Folder =  'Dataset/AF_Distribution_Patients/';
    % The call to the function that generates the cumulative distribution
    generate_af_cumulative_distribution(AF_Distribution_Folder, -1, true)
    % Parameters:
    % AF_Distribution_Folder: the folder where the AF patients data are stored
    % -1: all the patients in the reference .csv file are used
    % true: the plot of the cumulative distribution is shown

end 

%% Loading data
% Let's pick a patient
SelectedPatient='A00003'; % A08495 

SelectedPatientPath=[DatasetFolderPrefix SelectedPatient];

% Reading selected patient infos

% Let's load patient's informations
[signal, Fs, time_axis] = load_patient(SelectedPatientPath);

%% Study filter design 

if (filter_design_study)
    
    fs = Fs; 
    t = time_axis; 
    ecgSignal = signal;
    
    % Define the passband frequency range
    passbandLow = 1.5; % Hz
    passbandHigh = 50; % Hz
    Wn = [passbandLow, passbandHigh]/(fs/2); % normlized passband
    
    % Define the filter orders to test
    filterOrders = [3, 4, 5, 7, 10];
    
    % Initialize the figure
    figure;
    hold on;
    
    % Plot the original ECG signal
    subplot(length(filterOrders)+1, 2, 1);
    plot(t, ecgSignal);
    title('Original ECG Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([5,15]);
    
    % Apply Butterworth filters with different orders, plot the filtered signals,
    % and plot the magnitude response of each filter
    for i = 1:length(filterOrders)
        filterOrder = filterOrders(i);
        
        % Design the Butterworth filter
        [b, a] = butter(filterOrder, Wn);
    
        % Apply the filter to the ECG signal
        filteredECG = filtfilt(b, a, ecgSignal);
    
        % Plot the filtered signal
        subplot(length(filterOrders)+1, 2, i*2+1);
        plot(t, filteredECG);
        title(sprintf('Filtered ECG Signal (Order: %d)', filterOrder));
        xlabel('Time (s)');
        ylabel('Amplitude');
        xlim([5,15]);
        
        % Compute the frequency response of the filter
        [H, f] = freqz(b, a, length(ecgSignal), fs);
        
        % Plot the magnitude response
        subplot(length(filterOrders)+1, 2, i*2+2);
        plot(f, abs(H));
        title('Magnitude Response');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
    end
    
    % Restore hold off
    hold off;
 end 

%% Preprocessing 
ecg = signal;
verbose= 1;

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

