function [QRS_duration, PR_duration, QT_duration, QS_interval, ST_duration, P_amplitude, Q_amplitude, R_amplitude, S_amplitude, T_amplitude] = morphological_features(recordName, ecg, fs, t, visuals, Rpeak_index)

    %% MORPHOLOGICAL FEATURES
    % compute the following features
    %   - [X] QRS Duration (Onset-Offset) FEATURE 1
	%	- [X] PR Interval                 FEATURE 2
	%	- [X] QT Interval                 FEATURE 3
	%	- [?] QS Interval                 FEATURE 4
	%	- [X] ST Interval                 FEATURE 5
	%	- [ ] P Amplitude                 FEATURE 6
	%	- [ ] Q Amplitude                 FEATURE 7
	%	- [ ] R Amplitude                 FEATURE 8
	%	- [ ] S Amplitude                 FEATURE 9
	%	- [ ] T Amplitude                 FEATURE 10
    
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