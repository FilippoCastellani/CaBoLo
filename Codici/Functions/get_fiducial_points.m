function [T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs)
    
    %% COMPUTE QRS FIDUCIAL POINTS

    % define the physiological maximal duration of the QRS
    maxqr = 160; % ms 

    % define the window to be considered before and after the R peak in
    % samples to find respectively Q and S
    wnd = (maxqr/2)/1000*fs; % samples

    % get R fiducial points discarding the first and the last beat to
    % consider only complete beats
    R_peak = Rpeak_index(2:length(Rpeak_index)-1);
    n = length(R_peak);

    % Compute Q and S fiducial points 
    Q_peak = nan(1,n);
    S_peak = nan(1,n);
    
    for i=(1:n)     % for each R peak
        qr_signal = ecg(R_peak(i)-wnd:R_peak(i)); % get the QR segment
        [~, Qloc_rel] = min(qr_signal); % find the negative peak 
        Q_peak(i) = Qloc_rel+R_peak(i)-wnd; % store its location wrt the whole ecg
    
        rs_signal = ecg(R_peak(i):R_peak(i)+wnd); % get the RS segment
        [~, Sloc_rel] = min(rs_signal); % find the negative peak 
        S_peak(i) = Sloc_rel+R_peak(i); % store its location wrt the whole ecg
    end

    % Compute the QRS onset and offset 
    % define the window to be considered before the Q and after the S for finding the change of
    % frequency characterizing the start and the end of the QRS complex
    wnd2 = 40; % ms 
    wnd2 = (wnd2)/1000*fs; % samples

    QRS_onset = nan(1,n);
    QRS_offset = nan(1,n);

    for i=(1:n)     % for each identified QRS complex
        before_q = ecg(Q_peak(i)-wnd2:Q_peak(i)); % get ecg in the 40ms before the Q
        slope_before_q = diff(before_q); % get the slope of the segment
        [~, min_loc_1] = min(slope_before_q); % find the minimum slope
        QRS_onset(i) = min_loc_1+Q_peak(i)-wnd2; % store its location wrt the whole ecg

        after_S = ecg(S_peak(i):S_peak(i)+wnd2); % get ecg in the 40ms after the S
        slope_after_S = diff(after_S); % get the slope of the segment
        [~, min_loc_2] = min(slope_after_S); % find the minimum slope
        QRS_offset(i) = min_loc_2+S_peak(i); % store its location wrt the whole ecg
    end 


    %% COMPUTE T WAVE FIDUCIAL POINT

    T_peak = nan(1,n);
    T_onset = nan(1,n);
    T_offset = nan(1,n);

    for i=(1:n)     % for each considered beat
        % consider the T search window as the 3 of the distance between the
        % offset of the QRS complex and the onset of the following one
        if (i<n) 
            t_window_length = round((2/3)*(QRS_onset(i+1)-QRS_offset(i))); 
        end 
        t_window = ecg(QRS_offset(i):QRS_offset(i)+t_window_length);

        % compute the T peak as the maximum value in the T search window
        [~, max_loc] = max(t_window); % find the peak
        T_peak(i) = max_loc+QRS_offset(i); % store its location wrt the whole ecg

        % considering the slope in the T search window 
        % and an empirical threshold of the mean slope 
        emp_ptg = 0.20; 
        slope_t_window = diff(t_window); 
        thr = mean(abs(slope_t_window))*emp_ptg;
        
        % compute the T onset as the first time the slope falls below the
        % threshold going from the T peak  towards right
        slope_beforeT = slope_t_window(1:max_loc);
        slope_afterT = slope_t_window(max_loc:end);

        T_onset(i) = find_minmax_one(slope_beforeT>thr, 'min')+QRS_offset(i); 
        T_offset(i) = find_minmax_one(slope_afterT>-thr, 'min')+T_peak(i);    

    end

end 
