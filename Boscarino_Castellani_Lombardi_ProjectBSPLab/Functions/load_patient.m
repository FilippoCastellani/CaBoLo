function [Sig, Fs, Time] = load_patient(PatientPath)
    % This function loads the data of a patient from the PhysioNet 2017 Database
    % Input: PatientName - Name of the patient
    % Output: Sig - Signal of the patient
    %         Fs - Sampling frequency
    %         Time - Time vector

    [Sig, Fs, Time] = rdsamp(PatientPath, 1);
    
end