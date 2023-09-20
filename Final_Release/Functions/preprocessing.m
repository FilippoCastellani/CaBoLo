%% Preprocessing

function [y,b,a] = preprocessing(ecg, fs, t, visuals)
    % This function filters the signal using a bandpass filter
    % Input: ecg: the signal to be filtered
    %        fs: the sampling frequency
    %        t: the time vector of the signal to be filtered
    %        visuals: a flag defining whether to provide plots  or not
    % Output: y: the filtered signal
    %         b: the numerator coefficients of the filter
    %         a: the denominator coefficients of the filter
    
    % Define the passband frequency range
    passbandLow = 1.5; % Hz
    passbandHigh = 50; % Hz
    Wn = [passbandLow, passbandHigh]/(fs/2); % normlized passband
    filterOrder = 3;

    % Design the Butterworth filter
    [b, a] = butter(filterOrder, Wn);

    % Apply the filter to the ECG signal
    % filt filt is used to avoid phase distortion and hence to preserve the morphology of the signal
    filteredECG = filtfilt(b, a, ecg);
    
    % Return a row vector
    y = filteredECG';
    
    % visuals
    if (visuals)

        % Initialize the figure
        figure;
        hold on;
        
        tlim = [0 10]; amplim= [-1 2];

        % Compute the frequency response of the filter
        [H, f] = freqz(b, a, length(ecg), fs);

        subplot(3,1,1); plot(t,ecg);  ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
        title('Original ECG Signal');
        subplot(3,1,2); hold on; plot(t,filteredECG); hold off; legend([strcat("bandpass (", num2str(passbandLow), " , ",num2str(passbandHigh) ,")")]); ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim);
        title(sprintf('Filtered ECG Signal (Order: %d)', filterOrder));
        subplot(3,1,3); plot(f, abs(H)); ylabel('Magnitude'); xlabel('Frequency (Hz)');
        title('Magnitude Response');
        

    end 
end 