function features = feature_extraction(recordName,ecg, fs, t, visuals)
    
    % Features:
    % [ Morphological, AF_features, RR_features]
    % RR_features = median_RRinterval, ifa_index

    %% R peaks detection

    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
    Rpeak_instant = (Rpeak_index)*(1/fs);

    %% Morphological Features

    %morphological_features  = get_morphological_features(recordName, ecg, fs, t, visuals, Rpeak_index);
    
    %% RR Features

    [median_RRinterval, ifa_index] = get_rr_features(ecg, fs,t, Rpeak_index,visuals);
    
    %%
    %AF_features = get_AF_features(recordName, ecg, fs, t, visuals, Rpeak_index);
    
    %% Plots
    if visuals>1
        figure;
        hold on;grid on
        plot(t,ecg);
%         plot(t(pwaves),ecg(pwaves),'or')
%         plot(t(twaves),ecg(twaves),'*g')
    end

    if visuals>1
        figure; tlim = [0 10]; amplim= [-1 2];
        hold on; plot(t, ecg); scatter(Rpeak_instant,ecg(Rpeak_index),'m'); hold off; ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
        title('QRS on Filtered Signal');
    end 

    % RR time series
    RR_serie = diff(Rpeak_instant);

    if visuals
        figure; amplim= [0 4];
        hold on; plot(RR_serie); hold off; ylabel('RR serie (s)'); xlabel('beats'); ylim(amplim);
        title('Tachogram');
    end 

    if visuals
        figure; tlim = [0 10]; amplim= [-1 2];
        hold on; grid on
        plot(t,ecg);
        plot(((Rpeak_instant(1:end-1)+Rpeak_instant(2:end))./2),ifa_index,'o');
        ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
        title('IfA index on ECG')
    end


    % Features computation

    % Feature vector (row)
    features = {median_RRinterval, ifa_index}; 

end 