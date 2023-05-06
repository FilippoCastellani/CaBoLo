function similarity = get_correlation(ecg, onsets, offsets, flag)

    % This function calculates the correlation of the feature of interest
    % given the ECG recording, and the onset & offset of the given feature.
    
    % flag:
    % 0: QRS correlation
    % 1: R Amplitude correlation, means that onsets and offsets values
    %   are indeed the index of the two consecutive R peaks to correlate.
    
    %%
    % Initialize similarity vector (if we want to return the vector)
    % similarity = zeros(length(onsets)-1, 1);
    
    % or we return the mean
    similarity = 0;

    % Calculate correlation between successive QRS complex, or R peaks
    for i = 1:length(onsets)-1

        % Extract the two signals
        if flag
            x = ecg(onsets(i)); 
            y = ecg(offsets(i)); 
        else
            x = ecg(onsets(i):offsets(i));
            y = ecg(onsets(i+1):offsets(i+1));
        end

        % Compute correlation
        corr = xcorr(x, y);

        % Find max value of correlation
        [~, max_index] = max(corr);

        % Add max value to the similarity vector (if mean is computed outside)
        % similarity(i) = corr(max_index);

        % Find similarity index for the recording
        similarity = mean(corr(max_index));
    end
end