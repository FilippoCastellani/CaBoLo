function [fileNames, labels] = get_filenames(reference_filepath)

    % Load the CSV file
    data = readtable(reference_filepath,'ReadVariableNames', false); 
    data.Properties.VariableNames = {'FileName', 'Label'};
    
    % Extract the file names
    fileNames = data.FileName; 
    labels = data.Label; 

    % Get rid of the first row (header)
    fileNames = fileNames(2:end);
    labels = labels(2:end);

end 