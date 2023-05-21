function output_signal = check_and_correct_inversion(signal, Rpeaks_indices, Fs, visuals)
% This function checks if the signal is inverted and reverses it if it is.
% It checks it through verifying if the Rpeaks are local maxima or minima.
% If 80% of the Rpeaks are local minima, the signal is inverted.

% Inputs:
%   signal: the signal to be checked
%   Rpeaks_indices: the indices of the Rpeaks
%   Fs: the sampling frequency
%   visuals: a boolean variable to determine if the user wants to see the signal before and after the inversion with the Rpeaks marked

% Outputs:
%   output_signal: the signal after the inversion

    % Check if the signal is inverted
    inverted = false;
    inverted_Rpeaks = 0;

    % iterate through the Rpeaks
    for i = 1:length(Rpeaks_indices)
        % Check if the Rpeak is a local minimum
        if Rpeaks_indices(i) > 1 && Rpeaks_indices(i) < length(signal) % Check if the Rpeak is not at the beginning or the end of the signal
            if signal(Rpeaks_indices(i)) < signal(Rpeaks_indices(i)-1) && signal(Rpeaks_indices(i)) < signal(Rpeaks_indices(i)+1)
                inverted_Rpeaks = inverted_Rpeaks + 1;
            end
        end
    end

    % If 80% of the Rpeaks are local minima, the signal is inverted
    if inverted_Rpeaks/length(Rpeaks_indices) > 0.8
        inverted = true;
    end

    % If the signal is inverted, reverse it
    if inverted
        output_signal = -signal;
    else
        output_signal = signal;
    end
    
    % Plot the signal before and after the inversion with the Rpeaks marked
    if visuals
        figure;
        subplot(2,1,1);
        plot(signal);
        hold on;
        plot(Rpeaks_indices, signal(Rpeaks_indices), 'r*');
        title('Signal before the check');
        xlabel('Samples');
        ylabel('Amplitude');
        subplot(2,1,2);
        plot(output_signal);
        hold on;
        plot(Rpeaks_indices, output_signal(Rpeaks_indices), 'r*');
        title('Signal after the check');
        xlabel('Samples');
        ylabel('Amplitude');
    end

end