function features = feature_extraction(recordName,ecg, fs, t, visuals)
    
    %% MORPHOLOGICAL FEATURES
    % compute the following features
    %   - [X] QRS Duration (Onset-Offset) FEATURE 1
	%	- [X] PR Interval                 FEATURE 2
	%	- [X] QT Interval                 FEATURE 3
	%	- [?] QS Interval                 FEATURE 4
	%	- [X] ST Interval                 FEATURE 5
	%	- [ ] P Amplitude                 FEATURE 6
	%	- [ ] Q Amplitude
	%	- [ ] R Amplitude
	%	- [ ] S Amplitude
	%	- [ ] T Amplitude
    
    % R peaks detection
    [~, Rpeak_index, ~]= pan_tompkin(ecg,fs,0);
    
    % Generate .Rpeaks file containing the R peaks locations identified
    % using Pan-Tompkins algorithm
    wrann(recordName,'Rpeaks',Rpeak_index,'N',[0],[0],[0],{''})

    % Convert R peaks sample indices in time values
    Rpeak_instant = Rpeak_index/fs;

    % ECGPUWAVE tools
    % generate .annotations file using ECGPUWAVE tool starting from .Rpeaks
    % file (generated using wrann)
    ecgpuwave(recordName,'annotations',[],[],'Rpeaks');
    
    % retrieve P waves reading .annotations file considering only P peaks
    pwaves=rdann(recordName,'annotations',[],[],[],'p');
    % retrieve T waves
    twaves=rdann(recordName,'annotations',[],[],[],'t');
    % retrieve onsets
    [onset_ann_index,~,~,~,onset_ann_num,~]=rdann(recordName,'annotations',[],[],[],'(');
    
    % retrieve offsets
    [offset_ann_index,~,~,~,offset_ann_num,~]=rdann(recordName,'annotations',[],[],[],')');
    
    % Compute QRS duration as the difference between onset and offset in seconds
    QRS_onset = onset_ann_index(onset_ann_num==1);    % 1 is used for QRS
    QRS_offset = offset_ann_index(offset_ann_num==1); % 1 is used for QRS
    QRS_duration = (QRS_offset - QRS_onset)/fs;       % in order to have the duration in seconds

    % Compute PR interval as the difference between onset of P wave and onset of QRS complex
    P_onset = onset_ann_index(onset_ann_num==0);      % 0 is used for P waves
    PR_duration = (QRS_onset - P_onset)/fs;           % in order to have the duration in seconds

    % Compute QT interval as the difference between onset of QRS complex and offset of T wave
    T_offset = offset_ann_index(offset_ann_num==2);   % 2 is used for T waves
    QT_duration = (T_offset - QRS_onset)/fs;          % in order to have the duration in seconds
    
    % Compute QS interval as the difference between Q peak and S peak indexes
    % Compute Q and S fiducial points 
    n = len(QRS_onset);
    qwaves = nan(n);
    swaves = nan(n);
   
    for i=(1:n)     % for each identified QRS complex
        qr_signal = ecg(QRS_onset(i):Rpeak_index(i)); % get the QR segment
        [~, Qloc_rel] = min(qr_signal); % find the negative peak 
        qwaves(i) = Qloc_rel+QRS_onset(i); % store its location wrt the whole ecg

        rs_signal = ecg(Rpeak_index(i):QRS_offset(i)); % get the RS segment
        [~, Sloc_rel] = min(rs_signal); % find the negative peak 
        swaves(i) = Sloc_rel+Rpeak_index(i); % store its location wrt the whole ecg
    end
    QS_interval = (swaves-qwaves)/fs;

    % Compute ST interval as the difference between offset of QRS complex and offset of T wave
    ST_duration = (T_offset - QRS_offset)/fs;         % in order to have the duration in seconds 

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