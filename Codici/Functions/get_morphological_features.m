function morphological_feature_vector = get_morphological_features(ecg, fs, t, visuals, Rpeak_index)

    %% MORPHOLOGICAL FEATURES
    % compute the following features
    %   - [X] QRS Duration (Onset-Offset) FEATURE 1
	%	- [X] PR Interval                 FEATURE 2
	%	- [X] QT Interval                 FEATURE 3
	%	- [X] QS Interval                 FEATURE 4
	%	- [X] ST Interval                 FEATURE 5
	%	- [X] P Amplitude                 FEATURE 6
	%	- [X] Q Amplitude                 FEATURE 7
	%	- [X] R Amplitude                 FEATURE 8
	%	- [X] S Amplitude                 FEATURE 9
	%	- [X] T Amplitude                 FEATURE 10

    % the final morphological_feature_vector is the row vector: 
    [P_peak, P_onset, P_offset, T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs);
   
    if visuals
        figure;
        hold on;grid on
        plot(t,ecg);
        color='cyan'; peak=P_peak; on=P_onset; off=P_offset; lab='P'; plot(t(peak),ecg(peak),'*','Color',color); xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='green'; peak=T_peak; on=T_onset; off=T_offset; lab='T'; plot(t(peak),ecg(peak),'*','Color',color); xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='red'; on=QRS_onset; off=QRS_offset; lab='QRS';  xline(on/fs,'-',{lab}, 'Color', color); xline(off/fs,'-',{''},'Color', color);
        color='red'; peak=Q_peak'; plot(t(peak),ecg(peak),'*','Color',color);
        color='red'; peak=S_peak'; plot(t(peak),ecg(peak),'*','Color',color);
        color='red'; peak=R_peak'; plot(t(peak),ecg(peak),'*','Color',color);
    end
    
    P_amplitude = median(ecg(P_peak));
    Q_amplitude = median(ecg(Q_peak));
    R_amplitude = median(ecg(R_peak)); 
    S_amplitude = median(ecg(S_peak));
    T_amplitude = median(ecg(T_peak));
    
    % Compute QRS duration as the difference between onset and offset in seconds
    QRS_duration = median((QRS_offset - QRS_onset)/fs);       % in order to have the duration in seconds

    % Compute PR interval as the difference between onset of P wave and onset of QRS complex
    PR_duration = median((QRS_onset - P_onset)/fs);           % in order to have the duration in seconds

    % Compute QT interval as the difference between onset of QRS complex and offset of T wave
    QT_duration = median((T_offset - QRS_onset)/fs);          
    
    % Compute QS interval as the difference between Q peak and S peak 
    QS_duration = median((S_peak-Q_peak)/fs);

    % Compute ST interval as the difference between offset of QRS complex and offset of T wave
    ST_duration = median((T_offset - QRS_offset)/fs);         % in order to have the duration in seconds 

    morphological_feature_vector = [QRS_duration, PR_duration, QT_duration, QS_duration, ST_duration, P_amplitude, Q_amplitude, R_amplitude, S_amplitude, T_amplitude];