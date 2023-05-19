function [RR_RR_cumulative_distribution,RR_RR_values] = get_cumulative_distribution(patient_name, dataset_folder);
        % This function computes the cumulative distribution of the RR(i)/RR(i-1) values
        % of a given patient

        % INPUT:
        % patient_name: the name of the patient
        % dataset_folder: the path to the dataset folder

        % OUTPUT:
        % RR_RR_cumulative_distribution: the cumulative distribution of the RR(i)/RR(i-1) values (y-axis of the cumulative distribution)
        % RR_RR_values: the values of the RR(i)/RR(i-1) values (x-axis of the cumulative distribution)


        % 1) Load the patient's signal
        % Load the patient's signal
        % Let's pick a patient
        SelectedPatient = patient_name;
        % Let's build the path to the patient's folder
        SelectedPatientPath=[dataset_folder cell2mat(SelectedPatient)];
        % Reading selected patient infos
        [signal, Fs, time_axis] = load_patient(SelectedPatientPath);

        % 2) Extract the RR series from the patient's ECG
        ecg_cleaned = preprocessing(signal, Fs, time_axis, 0);
        % R peaks detection with Pan-Tompkin's algorithm
        [~, Rpeak_index, ~]= pan_tompkin(ecg_cleaned,Fs,0);
        % RR series extraction
        RR = diff(Rpeak_index)/Fs*1000; % in ms

        % 3) Compute the value RR(i)/RR(i-1)
        RR_RR = RR(2:end)./RR(1:end-1);

        % 4) Tabulate the values and compute the cumulative distribution
        % Tabulate the values
        table = tabulate(RR_RR);
        % tabulate will return a matrix with 3 columns:
        % 1st column: the values sorted 
        % 2nd column: the number of occurrences of each value
        % 3rd column: the percentage of occurrences of each value
        % We are interested in the 1st and 3rd columns
        RR_RR_values = table(:,1);
        RR_RR_counts = table(:,3);

        % Compute the cumulative distribution
        RR_RR_cumulative_distribution = cumsum(RR_RR_counts);
end