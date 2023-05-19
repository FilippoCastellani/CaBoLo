clc;close all;clear;

% Load the CSV file
dataset_folder = 'C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/Dataset/training2017/';
reference_filepath = dataset_folder + "REFERENCE.csv";
data = readtable(reference_filepath','ReadVariableNames', false); 
data.Properties.VariableNames = {'FileName', 'Label'};

% Extract the file names and labels
fileNames = data.FileName; 
labels = data.Label; 

% Perform a stratified partition based on the labels
cvp = cvpartition(labels, 'Holdout', 0.2, 'Stratify', true); 

% Generate logical indices for the training and testing sets
trainIndices = training(cvp);
testIndices = test(cvp);

% Split the data into training and testing sets
trainData = data(trainIndices, :);
testData = data(testIndices, :);

% Save the training and testing sets as separate CSV files
writetable(trainData, 'train_data.csv');
writetable(testData, 'test_data.csv');