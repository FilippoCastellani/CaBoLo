function [PROJECT_DIRECTORY, DatasetFolderPath, DatasetFolderPrefix] = set_environment();
    if(getenv('COMPUTERNAME')=="FILIPPO") % se sei sul computer di filippo
        PROJECT_DIRECTORY = 'E:/ProgettiGithub/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("E:/ProgettiGithub/CaBoLo/Codici/WFDB_Toolbox"));
    
        % add functions folder to search path
        addpath(genpath("E:/ProgettiGithub/CaBoLo/Codici/Functions"));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    elseif(getenv('COMPUTERNAME')=="DESKTOP-T9UVACS")
        PROJECT_DIRECTORY = 'C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici/WFDB_Toolbox"));
    
        % add functions folder to search path
        addpath(genpath("C:/Users/Filippo/Documents/GitHub/CaBoLo/Codici/Functions"));
         
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
        
      
    elseif(getenv('COMPUTERNAME')=="") % Computer Nelly
         PROJECT_DIRECTORY = '/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/';
         cd(PROJECT_DIRECTORY);
    
         addpath(genpath("/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/WFDB_Toolbox"));
         addpath(genpath("/Users/antonellalombardi/Documents/GitHub/CaBoLo/Codici/Functions"));
         
         DatasetFolderPrefix = 'Dataset/training2017/';
         DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    elseif(getenv('COMPUTERNAME')=="HEAL26821") % Computer Bosca
        PROJECT_DIRECTORY = 'C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/WFDB_Toolbox"));
    
        % add functions folder to search path
        addpath(genpath("C:/Users/c.boscarino/OneDrive - Reply/Desktop/ChiaraBoscarino/UNI/BSPLab/CaBoLo/Codici/Functions"));
        
        % identify Dataset folder within project directory
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    elseif(getenv('COMPUTERNAME')=="F-C")
        PROJECT_DIRECTORY = 'C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/';
        cd(PROJECT_DIRECTORY);
        
        % add WFDB toolbox to search path
        addpath(genpath("C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/WFDB_Toolbox"));

        % add functions folder to search path
        addpath(genpath("C:/Users/caste/CaBoLo_Git/CaBoLo/Codici/Functions"));
         
        DatasetFolderPrefix = 'Dataset/training2017/';
        DatasetFolderPath = [PROJECT_DIRECTORY DatasetFolderPrefix];
    
    %else 
        %DatasetPath = "default"; %put your path here;
    
    end
end
