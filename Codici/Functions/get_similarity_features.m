function [QRS_similarity, R_similarity, HighBeats_similarity, SQindex] = get_similarity_features(ecg, fs, Rpeak_index)

% This function calculates the Similarity Features: Similarity index between beats

% OUTPUT

% [X] - Similarity index of QRS (QRS_similarity)
% [X] - Similarity index of R amplitude (R_similarity)
% [ ] - Ratio of high similarity beats (HighBeats_similarity)
% [ ] - Signal Qualify index (SQindex)

% INPUT

% ecg: ECG recording
% fs: sampling frequency
% Rpeak_index: R peaks detection with Pan-Tompkin's algorithm

%%

% Get fiducial points of interest
[~, ~, ~, ~, ~, ~, ~, ~, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs);

% Compute similarity between QRS complex
QRS_similarity = get_correlation(ecg, QRS_onset, QRS_offset, 0);

% Compute similarity between R peaks
R_similarity = get_correlation(ecg, R_peak(1:end-1), R_peak(2:end), 1);



end