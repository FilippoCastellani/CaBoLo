function [AFEv, Radius, ShannonEntropy, KSTestValue] = get_AF_features(recordName, ecg, fs, t, visuals, Rpeak_index)
    % This function calculates Atrial Fibrillation features from the ECG signal
    %
    % - [ ] AFEv 
    % - [ ] Radius [[AFEv#Radius sub-feature]]
    % - [ ] Shannon Entropy
    % - [ ] Kolmogorov-Smirnov Test Value
    %
    
    %% AFEv
    % In order to calculate the AFEv, the following steps are taken:
    % Create RR intervals from the R-peak locations
    rr_series = (diff(Rpeak_index))*(1/fs)*1000;               % in ms
    rr_series_seconds = (diff(Rpeak_index)*(1/fs));            % in sec

    drr_series = diff(rr_series);                              % in ms
    drr_series_seconds = diff(rr_series_seconds);              % in sec

    % Calculate the histogram of the RR intervals
    X1 = drr_series(1:end-1);                                  % in ms
    X2 = drr_series(2:end);                                    % in ms

    Lorenz_X_boundary = 1600;                                  % in ms
    Lorenz_Y_boundary = 1600;                                  % in ms
    
    X_edge= -Lorenz_X_boundary:30:Lorenz_X_boundary;
    Y_edge= -Lorenz_Y_boundary:30:Lorenz_Y_boundary;
    p_hist = flip(hist3([X1' X2'],'ctrs',{X_edge Y_edge}));

    if visuals
        figure()
        hist3([X1' X2'],'CdataMode','auto');
    end
    % Compute AFEv
    [OriginCount,IrrEv,PACEv,AnisotropyEv,DensityEv,RegularityEv] = get_AFEv_metrics(drr_series_seconds',X_edge*(1/1000),1);

    AFEv = IrrEv - OriginCount - 2*PACEv;

    % if visuals is true, plot the histogram
    if visuals
        figure()
        p_im = image(p_hist, 'CDataMapping','scaled');
        colormap('jet')
        colorbar
        title('Histogram of RR intervals')
        xlabel('RR_{n} (ms)')
        ylabel('RR_{n+1} (ms)')
    end
    
    %% Radius
    % Radius is a sub-feature 
    % This is a feature computed from the Lorenz plot and is defined as the
    % radius of the smallest circle that encloses at least 60% of the points 
    % in the Lorenz plot.

    % need to look for the smallest circle that encloses at least 60% of the points
    % starting from the biggest possible circle and then reducing the radius
    % until the condition is met
    Radius = 0;

    ShannonEntropy=0; 
    KSTestValue=0;
        
    

    
