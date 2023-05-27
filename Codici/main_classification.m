%% Pre-ops

% Clearing previous data and closing all the windows if any
clc; close all; clear;

% Setting the environment
[PROJECT_DIRECTORY, DatasetFolderPath, DatasetFolderPrefix] = set_environment();

%% Load data 
% load the .csv file containing the features matrix along with the labels

DATASET = readtable('features_PROVA_TEST.csv');

X = DATASET(:, 1:end-1);
Y = DATASET(:, end);

%% 
% For each model define the range of value in which the hyperparameters will be searched 
% and the number of iterations for the search (considering that we will be using a random search)

% Define the number of folds = 5 for the cross-validation 

% train a model using the whole training data in order to compare it by the end with the performance on the test data.