% clear 
% %clc
% for i = [1,3:7,10:18]
% %V = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% V = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/FunImgNormalizedSmoothedDetrendedCovremoved/2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_CR_WM/TCWMMask/';
% if ~exist(Output,'dir'); mkdir(Output);end
% %Template = '/Volumes/Data/data/rsfMRI/07_0699/Mask/mask_79x95x68/WhiteMask_09_79x95x68.img'; 
% Template = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/Mask/WhiteMask_09_91x109x91.img';
% WM = px_VOITC_mask(V, Template, 1);
% save([Output,'VOI',num2str(i,'%03.0f'),'.txt'], 'WM', '-ASCII', '-DOUBLE','-TABS');
% end

% clear 
% %clc
% for i = [1,3:7,10:18]
% V = spm_select('ExtFPList',['G:\XPF\Experiment\SCR\1st\','2',num2str(i,'%03.0f'),filesep,'analysis'], '^con_0001.*\.img$');
% Output = 'G:\XPF\Experiment\SCR\TC\';
% if ~exist(Output,'dir'); mkdir(Output);end
% Template = 'G:\XPF\Experiment\SCR\Mask\PCC_79x95x68.img';
% WM = px_VOITC_mask(V, Template, 1);
% save(fullfile(Output,['PCC',num2str(i,'%03.0f'),'.txt']), 'WM', '-ASCII', '-DOUBLE','-TABS');
% end

% clear 
% clc
% for i = [19,21]
% V = spm_select('ExtFPList','I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis', ['^con_' num2str(i,'%04.0f') '.*\.img$']);
% Output = 'I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis';
% if ~exist(Output,'dir'); mkdir(Output);end
% Template = 'I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis\pcc.img';
% WM = px_VOITC_mask(V, Template, 1);
% save(fullfile(Output,['PCC',num2str(i,'%03.0f'),'.txt']), 'WM', '-ASCII', '-DOUBLE','-TABS');
% end


clear 
clc
masks = {'AmygL';'AmygR';'Amyg';'ACCL';'ACCR';'ACC'};
Input = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/';
for m = 1:length(masks)
V = spm_select('ExtFPList',Input, '^Sub.*\.img$');
Output = fullfile(Input,'ROIs_AAL',masks{m});
if ~exist(Output,'dir'); mkdir(Output);end
TemplatePath = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/PPI/Mask/Resliced';
Template = fullfile(TemplatePath,[masks{m} '.img']);
MTC = px_mean_tc_mask(V, Template, 1);% Mean Time Course
save(fullfile(Output,[masks{m},'.txt']), 'MTC', '-ASCII', '-DOUBLE','-TABS');
end