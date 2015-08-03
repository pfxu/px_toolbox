% clear
% clc
% PI = 'G:\XPF\DataAnalysis\TaskYoung\Mask\Amyg.img';
% PO = 'G:\XPF\DataAnalysis\TaskYoung\Mask\Reslice';
% TargetSpace = 'G:\XPF\DataAnalysis\RestYoung\DataAnalysis\Results\FC\ROI1FCMap_Sub001.img';
% rest_ResliceImage(PI,PO,[2 2 2],0,TargetSpace);

% clear
% clc
% PI = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\ACC.img';
% PO = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\Rescliced_ACC.img';
% if ~exist(fileparts(PO),'dir');mkdir(fileparts(PO));end
% TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
% rest_ResliceImage(PI,PO,[2 2 2],0,TargetSpace);

% clear
% clc
% pathin = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask';
% imglist = px_ls(pathin,'-F',1,'.img');
% for i = 1: length(imglist)
%     pathout = fullfile(pathin,'Resliced');
%     if ~exist(pathout,'dir');mkdir(pathout);end
%     [p imgname ext] = fileparts(imglist{i});
%     imgout = fullfile(pathout,[imgname ext]);
%     TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
%     rest_ResliceImage(imglist{i},imgout,[2 2 2],0,TargetSpace);
%     disp(['Reslice:' imglist{i},' >>>> ',imgout,' done!']);
% end

% clear
% clc
% pathin = 'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\';
% imglist = px_ls(pathin,'-F',1,'.img');
% for i = 1: length(imglist)
%     pathout = fullfile(pathin,'Resliced');
%     if ~exist(pathout,'dir');mkdir(pathout);end
%     [p imgname ext] = fileparts(imglist{i});
%     imgout = fullfile(pathout,[imgname ext]);
%     TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
%     rest_ResliceImage(imglist{i},imgout,[2 2 2],0,TargetSpace);
%     disp(['Reslice:' imglist{i},' >>>> ',imgout,' done!']);
% end

% clear
% clc
% pathin = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\AAL1024.nii';
% pathout = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\AAL_1024_3mm.nii';
% TargetSpace = 'I:\DataAnalysis\EOEC\BC\GretnaNifti\sub_002\cbdwrasub_002_0011.nii';
% rest_ResliceImage(pathin,pathout,[3 3 3],0,TargetSpace);
% disp(['Reslice:' pathin,' >>>> ',pathout,' done!']);

% clear
% clc
% pathin = '/Volumes/Data/PX/Baboons/DataSortReady/T1/BUDDY/5823_009_COR3D_FSPGR_14_Flip_2_NEX_20110510/BUDDY_20110510_5823_009_Gill_Baboon_new_3_COR3D_FSPGR_14_Flip_2_NEX.img';
% pathout = '/Volumes/Data/PX/Baboons/DataSortReady/T1/BUDDY/BUDDY_t1.img';
% % TargetSpace = '/Users/pengfeixu/Documents/MATLAB/matlab_toolbox/templates/b2k_spm_images/b2k.img';
% rest_ResliceImage(pathin,pathout,[1 1 1],0);%,TargetSpace
% disp(['Reslice:' pathin,' >>>> ',pathout,' done!']);

% clear
% clc
% pathin = 'E:\fMRI\REST_V1.8_121225\mask\BrainMask_05_53x63x46.img';
% TargetSpace = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl_Resliced\Resliced_Heschl.nii';
% pathout  = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\BrainMask';
% rest_ResliceImage(pathin,pathout,[1.5 1.5 1.5],0);%,TargetSpace
% disp(['Reslice:' pathin,' >>>> ',pathout,' done!']);

clear
clc
pathin = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2\Putamen.img';
TargetSpace = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\LAT\LAT\group\group_pm\flex_nogmc_condition\con_0001.img';
pathout  = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MasksRes\Putamen.img';
rest_ResliceImage(pathin,pathout,[2 2 2],0);%,TargetSpace
disp(['Reslice:' pathin,' >>>> ',pathout,' done!']);
