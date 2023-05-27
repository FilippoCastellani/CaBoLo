function generate_af_cumulative_distribution(dataset_folder, patient_limiter, visuals)
    % This function generates the cumulative distribution of the AF
    % values for the given dataset.

    % INPUT:
    % dataset_folder: the path of the folder containing the dataset
    % patient_limiter: the number of patients to be considered. If set to -1, all patients are considered
    % visuals: if set to 1, the cumulative distributions of the AF values for each patient are plotted

    % OUTPUT:
    % The function saves the fitted curve in a .mat file

    % In order to do so:
    % 1) It loads the AF samples from the dataset folder cicling over each patient
    % 2) It extracts the RR series from the patient's ECG
    % 3) It computes the value RR(i)/RR(i-1)
    % 4) It tabulates the values and computes the cumulative distribution
    % 5) Fit a sigmoidal curve over all cumulative distributions
    % 6) It plots the fitted cumulative distribution
    % 7) It saves the fitted curve

    % 1) Load the AF samples from the dataset folder cicling over each patient
    
    % Open the reference file containing the labels and the names of the patients
    reference_filepath = dataset_folder + "AF_distribution_patients_reference.csv";
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

    % if the patient_limiter is set to -1, consider all patients
    num_patients = length(af_patients_names);
    if patient_limiter ~= -1            % if the patient_limiter is not set to -1
        num_patients = patient_limiter; % set the number of patients to the patient_limiter
    end
    
    % Cycle over the patients until the patient_limiter is reached
    for i = 1:num_patients
        disp(['Processing patient #: ' num2str(i)]);
        % Load the patient's signal
        % Let's pick a patient
        SelectedPatient = af_patients_names(i);

        % Step 2, 3, 4 are inside the following function
        [AF_cumulative_distribution,AF_values] = get_cumulative_distribution(SelectedPatient, dataset_folder);
        
        % Store the cumulative distribution in a cell array along with the AF values for later averaging
        AF_cumulative_distributions{i} = AF_cumulative_distribution;
        AF_values_arrays{i} = AF_values;
    end

    if (visuals)
        % EXTRA STEP: Plot the cumulative distributions of the AF values for each patient
        % Cycle over the patients
        % plot has the legend of patient number
        figure
        for i = 1:num_patients
            % Plot the cumulative distribution
            plot(AF_values_arrays{i}, AF_cumulative_distributions{i}, 'DisplayName', ['Patient #: ' num2str(i)]);
            hold on
            xlabel('AF values')
            ylabel('Cumulative distribution')
            title('Cumulative distribution of the AF values')
            grid on
        end
        legend('A00004', 'A00725', 'A06213', 'A06911', 'A07666', 'A07927', 'A08227', 'A08012', 'A04815');
    end

    % 5) Fit a sigmoidal curve over all cumulative distributions saved in the cell array
    
    % join all cumulative distributions in a column vector and all AF values in another column vector
    AF_cumulative_distributions_all=[];
    AF_values_all=[];
    for i = 1:num_patients
        AF_cumulative_distributions_all = [AF_cumulative_distributions_all; AF_cumulative_distributions{i}];
        AF_values_all = [AF_values_all; AF_values_arrays{i}];
    end
    
    % Logistic function definition and fitting
    xdata= AF_values_all';
    ydata= AF_cumulative_distributions_all';
    
    fun = @(p,xdata) p(1) ./ ( 1 + exp(-1*p(2)*(xdata-p(3))) );
    p0 = [1, 1, 0.5];
    
    p = lsqcurvefit(fun,p0,xdata,ydata);
    times = linspace(min(xdata),max(xdata));
    plot(xdata,ydata,'ko',times,fun(p,times),'b-')
    
    % 6) Plot the fitted cumulative distribution
    title('Data and Fitted Curve')
    xlabel('AF values')
    ylabel('Cumulative distribution')
    grid on
    hold off

    %7) Save the fitted curve
    save('fitted_cumulative_distribution_AF.mat', 'p');

end