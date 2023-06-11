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

% drop the patient_id column as it is not needed and it is not a feature + would cause issues
X_TRAIN.patient_id = [];
X_TEST.patient_id = [];

%%
% As in the reference paper, we will use the fitensemble function to train the
% adaboost classifier, and will find the optimal hyperparameters using
% the hyperparameter optimization function.

% the key parameter is the number of weak learners, which will be obtained
% using a 100 fold cross validation.

DEBUGGING = 0;

if DEBUGGING
    clc;
    k = 5;
    weak_learners_values = [10 20];
else
    k = 100;
    weak_learners_values = [100 500 1500];
end

cv = cvpartition(Y_TRAIN{:,1}, 'KFold', k, 'Stratify', true);

accuracy = zeros(cv.NumTestSets, length(weak_learners_values));

for j = 1:length(weak_learners_values)
    % loop through the folds
    for i = 1:cv.NumTestSets

        % measure time taken for each fold
        tic;

        % get the training and test indices
        trainIdx = cv.training(i);
        testIdx = cv.test(i);
        
        % get the training and test data
        X_TRAIN_CV = X_TRAIN{trainIdx, :};
        Y_TRAIN_CV = Y_TRAIN{trainIdx, :};
        X_TEST_CV = X_TRAIN{testIdx, :};
        Y_TEST_CV = Y_TRAIN{testIdx, :};

        disp (['Fold ' num2str(i) ' of ' num2str(cv.NumTestSets) '...']);
        percent_up_to_now = (i+(j-1)*cv.NumTestSets)/(cv.NumTestSets*length(weak_learners_values))*100;
        disp ([ 'Overall Progress: ' num2str(percent_up_to_now) '%']);

        % train the model
        model = fitensemble(X_TRAIN_CV, Y_TRAIN_CV, 'AdaBoostM2', weak_learners_values(j), 'Tree');

        % predict the labels
        Y_PREDICTED_CV = predict(model, X_TEST_CV);

        % calculate the accuracy
        accuracy(i,j) = sum(char(Y_PREDICTED_CV) == char(Y_TEST_CV)) / length(Y_TEST_CV);
        
        % measure time taken for each fold
        toc;
        % comunicate the time taken for each k-fold and estimated time left (rounded to seconds)
        disp(['Estimated time left: for current k-fold ' num2str(round((toc*(cv.NumTestSets-i)))) ' seconds.']);
        
    end
end
% find the optimal number of weak learners
[~, idx] = max(mean(accuracy, 1));

% train the model with the optimal number of weak learners
model = fitensemble(X_TRAIN, Y_TRAIN, 'AdaBoostM2', weak_learners_values(idx), 'Tree');

% predict the labels
Y_PREDICTED = predict(model, X_TEST);

% calculate the accuracy
best_accuracy = sum(char(Y_PREDICTED) == char(Y_TEST.label)) / length(Y_TEST.label);

% calculate the confusion matrix
confusion_matrix = confusionmat(Y_TEST{:,1}, Y_PREDICTED);
    
%% Save the results

% save the results in a .mat file
save('Results/Adaboost.mat', 'model', 'best_accuracy', 'confusion_matrix');

% save the model as a .mat file
save('Models/Adaboost.mat', 'model');


