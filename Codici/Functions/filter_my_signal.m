function [y,b,a] = filter_my_signal(signal, fs)
    % This function filters the signal using a bandpass filter
    % Input: signal: the signal to be filtered
    %        fs: the sampling frequency
    % Output: y: the filtered signal
    %         b: the numerator coefficients of the filter
    %         a: the denominator coefficients of the filter

    % Filter settings
    wp = [0.5 60];   %passband freq
    ws = [0.3 80];   %stopband freq

    w1 = wp/(fs/2);   %passband normalized
    w2 = ws/(fs/2);   %stopband normalized

    rp = 0.2;        %passband ripple admissible
    rs = 40;         %stopband attenuation

    [n,wn] = buttord(w1,w2,rp,rs);        %computing optimal settings
    [b,a] = butter(n,wn,'bandpass');      %getting the filter coeff.

    % Filtering the signal
    y = filtfilt(b,a,signal);
end