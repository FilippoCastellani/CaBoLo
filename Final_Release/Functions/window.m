function [start, stop, windowed_signal]= window(signal, start, stop)
% This function windows the signal with the desired start and stop handling
% potential exceeding of indexes

    if stop < start
        start = start-1;
        stop = start+1;
    end 
    if start<1
        start = 1;
    end
    if stop>length(signal)
        stop = length(signal);
    end
    windowed_signal = signal(start:stop);
    
    if isempty(windowed_signal)
        windowed_signal = signal(start:start);
    end 
    
end 
