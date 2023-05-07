function [AFEv, Radius, ShannonEntropy, KSTestValue] = get_AF_features(ecg, fs, t, Rpeak_index, visuals)
    % This function calculates Atrial Fibrillation features from the ECG signal
    %
    % - [ ] AFEv 
    % - [X] Radius [[AFEv#Radius sub-feature]]
    % - [ ] Shannon Entropy
    % - [ ] Kolmogorov-Smirnov Test Value
    %
    
    %% AFEv
    % In order to calculate the AFEv, the following steps are taken:
    % Create RR intervals from the R-peak locations
    rr_series = (diff(Rpeak_index))*(1/fs)*1000;               % in ms

    drr_series = diff(rr_series);                              % in ms

    % Calculate the histogram of the RR intervals
    X1 = drr_series(2:end);                                    % delta_RR(i-1) in ms
    X2 = drr_series(1:end-1);                                  % delta_RR(i)   in ms

    Lorenz_X_boundary = 580;                                  % in ms
    Lorenz_Y_boundary = 580;                                  % in ms

    bin_lateral_size = 40;                                    % in ms
    
    X_edge= -Lorenz_X_boundary:bin_lateral_size:Lorenz_X_boundary;
    Y_edge= -Lorenz_Y_boundary:bin_lateral_size:Lorenz_Y_boundary;
    p_hist = flip(hist3([X1' X2'],'ctrs',{X_edge Y_edge}));

    if visuals
        % Figure with two subplots: 
        % 1. The former is showing the 3D histogram of the RR intervals 
        %       (by default camera is set from above so to be 2D)
        % 2. The latter is a scatter plot of the RR intervals

        % First Plot
        figure()
        subplot(1,2,1)
        hist3([X1' X2'],'CdataMode','auto','ctrs',{X_edge Y_edge});
        colorbar;
        view(2)                                 % set camera from the top
        title('Histogram of RR intervals')
        xlabel('RR_{n} (ms)')
        ylabel('RR_{n+1} (ms)')
        zlabel('Count')

        % Second Plot
        subplot(1,2,2)
        scatter(X1,X2,'*')
        xlim([-Lorenz_X_boundary Lorenz_X_boundary])
        ylim([-Lorenz_Y_boundary Lorenz_Y_boundary])
        grid on
        grid minor
        title('Scatter plot of RR intervals')
        xlabel('RR_{n} (ms)')
        ylabel('RR_{n+1} (ms)')
    end
    
    % Compute AFEv
    %[OriginCount,IrrEv,PACEv,AnisotropyEv,DensityEv,RegularityEv] = get_AFEv_metrics(drr_series_seconds',X_edge*(1/1000),1, visuals);

    %AFEv = IrrEv - OriginCount - 2*PACEv;
    
    %% Radius
    % Radius is a sub-feature 
    % This is a feature computed from the Lorenz plot and is defined as the
    % radius of the smallest circle that encloses at least 60% of the points 
    % in the Lorenz plot.

    % need to look for the smallest circle that encloses at least 60% of the points
    % starting from the biggest possible circle and then reducing the radius
    % until the condition is met
    Radius = 0;

    % find the biggest circle that encloses at least 60% of the points
    high_resolution_bin_lateral_size = 10;
    high_resolution_X_edge= -Lorenz_X_boundary:high_resolution_bin_lateral_size:Lorenz_X_boundary;
    high_resolution_Y_edge= -Lorenz_Y_boundary:high_resolution_bin_lateral_size:Lorenz_Y_boundary;
    high_resolution_p_hist = flip(hist3([X1' X2'],'ctrs',{high_resolution_X_edge high_resolution_Y_edge}));

    figure()
    while Radius < Lorenz_X_boundary
        Radius = Radius + high_resolution_bin_lateral_size;
        [x,y] = meshgrid(-Lorenz_X_boundary:high_resolution_bin_lateral_size:Lorenz_X_boundary);
        mask = x.^2 + y.^2 <= Radius^2;
        % mask = mask(1:end-1,1:end-1);
        image(mask*255)

        % calculate the percentage of points that are inside the circle
        points_inside_circle = sum(sum(mask.*high_resolution_p_hist));
        percentage_points_inside_circle = points_inside_circle/sum(sum(high_resolution_p_hist));

        if percentage_points_inside_circle >= 0.6
            break
        end
    end

    if visuals
        % Plot the Lorenz plot with the circle that encloses at least 60% of the points
        figure()
        scatter(X1,X2,'*')
        hold on
        viscircles([0 0],Radius,'Color','r');
        xlim([-Lorenz_X_boundary Lorenz_X_boundary])
        ylim([-Lorenz_Y_boundary Lorenz_Y_boundary])
        grid on
        grid minor
        title('Lorenz plot with the circle that encloses at least 60% of the points')
        xlabel('RR_{n} (ms)')
        ylabel('RR_{n+1} (ms)')
    end
    
    %% Shannon Entropy
    ShannonEntropy=0;

    %% Kolmogorov Smirnov Test
    KSTestValue=0;
        
    

    
