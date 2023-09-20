function relocated_index = relocate(index, start_reference)
% this function relocates the index on a window in the original signal
% starting from the reference
    relocated_index = index + start_reference - 1;
end 