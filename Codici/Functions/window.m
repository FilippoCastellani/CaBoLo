function [start, stop, windowed_signal]= window(signal, start, stop)
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
