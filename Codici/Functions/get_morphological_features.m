function morphological_feature_vector = get_morphological_features(ecg, fs, t, visuals, Rpeak_index)

    %% MORPHOLOGICAL FEATURES
    % compute the following features
    %   - [X] QRS Duration (Onset-Offset) FEATURE 1
	%	- [ ] PR Interval                 FEATURE 2
	%	- [ ] QT Interval                 FEATURE 3
	%	- [ ] QS Interval                 FEATURE 4
	%	- [ ] ST Interval                 FEATURE 5
	%	- [ ] P Amplitude                 FEATURE 6
	%	- [ ] Q Amplitude                 FEATURE 7
	%	- [ ] R Amplitude                 FEATURE 8
	%	- [ ] S Amplitude                 FEATURE 9
	%	- [ ] T Amplitude                 FEATURE 10

    % the final morphological_feature_vector is the row vector: 
    % [QRS_duration, PR_duration, QT_duration, QS_interval, ST_duration, P_amplitude, Q_amplitude, R_amplitude, S_amplitude, T_amplitude]
    
    %[P_peak, P_onset, P_offset, T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset] = get_ecg_fiducial_points(recordName, ecg, Rpeak_index);
    
    [T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset] = get_fiducial_points(ecg, Rpeak_index,  fs);
   
    if visuals
        figure;
        hold on;grid on
        plot(t,ecg);
        % color='blue'; peak=P_peak; on=P_onset; off=P_offset; lab='P'; plot(t(peak),ecg(peak),'*','Color',color); xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='green'; peak=T_peak; on=T_onset; off=T_offset; lab='T'; plot(t(peak),ecg(peak),'*','Color',color); xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='red'; on=QRS_onset; off=QRS_offset; lab='QRS';  xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='red'; peak=Q_peak'; plot(t(peak),ecg(peak),'*','Color',color);
        color='red'; peak=S_peak'; plot(t(peak),ecg(peak),'*','Color',color);
        color='red'; peak=R_peak'; plot(t(peak),ecg(peak),'*','Color',color);
    end
    
    P_amplitude= 0;
    Q_amplitude = 0;
    R_amplitude = 0; 
    S_amplitude = 0;
    T_amplitude = 0;
    
    % Compute QRS duration as the difference between onset and offset in seconds
    QRS_duration = (QRS_offset - QRS_onset)/fs;       % in order to have the duration in seconds

    % Compute PR interval as the difference between onset of P wave and onset of QRS complex
    PR_duration = (QRS_onset - P_onset)/fs;           % in order to have the duration in seconds

    % Compute QT interval as the difference between onset of QRS complex and offset of T wave
    QT_duration = (T_offset - QRS_onset)/fs;          % in order to have the duration in seconds
    
    % Compute QS interval as the difference between Q peak and S peak indexes
    QS_interval = (swaves-qwaves)/fs;

    % Compute ST interval as the difference between offset of QRS complex and offset of T wave
    ST_duration = (T_offset - QRS_offset)/fs;         % in order to have the duration in seconds 

    morphological_feature_vector = [QRS_duration, PR_duration, QT_duration, QS_interval, ST_duration, P_amplitude, Q_amplitude, R_amplitude, S_amplitude, T_amplitude];