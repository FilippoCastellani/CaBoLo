function [QRS_similarity, R_similarity, Ratio_HBS, SQindex] = get_similarity_features(ecg, fs, t, Rpeak_index, visuals)

% This function calculates the Similarity Features: Similarity index between beats

% OUTPUT

% [X] - Similarity index of QRS (QRS_similarity)
% [X] - Similarity index of R amplitude (R_similarity)
% [X] - Ratio of high similarity beats (Ratio_HBS)
% [X] - Signal Qualify index (SQindex)

% INPUT

% ecg: ECG recording
% fs: sampling frequency
% Rpeak_index: R peaks detection with Pan-Tompkin's algorithm

%%

% Get fiducial points of interest
[~, P_onset, ~, ~, ~, T_offset, ~, ~, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs);

% Compute similarity between QRS complex
QRS_similarity_vector = get_similarity(ecg, QRS_onset, QRS_offset, 0);
QRS_similarity = mean(QRS_similarity_vector);

% Compute similarity between R peaks
R_similarity_vector = get_similarity(ecg, R_peak, R_peak, 1);
R_similarity = mean(R_similarity_vector);

% Compute High Beats Similarity
similarity_vector = QRS_similarity_vector .* R_similarity_vector;
threshold_similarity = prctile(similarity_vector, 60);
HighBeats_similarity = 0;
for i = 1:length(similarity_vector)
    if similarity_vector(i) > threshold_similarity
        HighBeats_similarity = HighBeats_similarity + 1;
    end
end

Ratio_HBS = HighBeats_similarity/length(similarity_vector);

% Compute Signal Qualify Index
% Initialize the vector
SQindex_vector = zeros(length(P_onset)-1, 1);
for i = 2:(length(P_onset)-1)
    SQindex_vector(i) = ecg(P_onset(i))-ecg(T_offset(i-1));
end

% Signal Qualify Index as the mean of the SQindex of each beat
SQindex = std(SQindex_vector);

end