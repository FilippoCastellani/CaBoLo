% FC 
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

%% Set working path
    if(getenv('COMPUTERNAME')=="FILIPPO") % se sei sul computer di filippo
        cd("E:\DrivePolimi\OneDrive - Politecnico di Milano\MasterSubjects\Biomedical Signal Processing LAB\2022\Progetto\Codici\DatasetOriginale\training2017");
    else 
        %DatasetPath = "default"; %put your path here;
    end

%% Demonstrative purposes

% Let's pick the first patient
SelectedPatient='A00001';

% Let's load patient's informations
[signal, sampling_frequency, time_axis] = Load_Patient(SelectedPatient);


% Let's plot patient's signal
plot(time_axis,signal)



function [Sig, Fs, Time] = Load_Patient(PatientName)
    %PatientPath = fullfile("training2017",PatientName);
    [Sig, Fs, Time] = rdsamp(PatientName, 1);
    
end