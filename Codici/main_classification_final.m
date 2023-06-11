%% CLASSIFICATION THROUGH ADABOOST

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

% REFERENCE CITATION:
% A decision tree ensemble was trained using the adaBoost.M2 algorithm [16]. 
% The function “fitensemble” in MATLAB was used for fitting a
% decision tree ensemble. 
% The number of trees, the key parameter, was determined from 100 fold crossvalidation.

% OUR APPROACH TO IMPLEMENT THE REFERENCE PAPER:
% As in the reference paper, we will use the fitensemble function to train the
% adaboost classifier, and will find the optimal number of weak learners, 
% which will be obtained using a 100 fold cross validation.

% ACTUALLY: we will use the fitcensemble function, which is the same as
% fitensemble but for classification problems (as in our case):

% Description of fitensemble from Matlab documentation:
% fitensemble can boost or bag decision tree learners or discriminant analysis classifiers. 
% The function can also train random subspace ensembles of KNN or discriminant analysis classifiers.

% NOTICE - IMPORTANT: For simpler interfaces that fit classification and regression ensembles, 
% instead use fitcensemble and fitrensemble, respectively. 

% we will use the 'NumLearningCycles' parameter to specify the number of
% weak learners to use.
% Matlab reference documentation: 

% NumLearningCycles:
% - Number of ensemble learning cycles, specified as the comma-separated pair consisting of 'NumLearningCycles' and a positive integer or 'AllPredictorCombinations'.
% If you specify a positive integer, then, at every learning cycle, 
% the software trains one weak learner for every template object in Learners (which by default is 1).
% Consequently, the software trains NumLearningCycles*numel(Learners) learners. (which means that if we specify 100, we will have 100 weak learners)

% We will use the 'AdaBoostM2' method


DEBUGGING = 1;
visuals= 1;

if DEBUGGING
    clc;
    k = 5;
    weak_learners_values = [20 80 200];
else
    k = 100;
    weak_learners_values = [90 120 200 300];
end

cv = cvpartition(Y_TRAIN{:,1}, 'KFold', k, 'Stratify', true);

accuracy_storage = zeros(cv.NumTestSets, length(weak_learners_values));

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

        model = fitcensemble(X_TRAIN_CV, Y_TRAIN_CV,...
            'Method', 'AdaBoostM2', ...
            'NumLearningCycles', weak_learners_values(j));

        % predict the labels
        Y_PREDICTED_CV = predict(model, X_TEST_CV);

        % calculate the accuracy
        accuracy_storage(i,j) = sum(char(Y_PREDICTED_CV) == char(Y_TEST_CV)) / length(Y_TEST_CV);
        
        % measure time taken for each fold
        toc;
        % comunicate the time taken for each k-fold and estimated time left (rounded to seconds)
        disp(['Estimated time left: for current k-fold ' num2str(round((toc*(cv.NumTestSets-i)))) ' seconds.']);

    end
end
% find the optimal number of weak learners
[~, idx] = max(mean(accuracy_storage, 1));


model = fitcensemble(X_TRAIN, Y_TRAIN,...
    'Method', 'AdaBoostM2',...
    'NumLearningCycles', weak_learners_values(idx));

% predict the labels
Y_PREDICTED = predict(model, X_TEST);

% calculate the accuracy
best_accuracy = sum(char(Y_PREDICTED) == char(Y_TEST.label)) / length(Y_TEST.label);

% calculate the confusion matrix
confusion_matrix = confusionmat(Y_TEST{:,1}, Y_PREDICTED);

if visuals
    % plot the confusion matrix
    % Classes are contained in model.ClassNames property.

    figure;
    confusionchart(confusion_matrix, model.ClassNames);
    title('Confusion Matrix');

    % plot the accuracy for each k-fold
    figure;
    plot(weak_learners_values, accuracy_storage, 'LineWidth', 2);
    title('Accuracy for each k-fold');
    xlabel('Number of weak learners');
    ylabel('Accuracy');
end

%% Save the results

% save the results in a .mat file
file_name = ['Results/Adaboost_' datestr(now,'yyyy_mm_dd_HH_MM_SS') '.mat'];
save(file_name, 'model', 'best_accuracy', 'confusion_matrix', 'weak_learners_values', 'accuracy', 'idx');

%% After importing the model again from the .mat file, we can use it to predict the labels of the test set

% predict the labels
Y_PREDICTED = predict(model, X_TEST);

% calculate the accuracy
accuracy_of_imported_model = sum(char(Y_PREDICTED) == char(Y_TEST.label)) / length(Y_TEST.label);



