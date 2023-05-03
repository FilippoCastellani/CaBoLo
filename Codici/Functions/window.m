function [start, stop, windowed_signal]= window(signal, start, stop)
    if start<1
        start = 1;
    end
    if stop>length(signal)
        stop = length(signal);
    end
    windowed_signal = signal(start:stop);
end 
