function [P_peak, P_onset, P_offset, T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs)
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
        start=R_peak(i)-wnd; stop=R_peak(i);
        if start<1
            start=1;
        end
        qr_signal = ecg(start:stop); % get the QR segment
        [~, Qloc_rel] = min(qr_signal); % find the negative peak 
        Q_peak(i) = Qloc_rel+start-1; % store its location wrt the whole ecg
    
        start=R_peak(i); stop=R_peak(i)+wnd;
        if stop>length(ecg)
            stop=length(ecg);
        end
        rs_signal = ecg(start:stop); % get the RS segment
        [~, Sloc_rel] = min(rs_signal); % find the negative peak 
        S_peak(i) = Sloc_rel+start-1; % store its location wrt the whole ecg
    end

    % Compute the QRS onset and offset 
    % define the window to be considered before the Q and after the S for finding the change of
    % frequency characterizing the start and the end of the QRS complex
    wnd2 = 40; % ms 
    wnd2 = (wnd2)/1000*fs; % samples

    QRS_onset = nan(1,n);
    QRS_offset = nan(1,n);

    for i=(1:n)     % for each identified QRS complex
        start= Q_peak(i)-wnd2; stop= Q_peak(i);
        if start<1
            start=1;
        end 
        before_q = ecg(start:stop); % get ecg in the 40ms before the Q
        slope_before_q = diff(before_q); % get the slope of the segment
        [~, min_loc_1] = min(slope_before_q); % find the minimum slope
        QRS_onset(i) = min_loc_1+start-1; % store its location wrt the whole ecg

        start= S_peak(i); stop= S_peak(i)+wnd2;
        if stop>length(ecg)
            stop= length(ecg);
        end 
        after_S = ecg(start:stop); % get ecg in the 40ms after the S
        slope_after_S = diff(after_S); % get the slope of the segment
        [~, min_loc_2] = min(slope_after_S); % find the minimum slope
        QRS_offset(i) = min_loc_2+start-1; % store its location wrt the whole ecg
    end 


    %% COMPUTE T WAVE FIDUCIAL POINT

    T_peak = nan(1,n);
    T_onset = nan(1,n);
    T_offset = nan(1,n);

    for i=(1:n)     % for each considered beat
        % define the T search window, that is the segment of the signal in
        % which we expect to find the T wave as the 2/3 of the distance between the
        % offset of the QRS complex in the same beat and the onset of the following one
        if (i<n) 
            t_window_length = round((2/3)*(QRS_onset(i+1)-QRS_offset(i))); 
        end 
        start = QRS_offset(i); stop = QRS_offset(i)+t_window_length;
        if stop>length(ecg) 
            stop=length(ecg); 
        end
        t_window = ecg(start:stop);

        % compute the T peak as the maximum value in the T search window
        [~, max_loc] = max(t_window); % find the peak
        T_peak(i) = max_loc+start-1; % store its location wrt the whole ecg

        % Then compute the onset and the offset identifying the main points of
        % inflections by using the slope in the T search window
        % we will work on the filtered signal to highlight only inflections
        % of interest
        M = 7; % order of the lowpass filter
        B = 1/M*ones(M,1);
        if length(t_window)>M*3
            filtered_t_window= filtfilt(B,1,t_window);
        else 
            filtered_t_window=t_window;
        end
        slope_t_window = diff(filtered_t_window); 

        % Define a threshold for the slope as a percetange of the mean
        % slope respectively on the two sides of the 
        % wave with respect to the T peak 
        % and find the onset and the offset as the points where the slope
        % overcomes the threshold in the two sides
        
        emp_ptg = 0.5; % empirical percentage
        
        % onset
        if max_loc<length(slope_t_window)
            stop_2 = max_loc;
        else 
            stop_2 = length(slope_t_window);
        end 
        slope_beforeT = slope_t_window(1:stop_2);
        on_thr = mean(slope_beforeT)*emp_ptg;
        on_loc = find_first_rise(slope_beforeT, on_thr, 1);
        T_onset(i) = on_loc+start-1;

        % offset
        slope_afterT = slope_t_window(max_loc:end);
        of_thr = mean(slope_afterT)*emp_ptg;
        of_loc = find_first_rise(slope_afterT, of_thr, length(slope_afterT));
        T_offset(i) = of_loc+T_peak(i)-1;   

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
        if (i>1) 
            p_window_length = round((2/3)*(QRS_onset(i)-T_offset(i-1))); 
        end 
        start = QRS_onset(i)-p_window_length; stop= QRS_onset(i);
        if start<1
            start=1;
        end
        p_window = ecg(start:stop);

        % compute the P peak as the maximum value in the P search window
        [~, max_loc] = max(p_window); % find the peak
        P_peak(i) = max_loc+start-1; % store its location wrt the whole ecg

        % Then compute the onset and the offset identifying the main points of
        % inflections by using the slope in the P search window
        % we will work on the filtered signal to highlight only inflections
        % of interest
        M = 7; % order of the lowpass filter
        B = 1/M*ones(M,1);
        if length(p_window)>M*3
            filtered_p_window= filtfilt(B,1,p_window);
        else 
            filtered_p_window=p_window;
        end
        slope_p_window = diff(filtered_p_window); 

        % Define a threshold for the slope as a percetange of the mean
        % slope respectively on the two sides of the 
        % wave with respect to the P peak 
        % and find the onset and the offset as the points where the slope
        % overcomes the threshold in the two sides
        
        emp_ptg = 0.2; % empirical percentage
        
        % onset
        if max_loc<length(slope_p_window)
            stop_2 = max_loc;
        else 
            stop_2 = length(slope_p_window);
        end 
        slope_beforeP = slope_p_window(1:stop_2);
        on_thr = mean(slope_beforeP)*emp_ptg;
        on_loc = find_first_rise(slope_beforeP, on_thr, 1);
        P_onset(i) = on_loc+start-1;

        % offset
        slope_afterP = slope_p_window(max_loc:end);
        of_thr = mean(slope_afterP)*emp_ptg;
        of_loc = find_first_rise(slope_afterP, of_thr, length(slope_afterP));
        P_offset(i) = of_loc+P_peak(i)-1;   

        %figure; hold on; plot(p_window); plot(filtered_p_window); plot(slope_p_window); yline(0); yline(on_thr); yline(of_thr); xline(on_loc); xline(of_loc+max_loc); plot(max_loc, p_window(max_loc), '*r'); hold off; legend({'original signal','filtered signal','slope of filtered signal'})

    end

end 
