%% Preprocessing

function clean_ecg = preprocessing(ecg, fs, t, visuals)

    fn = fs/2;
    n= 3;                %filter order
    fcutlow= 1.5;           %low cut frequency in Hz
    fcuthigh= 50;         %high cut frequency in Hz
    Wn = [fcutlow fcuthigh]/fn; % normlized passband
    
    [b,a] = butter(n,Wn,'bandpass');
    bpfecg = filtfilt(b,a,ecg)'; %bandpass filtered ecg

    clean_ecg = bpfecg;
    
    % visuals
    if (visuals)
        figure; 
        [H,w] = freqz(b,a,n);
        tlim = [0 10]; amplim= [-1 2];
        subplot(3,1,1); plot(t,ecg);  ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim); ylim(amplim);
        subplot(3,1,2); hold on; plot(t,bpfecg); hold off; legend([strcat("bandpass (", num2str(fcutlow), " , ",num2str(fcuthigh) ,")")]); ylabel('Amplitude (mV)'); xlabel('Time (s)'); xlim(tlim);
        subplot(3,1,3); plot((w/pi)*fn,20*log10(abs(H))); ylabel('Power'); xlabel('Frequency');
        title('IIR Bandpass ECG Filtering');
    end 
end 