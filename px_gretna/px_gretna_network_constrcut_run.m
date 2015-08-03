clear
% clc
dp      = '/Volumes/Data/PX/DataAnalyzing/Resting/';
dp_img  = fullfile(dp,'DataPreprocess','Smoothed');
dp_hm   = '/Volumes/Data/PX/DataAnalyzing/Resting/DataPreprocess/Rest';
para.op = fullfile(dp,'NetworkConstruct');
group   = {'1','2'};
subvec  = {7,1:28};
% modes = {'detrend', 'filter', 'covariates regression', 'voxel-based degree', 'functional connectivity matrix'};
modes = {'detrend', 'filter', 'covariates regression', 'functional connectivity matrix'};
for g = 1%%1: length(group)
    for sub = subvec{g}
        subjname = [group{g} num2str(sub,'%03.0f')]; 
        sp = fullfile(dp_img,subjname);    
        fprintf('\nConstruct network for %s',sp);
        para.subjname = subjname;
        datalist = px_ls('reg',sp,'-F',1,'^sw');      
        % 'detrend'
        para.prefix = 'd';
        pra.order  = 1;
        pra.remain = 'TRUE';
        %'filter'
        prefix = 'b';
        band   = [.01 .08];
        TR     = 2;
        % 'covariates regression'
        para.BrainMask   = '/Volumes/WM/Backup/Backup_Batch_2013_10_17/matlab_toolbox/matlab_path/gretna1.0/mask/mask_Resliced/Resliced_BrainMask_05_61x73x61.nii';
        para.HMBool      = 'TRUE';
        para.HMPath      = fullfile(dp_hm,subjname,'run');
        para.HMPrefix    = 'rp_';
        para.HMDerivBool = 'FALSE';
        WMMask  = '/Volumes/WM/Backup/Backup_Batch_2013_10_17/matlab_toolbox/matlab_path/gretna1.0/mask/mask_Resliced/Resliced_WhiteMask_09_61x73x61.nii';
        CSFMask = '/Volumes/WM/Backup/Backup_Batch_2013_10_17/matlab_toolbox/matlab_path/gretna1.0/mask/mask_Resliced/Resliced_CsfMask_07_61x73x61.nii';
        para.CovCell = [{WMMask};{CSFMask}];%'voxel-based degree'
        para.r_thr = 0.3;
        para.Dis   = 75;
        %'functional connectivity matrix'
        para.labmask = '/Volumes/Data/PX/DataAnalyzing/Resting/Mask/MNI264_79x95x68.nii';
        px_gretna_network_constrcut(datalist,para,modes);     
        fprintf('\nDone.');
    end
end