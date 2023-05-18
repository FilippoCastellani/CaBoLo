function generate_af_cumulative_distribution(dataset_folder, patient_limiter)
    % This function generates the cumulative distribution of the AF
    % values for the given dataset.
    % In order to do so:
    % 1) It loads the AF samples from the dataset folder cicling over each patient
    % 2) It extracts the RR series from the patient's ECG
    % 3) It computes the value RR(i)/RR(i-1)
    % 4) It tabulates the values and computes the cumulative distribution
    % 5) Fit a polynomial curve over all cumulative distributions
    % 6) It plots the fitted cumulative distribution

    % 1) Load the AF samples from the dataset folder cicling over each patient
    
    % removes from the list the samples that are not AF
    % open the reference file containing the list of the AF patients
    reference_filepath = dataset_folder + "REFERENCE.csv";
    fid = fopen(reference_filepath, 'r');
    % read the file
    reference = textscan(fid, '%s %s', 'Delimiter', ',');
    % close the file
    fclose(fid);
    % get the list of the AF patients denoted with 'A'
    labels = reference{2};
    % get the list of the patients
    patients_names = reference{1};
    % get the indices of the AF patients
    af_indices = strcmp(labels, 'A');
    % get the names of the AF patients
    af_patients_names = patients_names(af_indices);

    % get the number of patients
    num_patients = length(af_patients_names);
    if patient_limiter ~= -1
        num_patients = patient_limiter;
    end
    
    % Cycle over the patients
    for i = 1:num_patients
        disp(['Processing patient #: ' num2str(i)]);
        % Load the patient's signal
        % Let's pick a patient
        SelectedPatient = af_patients_names(i);
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
        AF = RR(2:end)./RR(1:end-1);

        % 4) Tabulate the values and compute the cumulative distribution
        % Tabulate the values
        table = tabulate(AF);
        % tabulate will return a matrix with 3 columns:
        % 1st column: the values sorted 
        % 2nd column: the number of occurrences of each value
        % 3rd column: the percentage of occurrences of each value
        % We are interested in the 1st and 3rd columns
        AF_values = table(:,1);
        AF_counts = table(:,3);

        % Compute the cumulative distribution
        AF_cumulative_distribution = cumsum(AF_counts);
        % Store the cumulative distribution in a cell array along with the AF values for later averaging
        AF_cumulative_distributions{i} = AF_cumulative_distribution;
        AF_values_arrays{i} = AF_values;
    end

    % EXTRA STEP: Plot the cumulative distributions of the AF values for each patient
    % Cycle over the patients
    figure
    for i = 1:num_patients
        % Plot the cumulative distribution
        plot(AF_values_arrays{i}, AF_cumulative_distributions{i})
        hold on
        xlabel('AF values')
        ylabel('Cumulative distribution')
        title('Cumulative distribution of the AF values')
        grid on
    end

    % 5) Fit a polynomial curve over all cumulative distributions saved in the cell array
    
    % join all cumulative distributions in a column vector and all AF values in another column vector
    AF_cumulative_distributions_all=[];
    AF_values_all=[];
    for i = 1:num_patients
        AF_cumulative_distributions_all = [AF_cumulative_distributions_all; AF_cumulative_distributions{i}];
        AF_values_all = [AF_values_all; AF_values_arrays{i}];
    end


    % fit a polynomial curve over all cumulative distributions
    p = polyfit(AF_values_all, AF_cumulative_distributions_all, 5);
    scatter(AF_values_all, AF_cumulative_distributions_all)
    hold on


    % 6) Plot the fitted cumulative distribution
    % figure
    % plot the fitted curve
    x = linspace(0.5, 2.5, 1000);
    y = polyval(p, x);
    plot(x, y)
    %title('Fitted cumulative distribution of the AF values')
    %xlabel('AF values')
    %ylabel('Cumulative distribution')
    grid on
    hold off

end