function split_training_test(dataset_folder, name_training_folder, name_test_folder)

    training_folder = fullfile(dataset_folder, name_training_folder);
    test_folder = fullfile(dataset_folder, name_test_folder);
    mkdir(training_folder);
    mkdir(test_folder);

    classes = {'N', 'A', 'O', '~'};

    % CSV file path
    reference_filepath = dataset_folder + "REFERENCE.csv";
    
    % Read CSV
    table = readtable(reference_filepath, "ReadVariableNames", false);
    
    % Decide percentage of patient for training
    split_training = 70;
    
    % folder path of training and test
    training_path = dataset_folder + name_training_folder;
    test_path = dataset_folder + name_test_folder;
    
    % For each class
    for i = 1:length(classes)

        classe = classes{i};
        
        % Select patient belonging to the class
        class_patients = table(table.Var2 == classe, :);
        
        % Calculate number of patient for training set
        num_patient = size(class_patients, 1);
        num_patient_training = floor(split_training / 100 * num_patient);
        
        % Shuffle patient order
        class_patients = class_patients(randperm(num_patient), :);
        
        % Select patient for training
        training_patients = class_patients(1:num_pazienti_training, :);
        training_patients_codes = training_patients.Var1;
        
        % Copy .hea and .mat files belonging to training patients
        % into training folder
        for j = 1:length(training_patients_codes)
            patient_code = training_patients_codes{j};
            
            % Copy .hea file
            original_hea_data = fullfile(dataset_folder, [patient_code '.hea']);
            destination_path_hea = fullfile(test_path, [patient_code '.hea']);
            copyfile(original_hea_data, destination_path_hea);
            
            % Copy .mat file
            original_mat_data = fullfile(dataset_folder, [patient_code '.mat']);
            destination_path_mat = fullfile(training_path, [patient_code '.mat']);
            copyfile(original_mat_data, destination_path_mat);
        end
        
        % Select patient for test set
        test_patients = class_patients(num_patient_training+1:end, :);
        test_patients_codes = test_patients.Var1;
        
        % Copy .hea and .mat files belonging to test patients
        % into test folder
        for j = 1:length(test_patients_codes)
            patient_code = test_patients_codes{j};
            
            % Copy .hea files
            original_hea_data = fullfile(dataset_folder, [patient_code '.hea']);
            destination_path_hea = fullfile(test_path, [patient_code '.hea']);
            copyfile(original_hea_data, destination_path_hea);
            
            % Copy .mat files
            original_mat_data = fullfile(dataset_folder, [patient_code '.mat']);
            destination_path_mat = fullfile(test_path, [patient_code '.mat']);
            copyfile(original_mat_data, destination_path_mat);
        end
    end

end