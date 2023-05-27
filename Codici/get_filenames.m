function fileNames = get_filenames(reference_filepath)

    % Load the CSV file
    data = readtable(reference_filepath,'ReadVariableNames', false); 
    data.Properties.VariableNames = {'FileName', 'Label'};
    
    % Extract the file names
    fileNames = data.FileName; 
    % Get rid of the first row (header)
    fileNames = fileNames(2:end);

end 