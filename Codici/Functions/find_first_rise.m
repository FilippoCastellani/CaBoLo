function location = find_first_rise(signal, threshold)
% This function returns the first location in which the signal overcomes
% the threshold. If none is found the function returns 0. 
location = 0;

    for i=1:length(signal)-1
        if (signal(i)<threshold && signal(i+1)>=threshold)
            location = i;
            break;
        end 
    end 

end