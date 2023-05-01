function idx = find_minmax_one(binary_seq, mode)
%   This function returns the index of the maximum (if 'max' mode) or the minimum (if 'min' mode) 
%   value of 1 in a binary sequence given as input

% Find the indices of all the 1 in the sequence
one_indices = find(binary_seq == 1);

if isempty(one_indices)
    % If there are no 1's in the sequence, return 0
    idx = 0;
else
    if mode =='max'  % find the index of the maximum value of 1
        [~, idx] = max(one_indices);
    elseif mode =='min' % find the index of the maximum value of 1
        [~, idx] = min(one_indices);
    else
        disp('Unrecognized mode');
        idx = 0;
    end

end