function [RR_RR_cumulative_distribution,RR_RR_values] = get_cumulative_distribution_from_signal(RR);
        % This function computes the cumulative distribution of the RR(i)/RR(i-1) values
        % of a given patient

        % INPUT:
        % signal: the signal of the patient
        % Fs: the sampling frequency of the signal
        % time_axis: the time axis of the signal
        % RR: the rr series previously computed

        % OUTPUT:
        % RR_RR_cumulative_distribution: the cumulative distribution of the RR(i)/RR(i-1) values (y-axis of the cumulative distribution)
        % RR_RR_values: the values of the RR(i)/RR(i-1) values (x-axis of the cumulative distribution)

        % 1) Compute the value RR(i)/RR(i-1)
        RR_RR = RR(2:end)./RR(1:end-1); % according to the reference paper, we should use the RR(i)/RR(i-1) values

        % 2) Tabulate the values and compute the cumulative distribution
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
        RR_RR_cumulative_distribution = cumsum(RR_RR_counts); % cumulative sum of the percentages
end