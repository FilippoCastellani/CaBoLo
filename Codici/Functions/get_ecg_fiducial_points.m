function [P_peak, P_onset, P_offset, T_peak, T_onset, T_offset, Q_peak, S_peak, R_peak, QRS_onset, QRS_offset]= get_ecg_fiducial_points(recordName, ecg, Rpeak_index)

    %% ECGPUWAVE tools
    % Generate .Rpeaks file containing the R peaks locations identified
    % using Pan-Tompkins algorithm
    wrann(recordName,'Rpeaks',Rpeak_index,'N',[0],[0],[0],{''})
    
    % generate .annotations file using ECGPUWAVE tool starting from .Rpeaks
    % file (generated using wrann)
    ecgpuwave(recordName,'annotations',[],[],'Rpeaks');

    % get annotations
    [indexes, annotation]
    
    % retrieve all onsets
    [onset_ann_index,~,~,~,onset_ann_num,~]=rdann(recordName,'annotations',[],[],[],'(');
    % retrieve all offsets
    [offset_ann_index,~,~,~,offset_ann_num,~]=rdann(recordName,'annotations',[],[],[],')');
    
    %% COMPUTE P FIDUCIAL POINTS
    % retrieve P waves reading .annotations file considering only P peaks
    P_peak =rdann(recordName,'annotations',[],[],[],'p');

    % retrieve P onset and offset - 0 is used for P waves
    P_onset = onset_ann_index(onset_ann_num==0);        
    P_offset = offset_ann_index(offset_ann_num==0);  
    
    %% COMPUTE T FIDUCIAL POINTS
    % retrieve T waves reading .annotations file considering only T peaks
    T_peak = rdann(recordName,'annotations',[],[],[],'t');

    % retrieve T onset and offset - 2 is used for T waves
    T_onset = onset_ann_index(onset_ann_num==2);
    T_offset = offset_ann_index(offset_ann_num==2);  
    
    %% COMPUTE QRS FIDUCIAL POINTS
    % retrieve QRS onset and offset - 1 is used for T waves
    QRS_onset = onset_ann_index(onset_ann_num==1);    
    QRS_offset = offset_ann_index(offset_ann_num==1); 

    % get R fiducial points
    R_peak = Rpeak_index;

    % Compute Q and S fiducial points 
    n = length(QRS_onset);
    Q_peak = nan(n);
    S_peak = nan(n);
    
    for i=(1:n)     % for each identified QRS complex
        qr_signal = ecg(QRS_onset(i):Rpeak_index(i)); % get the QR segment
        [~, Qloc_rel] = min(qr_signal); % find the negative peak 
        Q_peak(i) = Qloc_rel+QRS_onset(i); % store its location wrt the whole ecg
    
        rs_signal = ecg(Rpeak_index(i):QRS_offset(i)); % get the RS segment
        [~, Sloc_rel] = min(rs_signal); % find the negative peak 
        S_peak(i) = Sloc_rel+Rpeak_index(i); % store its location wrt the whole ecg
    end

end 