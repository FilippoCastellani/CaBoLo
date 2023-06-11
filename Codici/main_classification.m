%% Pre-ops

% Clearing previous data and closing all the windows if any
clc; close all; clear;

% Setting the environment
[PROJECT_DIRECTORY, DatasetFolderPath, DatasetFolderPrefix] = set_environment();

%% Load data 
% load the .csv file containing the features matrix along with the labels
% we need to load both the training and the test data

DATASET_TRAIN = readtable('Data/train_features_complete.csv');

X_TRAIN = DATASET_TRAIN(:, 1:end-1);
Y_TRAIN = DATASET_TRAIN(:, end);

DATASET_TEST = readtable('Data/test_features_complete.csv');
X_TEST = DATASET_TEST(:, 1:end-1);
Y_TEST = DATASET_TEST(:, end);

%% We are going to train a decision tree model 

% Create the hyperparameter optimization options and performing grid search
hyperparameter_options= struct('Optimizer', 'gridsearch', 'ShowPlots', true);
hyperparameters = struct('MaxNumSplits', [5, 10, 15, 20 ,25 ,30, 35], 'MinLeafSize', [1, 5, 10, 15 ,20]);
tree = fitctree(X_TRAIN, Y_TRAIN, 'OptimizeHyperparameters', hyperparameters, 'HyperparameterOptimizationOptions', hyperparameter_options);


% Training the model
% tree_model = fitctree(X_TRAIN, Y_TRAIN, 'OptimizeHyperparameters','all',...
%    'HyperparameterOptimizationOptions',struct('Kfold',5,'Optimizer','randomsearch'));

%% 
% Predicting the labels for the test data
Y_TEST_PREDICTED = predict(tree_model, X_TEST);
error_test = loss(tree_model, X_TEST, Y_TEST_PREDICTED);
conf_mat = confusionmat(char(Y_TEST.label), char(Y_TEST_PREDICTED));
accuracy = sum(diag(conf_mat))/sum(conf_mat, 'all');

%% 
% Now we are going to train a model using the AdaBoost algorithm
% The AdaBoost algorithm is an algorithm that combines multiple weak
% classifiers to create a strong classifier. A weak classifier is simply a
% classifier that performs poorly, but performs better than random guessing
% (i.e. it has an accuracy of > 50%). The AdaBoost algorithm combines
% multiple weak classifiers to create a strong classifier.

% Training the model
%adaboost_model = fitcensemble(X_TRAIN, Y_TRAIN, 'OptimizeHyperparameters','all');

adaboost_model = fitcensemble(X_TRAIN, Y_TRAIN, 'Method','AdaBoostM2',...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',struct('Kfold',5,'Optimizer','randomsearch'));

%%
% Predicting the labels for the test data
Y_TEST_PREDICTED = predict(adaboost_model, X_TEST);
error_test = loss(adaboost_model, X_TEST, Y_TEST_PREDICTED);
conf_mat = confusionmat(char(Y_TEST.label), char(Y_TEST_PREDICTED));
accuracy = sum(diag(conf_mat))/sum(conf_mat, 'all');

