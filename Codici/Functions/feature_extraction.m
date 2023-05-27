function [morphological_feature_vector, AF_feature_vector, RR_feature_vector, similarity_feature_vector] = feature_extraction(ecg, fs, t, visuals)
    % This function returns the feature vector for the ecg signal in input
    % Inputs:
    % ecg: signal of interest
    % fs: sampling frequency of the signal
    % t: time vector of the ecg
    % visuals: flag defining whether to plot visuals or not

    %% R peaks detection

    % R peaks detection with Pan-Tompkin's algorithm
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);

    %% Check RR above physiological limits refractory period)
    RR = diff(Rpeak_index)/fs; % RR time series [s]
    refractory_period = 0.2; % refractory period [s] = 200 ms
    RR(RR<refractory_period) = NaN; % set RR below refractory period to NaN
    invalid_RR = find(isnan(RR)) % identify invalid RR intervals

    for i = 1:length(invalid_RR)
        i_RR = invalid_RR(i);
        peak_1 = Rpeak_index(i_RR);
        peak_2 = Rpeak_index(i_RR+1);

        [~, index] = min([ecg(peak_1),ecg(peak_2)]); % find the minimum between the two peaks
        if index == 1
            Rpeak_index(i_RR) = NaN; % set invalid R peaks to NaN
        else
            Rpeak_index(i_RR+1) = NaN; % set invalid R peaks to NaN
        end
    end

    % drop nan values from Rpeak_index
    Rpeak_index = Rpeak_index(~isnan(Rpeak_index));

    %% Morphological Features

    % Morphological features extraction 
    morphological_feature_vector = get_morphological_features(ecg, fs, t, visuals, Rpeak_index);
    
    %% RR Features

    [median_RRinterval, ifa_index_ratio] = get_rr_features(ecg, fs,t, Rpeak_index,visuals);

    RR_feature_vector = [median_RRinterval, ifa_index_ratio];
    
    %% Similairty Features

    [QRS_similarity, R_similarity, HighBeats_similarity, SQindex] = get_similarity_features(ecg, fs, t, Rpeak_index, visuals);
    
    similarity_feature_vector = [QRS_similarity, R_similarity, HighBeats_similarity, SQindex];
    %% AF features
    
    [AFEv, Radius, ShannonEntropy, KSTestValue] = get_AF_features(ecg, fs, t, Rpeak_index, visuals);

    AF_feature_vector = [AFEv, Radius, ShannonEntropy, KSTestValue];
  

    if visuals
        figure; tlim = [0 10]; amplim= [-1 2];
        hold on; plot(t, ecg); scatter(Rpeak_index,ecg(Rpeak_index),'m'); hold off; ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
        title('QRS on Filtered Signal');
    end 
    % 
    % % RR time series
    % RR_serie = diff(Rpeak_index)/fs;

    % if visuals
    %     figure; amplim= [0 4];
    %     hold on; plot(RR_serie); hold off; ylabel('RR serie (s)'); xlabel('beats'); ylim(amplim);
    %     title('Tachogram');
    % end 

    % if visuals
    %     figure; tlim = [0 10]; amplim= [-1 2];
    %     hold on; grid on
    %     plot(t,ecg);
    %     plot(((Rpeak_instant(1:end-1)+Rpeak_instant(2:end))./2),ifa_index,'o');
    %     ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
    %     title('IfA index on ECG')
    % end


    % % Features computation
    % 
    % % Feature vector (row)
    % features = {median_RRinterval, ifa_index}; 

end 