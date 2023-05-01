function features = feature_extraction(recordName,ecg, fs, t, visuals)
    % R peaks detection
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
    
    %morphological_features  = get_morphological_features(recordName, ecg, fs, t, visuals, Rpeak_index);
    
    AF_features             = get_AF_features(recordName, ecg, fs, t, visuals, Rpeak_index);

    if visuals>1
        figure;
        hold on;grid on
        plot(t,ecg);
        plot(t(pwaves),ecg(pwaves),'or')
        plot(t(twaves),ecg(twaves),'*g')
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


    % Features computation

    % Feature vector (row)
    features = []; 

end 