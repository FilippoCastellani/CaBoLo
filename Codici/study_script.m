%% Pre-ops

% Clearing previous data and closing all the windows if any
clc; close all; clear;

% Setting the environment
[PROJECT_DIRECTORY, DatasetFolderPath,DatasetFolderPrefix] = set_environment();

%% Loading data
% Let's pick a patient
SelectedPatient='A03602';

SelectedPatientPath=[DatasetFolderPrefix SelectedPatient];

% Reading selected patient infos

% Let's load patient's informations
[signal, Fs, time_axis] = load_patient(SelectedPatientPath);

%% Filter design 

% Get the ECG signal
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






