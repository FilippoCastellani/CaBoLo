function [morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector, noisy] = feature_extraction(ecg, fs, t, visuals)
    % This function returns the feature vector for the ecg signal in input
    % Inputs:
    % ecg: signal of interest
    % fs: sampling frequency of the signal
    % t: time vector of the ecg
    % visuals: flag defining whether to plot visuals or not

    %% R peaks detection

    % R peaks detection with Pan-Tompkin's algorithm
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
    
    noisy = 0;

    %% Check RR above physiological limits (refractory period)
    refractory_period = 0.2; % refractory period [s] = 200 ms
    
    RR = diff(Rpeak_index)/fs; % RR time series [s]
    RR(RR<refractory_period) = NaN; % set RR below refractory period to NaN
    invalid_RR = find(isnan(RR)); % identify invalid RR intervals
    
    % if more than 60% of the RR intervals result to be invalid, it is
    % deemed unfit for classification
    if length(invalid_RR) > 0.6*length(RR)
        noisy = 1;
    end 
    
    R_peaks = Rpeak_index;
    while (~isempty(invalid_RR) && ~noisy)
        disp('...checking for invalid RR...')

        for i = 1:length(invalid_RR)
            i_RR = invalid_RR(i);
            peak_1 = Rpeak_index(i_RR);
            peak_2 = Rpeak_index(i_RR+1);
    
            [~, index] = min([ecg(peak_1),ecg(peak_2)]); % find the minimum between the two peaks
            if index == 1
                R_peaks(i_RR) = NaN; % set invalid R peaks to NaN
            else
                R_peaks(i_RR+1) = NaN; % set invalid R peaks to NaN
            end
        end

        % drop nan values from Rpeak_index
        R_peaks = R_peaks(~isnan(R_peaks));

        % Compute again the RR intervals and re-check
        RR = diff(R_peaks)/fs; % RR time series [s]
        RR(RR<refractory_period) = NaN; % set RR below refractory period to NaN
        invalid_RR = find(isnan(RR)); % identify invalid RR intervals
        Rpeak_index = R_peaks;
    end
    
    % Set as too noisy to be analyzed signals with less than a minimum
    % number of beats recognized
    min_peaks = 5;
    if length(R_peaks) < min_peaks
        noisy= 1;
    end

    disp(var(ecg(R_peaks)));

    if (~noisy)

        % Morphological Features
        morphological_feature_vector = get_morphological_features(ecg, fs, t, visuals, Rpeak_index);
        
        % RR Features
        [median_RRinterval, ifa_index_ratio] = get_rr_features(ecg, fs,t, Rpeak_index,visuals);
        RR_feature_vector = [median_RRinterval, ifa_index_ratio];
        
        % Similairty Features
        [QRS_similarity, R_similarity, HighBeats_similarity, SQindex] = get_similarity_features(ecg, fs, t, Rpeak_index, visuals);
        similarity_feature_vector = [QRS_similarity, R_similarity, HighBeats_similarity, SQindex];
        
        % AF features
        [AFEv, Radius, ShannonEntropy, KSTestValue] = get_AF_features(ecg, fs, t, Rpeak_index, visuals);
        AF_feature_vector = [AFEv, Radius, ShannonEntropy, KSTestValue];
    
    else 
        morphological_feature_vector = NaN(1, 10);
        RR_feature_vector = NaN(1, 2);
        similarity_feature_vector = NaN(1, 4);
        AF_feature_vector = NaN(1, 4);
    end 
 

end 