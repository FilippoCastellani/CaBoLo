function [median_RRinterval, ifa_index] = get_rr_features(ecg,fs,t, Rpeak_index,visuals)
    % This functions calculates the RR-interval related features of the ECG
    % signal
    
    % OUTPUTS

    % - [X] Median RR interval (median_RRinterval)
    % - [X] Index for Arrhythmia (ifa_index)

    % INPUTS

    % ecg: ECG recording
    % fs: sampling frequency
    % t: time vector of the recording
    % Rpeak_index: R peaks detection with Pan-Tompkin's algorithm
    % visuals: flag defining whether to plot visuals or not

%% Median RR interval

%[~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
% RR intervals in seconds
rr_serie = (diff(Rpeak_index))*(1/fs);

% MRR as the median of RR intervals in the ecg
median_RRinterval = median(rr_serie);

%% INDEX FOR ARRHYTHMIA 

% Initialize I.f.A. index value
% integer value from 0 to 4

ifa_index = zeros(1,length(rr_serie));

% MRR as the average of the five nearest beats
mrr = movmean(rr_serie, [2 2]);

% This feature is based on 4 rules and its value is incremented 
% for each rule compliant.

% Rule 1
for i = 1:length(rr_serie) - 2 
    condition_1_1 = (1.2*rr_serie(i+1)) < rr_serie(i);
    condition_1_2 = (1.3*rr_serie(i+1)<rr_serie(i+2));
    if (condition_1_1 && condition_1_2) 
        ifa_index(i) = ifa_index(i) + 1;
    end
end

% Rule 2
for i = 1:length(rr_serie) - 2
    condition_2_1 = abs(rr_serie(i)-rr_serie(i+1)) < (0.3 * mrr(i+1));
    condition_2_2 = ((rr_serie(i) < (0.8*mrr(i+1))) || (rr_serie(i) < 0.8*mrr(i+1)));
    condition_2_3 = (rr_serie(i+2) > (0.6*(rr_serie(i)+rr_serie(i+1))));
    if (condition_2_1 && condition_2_2 && condition_2_3)
        ifa_index(i) = ifa_index(i) + 1;
    end
end

% Rule 3
for i = 1:length(rr_serie) - 2
    condition_3_1 = (abs(rr_serie(i+2)-rr_serie(i+1)) < (0.3*mrr(i+1)));
    condition_3_2 = (((rr_serie(i+1) < 0.8*mrr(i+1)) || (rr_serie(i+2) < 0.8*mrr(i+1))));
    condition_3_3 = (rr_serie(i) > (0.6*(rr_serie(i+1)+rr_serie(i+2))));
    if (condition_3_1 && condition_3_2 && condition_3_3)
        ifa_index(i) = ifa_index(i) + 1;
    end
end

% Rule 4
for i = 1:length(rr_serie) - 2
    condition_4_1 = (rr_serie(i+1)>(1.5*mrr(i+1)));
    condition_4_2 = ((1.5*rr_serie(i+1))<(3*mrr(i+1)));
    if (condition_4_1 && condition_4_2)
        ifa_index(i) = ifa_index(i) + 1;
    end
end

end