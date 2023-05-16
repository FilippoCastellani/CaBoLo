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
            x = ecg(onsets(i)-1:onsets(i)+1);
            y = ecg(offsets(i+1)-1:offsets(i+1)+1);
        else
            % Normalizaion of ECG signal between [-1 1] to compute
            % the correlation on the morphological information only
            % of the QRS complexes, discarding the ammplitude information.
            ecg_normalized = 2 * (ecg - min(ecg)) / (max(ecg) - min(ecg)) - 1;
            % ecg_normalized = ecg;
            % Extract the two signals
            x = ecg_normalized(onsets(i):offsets(i));
            y = ecg_normalized(onsets(i+1):offsets(i+1));
        end
        % Compute correlation
        corr = xcorr(x, y);
        
        % Find max value of correlation
        [~, max_index] = max(corr);
        
        % Add max value to the similarity vector (mean computed outside)
        similarity_vector(i) = corr(max_index);
    
    end

    % Normalize the Similarity vector between [0 1]
    similarity_vector = (similarity_vector - min(similarity_vector)) / (max(similarity_vector) - min(similarity_vector));
    
end