function features = feature_extraction(recordName,ecg, fs, t, visuals)

    % R peaks detection
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
    
    % Generate an annotation file containing the R peaks locations
    wrann(recordName,'Rpeaks',Rpeak_index,'N',[0],[0],[0],{''})

    % Convert R peaks sample indices in time values
    Rpeak_instant = Rpeak_index/fs;

    % ECGPUWAVE tools
    % generate annotations using ECGPUWAVE tool
    ecgpuwave(recordName,'annotations',[],[],'Rpeaks');
    % retrieve P waves
    pwaves=rdann(recordName,'annotations',[],[],[],'p');
    % retrieve T waves
    twaves=rdann(recordName,'annotations',[],[],[],'t');
    % retrieve others ...
    % TODO: RETRIEVAL DI TUTTO IL NECESSARIO

    if visuals
        figure;
        hold on;grid on
        plot(t,ecg);
        plot(t(pwaves),ecg(pwaves),'or')
        plot(t(twaves),ecg(twaves),'*g')
    end

    if visuals
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