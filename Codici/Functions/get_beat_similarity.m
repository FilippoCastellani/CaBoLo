function [similarity_ratio,bin_matrix]  = get_beat_similarity(matrix1)
    
    % Compute correlation coefficients along the matrix
    similarity_matrix = corrcoef(matrix1');
    
    % % If two matrices are given, it means that we need to compute
    % % the joint similarity of QRS and R amplitude
    % % therefore, before analyzing the matrix, we make the product
    % if nargin == 2
    %     similarity_matrix2 = corrcoef(matrix2');
    %     similarity_matrix = similarity_matrix1 .* similarity_matrix2;
    % else
    %     similarity_matrix = similarity_matrix1;
    % end

    % Take only the upper right part
    triangular_matrix = triu(similarity_matrix, 1);

    % Put zero also along the diagonal
    triangular_matrix(logical(eye(size(triangular_matrix)))) = 0;

    % Choose a threshold for high similarity
    threshold = 0.7;

    % Count values that are above the threshold
    bin_matrix = triangular_matrix > threshold;
    high_similarity = sum(sum(bin_matrix));
    
    % Compute similarity index as the number of correlation above threshold
    similarity_ratio = high_similarity / numel(triangular_matrix(triangular_matrix ~= 0));
end