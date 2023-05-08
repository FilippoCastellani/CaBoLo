function [AFEv, Radius, ShannonEntropy, KSTestValue] = get_AF_features(ecg, fs, t, Rpeak_index, visuals)
    % This function calculates Atrial Fibrillation features from the ECG signal
    %
    % - [ ] AFEv 
    % - [X] Radius [[AFEv#Radius sub-feature]]
    % - [X] Shannon Entropy
    % - [ ] Kolmogorov-Smirnov Test Value
    %
    
    %% AFEv
    AFEv=0;
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

    if (visuals) figure(); end
    
    while Radius < Lorenz_X_boundary
        Radius = Radius + high_resolution_bin_lateral_size;
        [x,y] = meshgrid(-Lorenz_X_boundary:high_resolution_bin_lateral_size:Lorenz_X_boundary);
        mask = x.^2 + y.^2 <= Radius^2;
        % mask = mask(1:end-1,1:end-1);
        if(visuals) image(mask*255); end

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
    % This feature provides a quantitative measure of uncertainty for a random variable.
    % The random variable in our case is the value taken by the rr_series vector.
    % SE quantifies the likelihood that runs of patterns exhibiting regularity over 
    % some duration of data also exhibit similar regular patterns over the next 
    % incremental duration of data. 
    
    % For example, a random white noise signal (statistically independent signal) 
    % is expected to have the highest SE value (1.0) since it shows maximum uncertainty
    % in predicting the pattern of the signal whereas a simple sinusoidal signal (data 
    % are not independent) has a very low SE value approaching 0. 

    % Thus, the SE of normal sinus rhythm is expected to be significantly lower than in AF.
    
    % 1. To calculate SE of the RR time series, we first construct a histogram of the segment
    % considered. 
    % 1.A The eight longest and eight shortest RR values in the segment are 
    % considered outliers and are removed from consideration. 
    
    % 1.B The remaining RRs are sorted into equally spaced bins whose limits are defined by
    % the shortest and longest R after removing outliers. 
    % To obtain a reasonably accurate measure of the SE, at least 16 such bins are required.
    
    % 2. The probability distribution is computed for each bin as the number of beats in that 
    % bin divided by the total number of beats in the segment (after removing outliers),

    ShannonEntropy=0;

    num_bins = 16;

    % First we need to compute the histogram of the RR intervals
    % Outliers are removed
    tail_percentage = 5; % This value was chosen empirically AVVERTI CHIARA E NELLY
    rr_series_no_outliers = rr_series(rr_series > prctile(rr_series, tail_percentage) & rr_series < prctile(rr_series, 100 - tail_percentage));

    if (visuals)
        figure()
        h = histogram(rr_series, num_bins);
        hold on
        histogram(rr_series_no_outliers, h.BinEdges);
        legend('Original','No outliers')
        title('Histogram of RR intervals')
        xlabel('RR_{n} (ms)')
        ylabel('Count')
    end

    % Now lets compute the bin edges (now that we have removed the outliers)
    bin_edges = linspace(min(rr_series_no_outliers), max(rr_series_no_outliers), num_bins+1);

    % once again we need to count how many points are in each bin
    [counts, ~] = histcounts(rr_series_no_outliers, bin_edges);

    % compute the probability distribution
    probability_distribution = counts/sum(counts);

    if (visuals)
        figure()
        bar(bin_edges(1:end-1), probability_distribution)
        title('Probability distribution of the RR intervals')
        xlabel('RR_{n} (ms)')
        ylabel('Probability')
    end

    % Before applying the SE formula we need to remove the zero values from the probability distribution
    % otherwise the log(0) will give us NaN
    non_zero_prob_distribution = nonzeros(probability_distribution);
    
    % this is justified by the fact that the probability distribution where 
    % equal to zero is muliplying the log(0) and thus the contribution is 
    % zero in any case.
    % If we had more samples we would have had no empty bins but at the same 
    % time very low value for probability and this would have "fixed" the
    % issue.

    % Apply the definition of Shannon Entropy
    ShannonEntropy = -sum(non_zero_prob_distribution.*log(non_zero_prob_distribution));

    %% Kolmogorov Smirnov Test
    KSTestValue=0;
end
    

    
