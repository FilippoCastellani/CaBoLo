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
% t: time axis for visualization
% Rpeak_index: R peaks detection with Pan-Tompkin's algorithm
% visuals: flag for visualization

%%

% Get fiducial points of interest
[~, P_onset, ~, ~, ~, T_offset, ~, ~, R_peak, QRS_onset, QRS_offset]= get_fiducial_points(ecg, Rpeak_index, fs);

%% QRS similarity 

% Find max length of QRS complexes
max_len = max((QRS_offset(1:end) - QRS_onset(1:end))+1);

% Initialize the matrix for QRS complexes
QRS_matrix = zeros(length(QRS_onset), max_len);

% Fill QRS matrix
for i = 1:length(QRS_onset)
    % Padding complexes shorter than the maximum length
    qrs = ecg(QRS_onset(i):QRS_offset(i));
    padsize = max_len - length(qrs);
    padded_qrs = padarray(qrs, [0, padsize], 0, 'post');
    % Assign complexes in the matrix
    QRS_matrix(i,:) = padded_qrs;
end

% Get the ratio of high similarity beats
[QRS_similarity, QRS_similarity_matrix] = get_beat_similarity(QRS_matrix);

%% R Amplitude similarity

% Choose number of samples to create the window for the R amplitude
n = 1;
% Initialize matrix of R_peak windows
r_matrix = zeros(length(R_peak),(2*n)+1);

% Fill the matrix
for i = 1:length(R_peak)
    r_window = ecg(R_peak(i)-n:R_peak(i)+n);
    r_matrix(i,:) = r_window;
end

% Get the ratio of high similarity beats
[R_similarity, R_similarity_matrix] = get_beat_similarity(r_matrix);

%% Ratio of High Beats Similarity

% Compute High Beats Similarity
% Take both information making the product of QRS and R similarity
%similarity_matrix = QRS_matrix .* r_matrix;

joint_bin_matrix = QRS_similarity_matrix .* R_similarity_matrix;
joint_high_similarity = sum(sum(joint_bin_matrix));

% Get the ratio of high similarity beats
Ratio_HBS = joint_high_similarity / ((size(joint_bin_matrix,1)^2) - size(joint_bin_matrix,1))/2;

%% Signal Qualify Index

% Initialize the vector
SQindex_vector = zeros(length(P_onset)-1, 1);

% Signal Qualify of each beat computed as the difference between the
% current P-wave onset amplitude and the previous T-wave offset amplitude

for i = 2:(length(P_onset)-1)
    SQindex_vector(i) = ecg(P_onset(i))-ecg(T_offset(i-1));
end

% Signal Qualify Index of the whole recording as the 
% standard deviation of the SQindex of each beat
SQindex = std(SQindex_vector);

end