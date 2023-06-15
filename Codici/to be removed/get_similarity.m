function similarity_vector = get_similarity(ecg, onsets, offsets, flag)

    % This function calculates the correlation of the feature of interest
    % given the ECG recording, and the onset & offset of the given feature.
    
    % flag:
    % 0: QRS correlation
    % 1: R Amplitude correlation, means that onsets and offsets values
    %   are indeed the index of the two consecutive R peaks to correlate.

    % similarity_vector: similarity index of each beat, between [0 1]

%%
    % Initialize similarity vector 
     similarity_vector = zeros(length(onsets)-1, 1);
    % Normalizaion of ECG signal between [0 1] before computing 
    % the correlation
     ecg_normalized = (ecg - min(ecg)) / (max(ecg) - min(ecg));

%     if flag
%         x = ecg(onsets);
%         y = ecg(offsets);
%         % Calculate correlation coefficient matrix between R amplitudes
%         corr = corrcoef(x,y);
%         % corr(1,1) represents the correlation coefficient between 
%         % the values of R peaks between x vector and itself
%         % coeff(2,2) represents the correlation coefficient between 
%         % the values of R peaks in the y vector and itself 
%         % (in our case, delayed version of x)
%         % corr(2,1) or corr(1,2) represents the correlation coefficient 
%         % between x and y, which are consecutive R peak values in the vector.
%         similarity = corr(1,2);

%    else
    % Calculate correlation between successive QRS complex and R amplitudes
    for i = 1:length(onsets)-1
    
        if flag
            % calculating similarity between consecutive R amplitudes
            % take one sample before and after to create a small window
            x = ecg_normalized(onsets(i)-1:onsets(i)+1);
            y = ecg_normalized(offsets(i+1)-1:offsets(i+1)+1);
        else
            % Extract the two signals
            x = ecg_normalized(onsets(i):offsets(i));
            y = ecg_normalized(onsets(i+1):offsets(i+1));
        end
        % Compute correlation
        corr = xcorr(x, y);
        
        % Normalization of correlation values on the length of the 
        % window of the signal.
        % xcorr applies a padding to the smallest window, so the 
        % normalization is done on the one with the max length.
        normalized_corr = corr/max(length(x),length(y));
        
        % Find max value of correlation
        [~, max_index] = max(normalized_corr);
        
        % Add max value to the similarity vector (mean computed outside)
        similarity_vector(i) = normalized_corr(max_index);
    
    end

    % Normalize the Similarity vector between [0 1]
    % similarity_vector = (similarity_vector - min(similarity_vector)) / (max(similarity_vector) - min(similarity_vector));
    
end