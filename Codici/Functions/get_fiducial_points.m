function [P_peak, P_onset, P_offset, T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs, t)
    % This function takes as input the ecg signal of interested already
    % filtered, the relative sampling frequency and the already identified R peaks
    % and returns the locations (in samples) of the fiducial points: 
    % peak, onset e offset of the P wave, T wave and QRS complex (Q, S
    % waves and R peak) 
    % NB: the first and the last beat are discarded to
    % consider only complete beats

    %% COMPUTE QRS FIDUCIAL POINTS

    % define the physiological maximal duration of the QRS
    maxqr = 160; % ms 

    % define the window to be considered before and after the R peak in
    % samples to find respectively Q and S
    wnd = (maxqr/2)/1000*fs; % samples

    % get R fiducial points discarding the first and the last beat
    R_peak = Rpeak_index(2:length(Rpeak_index)-1);
    n = length(R_peak);

    % Compute Q and S fiducial points 
    Q_peak = nan(1,n);
    S_peak = nan(1,n);
    
    for i=(1:n)     % for each R peak
        [start_qr_signal, ~, qr_signal]= window(ecg, R_peak(i)-wnd, R_peak(i)); % get the QR segment
        [~, Qloc_rel] = min(qr_signal); % find the negative peak 
        Q_peak(i) = relocate(Qloc_rel, start_qr_signal); % store its location wrt the whole ecg

        [start_rs_signal, ~, rs_signal]= window(ecg, R_peak(i), R_peak(i)+wnd); % get the RS segment
        [~, Sloc_rel] = min(rs_signal); % find the negative peak 
        S_peak(i) = relocate(Sloc_rel, start_rs_signal); % store its location wrt the whole ecg
    end

    % Compute the QRS onset and offset 
    % define the window to be considered before the Q and after the S for finding the change of
    % frequency characterizing the start and the end of the QRS complex
    wnd2 = 40; % ms 
    wnd2 = (wnd2)/1000*fs; % samples

    QRS_onset = nan(1,n);
    QRS_offset = nan(1,n);

    for i=(1:n)     % for each identified QRS complex
        [start_before_q, ~, before_q] = window(ecg, Q_peak(i)-wnd2, Q_peak(i)); % get ecg in the 40ms before the Q
        slope_before_q = diff(before_q); % get the slope of the segment
        [~, min_loc_sbq] = min(slope_before_q); % find the minimum slope
        QRS_onset(i) = relocate(min_loc_sbq, start_before_q); % store its location wrt the whole ecg

        [start_after_s, ~, after_s] = window(ecg, S_peak(i), S_peak(i)+wnd2); % get ecg in the 40ms after the S
        slope_after_s = diff(after_s); % get the slope of the segment
        [~, min_loc_sas] = min(slope_after_s); % find the minimum slope
        QRS_offset(i) = relocate(min_loc_sas, start_after_s); % store its location wrt the whole ecg
    end 


    %% COMPUTE T WAVE FIDUCIAL POINT

    T_peak = nan(1,n);
    T_onset = nan(1,n);
    T_offset = nan(1,n);

    for i=(1:n)     % for each considered beat
        % define the T search window, that is the segment of the signal in
        % which we expect to find the T wave as the 2/3 of the distance between the
        % offset of the QRS complex in the same beat and the onset of the following one

        % this control allows keep forward the previous window in the last cycle 
        if (i<n) 
            t_window_length = round((2/3)*(QRS_onset(i+1)-QRS_offset(i))); 
        end

        [start_t_window, ~, t_window] = window(ecg, QRS_offset(i), QRS_offset(i)+t_window_length);
        
        % compute the T peak as the maximum value in the T search window
        
        [~, max_loc_t] = max(t_window); % find the peak
        T_peak(i) = relocate(max_loc_t, start_t_window); % store its location wrt the whole ecg

        % Then compute the onset and the offset identifying the main points of
        % inflections by using the slope in the T search window
        % we will work on the filtered signal to highlight only inflections
        % of interest

        M = 7; % order of the lowpass filter
        B = 1/M*ones(M,1);

        % check that the length of the identified window is enough to
        % perform filtering, if not go with the unfiltered signal
        if length(t_window)>M*3 
            filtered_t_window = filtfilt(B,1,t_window);
        else 
            filtered_t_window = t_window;
        end
        
        % check to have at least to values to compute the slope
        if length(filtered_t_window)>2
            slope_t_window = diff(filtered_t_window); 
        else
            slope_t_window = filtered_t_window;
        end 

        % Define a threshold for the slope as a percentage of the mean
        % slope respectively on the two sides of the 
        % wave with respect to the T peak 
        % and find the onset and the offset as the points where the slope
        % overcomes the threshold in the two sides
        
        emp_ptg = 0.5; % empirical percentage
        
        % onset
        [~, ~, slope_before_t] = window(slope_t_window, 1, max_loc_t); % get the slope of the T wave before the peak
        on_thr = mean(slope_before_t)*emp_ptg; % compute the threshold for the upward side
        on_loc = find_first_rise(slope_before_t, on_thr, 1); % find the location of the first positive inflection of the slope (return the beggining of the window if none is found)
        T_onset(i) = relocate(on_loc, start_t_window); % store its location wrt the whole ecg

        % offset
        [~, ~, slope_after_t] = window(slope_t_window, max_loc_t, length(slope_t_window)); % get the slope of the T wave after the peak
        of_thr = mean(slope_after_t)*emp_ptg; % compute the threshold for the downward side
        of_loc = find_first_rise(slope_after_t, of_thr, length(slope_after_t)); % find the location of the first negative inflection of the slope (return the end of the window if none is found)
        T_offset(i) = relocate(of_loc, T_peak(i)); % store its location wrt the whole ecg

        % figure; hold on; plot(t_window); plot(filtered_t_window); plot(slope_t_window); yline(0); yline(on_thr); yline(of_thr); xline(on_loc); xline(of_loc+max_loc); hold off;

    end


     %% COMPUTE P WAVE FIDUCIAL POINT

    P_peak = nan(1,n);
    P_onset = nan(1,n);
    P_offset = nan(1,n);

    for i=(n:-1:1)     % for each considered beat (starting form the last one)
        % define the P search window, that is the segment of the signal in
        % which we expect to find the P wave as the distance between the
        % offset of the T wave of the previous beat and the onset of the
        % QRS complex in the same beat

        % this control allows keep backward the previous window in the last cycle 
        if (i>1) 
            p_window_length = round((2/3)*(QRS_onset(i)-T_offset(i-1))); 
        end 

        [start_p_window, ~, p_window] = window(ecg, QRS_onset(i)-p_window_length, QRS_onset(i));

        % compute the P peak as the maximum value in the P search window
        [~, max_loc_p] = max(p_window); % find the peak
        P_peak(i) = relocate(max_loc_p, start_p_window); % store its location wrt the whole ecg

        % Then compute the onset and the offset identifying the main points of
        % inflections by using the slope in the P search window
        % we will work on the filtered signal to highlight only inflections
        % of interest

        % check that the length of the identified window is enough to
        % perform filtering, if not go with the unfiltered signal
        M = 7; % order of the lowpass filter
        B = 1/M*ones(M,1);
        if length(p_window)>M*3
            filtered_p_window = filtfilt(B,1,p_window);
        else 
            filtered_p_window = p_window;
        end
        
        % check to have at least to values to compute the slope
        if length(filtered_p_window)>2
            slope_p_window = diff(filtered_p_window); 
        else
            slope_p_window = filtered_p_window;
        end 

        % Define a threshold for the slope as a percetange of the mean
        % slope respectively on the two sides of the 
        % wave with respect to the P peak 
        % and find the onset and the offset as the points where the slope
        % overcomes the threshold in the two sides
        
        emp_ptg = 0.2; % empirical percentage
        
        % onset
        [~, ~, slope_before_p] = window(slope_p_window, 1, max_loc_p); % get the slope before the P peak
        on_thr = mean(slope_before_p)*emp_ptg; % compute the threshold for the upward side
        on_loc = find_first_rise(slope_before_p, on_thr, 1); % find the first point of positive inflection (return the beginning if none is found)
        P_onset(i) = relocate(on_loc, start_p_window);

        % offset
        [~, ~, slope_after_p] = window(slope_p_window, max_loc_p, length(slope_p_window)); % get the slope after the P peak
        of_thr = mean(slope_after_p)*emp_ptg; % compute the threshold for the downward side
        of_loc = find_first_rise(slope_after_p, of_thr, length(slope_after_p)); % find the first point of negative inflection (return the end if none is found)
        P_offset(i) = relocate(of_loc, P_peak(i));   

        %figure; hold on; plot(p_window); plot(filtered_p_window); plot(slope_p_window); yline(0); yline(on_thr); yline(of_thr); xline(on_loc); xline(of_loc+max_loc); plot(max_loc, p_window(max_loc), '*r'); hold off; legend({'original signal','filtered signal','slope of filtered signal'})

    end

end 
