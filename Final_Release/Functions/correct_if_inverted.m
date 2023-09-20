function [ecg_checked, inverted] = correct_if_inverted(ecg, prg, t, visuals)

    % Check for inversion
    inverted = false;
    % Further detrend the signal to remove any DC offset
    ecg_detrend = detrend(ecg);

    % Find the max amplitude of the oscillations as the max of the signal in absolute value
    max_amp = max(abs(ecg_detrend));

    % Define the threshold for inversion as a percentage of the max amplitude
    % prg = 0.7; % 70% of the max amplitude
    threshold = prg*max_amp;

    % Count peaks that are above the threshold and below the negative threshold
    samples_above = length(find(ecg_detrend > threshold));
    samples_below = length(find(ecg_detrend < -threshold));

    % Index of inversion
    if samples_below > samples_above
        inverted = true;
    end

    % Invert if inverted 
    if inverted
        ecg_checked = -1*ecg;
    else 
        ecg_checked = ecg;
    end
    
    % visuals
    if (visuals)
        figure; 
        tlim = [0 10]; amplim= [-threshold-1 threshold+1];
        subplot(3,1,1); plot(t,ecg);  ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); title('CHECK FOR INVERSION');
        subplot(3,1,2); hold on; plot(t,ecg_detrend); yline(threshold, 'r'); yline(-threshold, 'r'); ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim); hold off;  
        subplot(3,1,3); plot(t,ecg_checked);  ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); 
        
    end 
end 