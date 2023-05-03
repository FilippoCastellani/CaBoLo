function [morphological_feature_vector, AF_features, RR_features] = feature_extraction(ecg, fs, t, visuals)
    % This function returns the feature vector for the ecg signal in input
    % Inputs:
    % ecg: signal of interest
    % fs: sampling frequency of the signal
    % t: time vector of the ecg
    % visuals: flag defining whether to plot visuals or not

    %% R peaks detection

    % R peaks detection with Pan-Tompkin's algorithm
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);

    %% Morphological Features

    % Morphological features extraction 
    morphological_feature_vector = get_morphological_features(ecg, fs, t, visuals, Rpeak_index);
    
    %% RR Features

    % [median_RRinterval, ifa_index] = get_rr_features(ecg, fs,t, Rpeak_index,visuals);
    RR_features = [];
    
    %% AF features
    %AF_features = get_AF_features(recordName, ecg, fs, t, visuals, Rpeak_index);
    AF_features = [];

    %% to be checked

    % 
    % if visuals>1
    %     figure; tlim = [0 10]; amplim= [-1 2];
    %     hold on; plot(t, ecg); scatter(Rpeak_index,ecg(Rpeak_index),'m'); hold off; ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
    %     title('QRS on Filtered Signal');
    % end 
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