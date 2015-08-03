% clear
% clc
% Input = {'/Volumes/Data/software/px_function/SPM5ResultsLabeling/aal.img,1'};
% oname = 'ACC_L';
% opath = {''};
% expression = 'i1 + i2';
% px_SPM_imcalc(Input,opath,oname,expression);

% clear
% clc
% Input = {'G:\XPF\DataAnalysis\TaskYoung\Mask\AmygR00001.img'; ...
%    'G:\XPF\DataAnalysis\TaskYoung\Mask\AmygL00001.img'};
% oname = 'Amyg';
% opath = {'G:\XPF\DataAnalysis\TaskYoung\Mask\'};
% expression = 'i1 + i2';
% px_SPM_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = {'ACCL';'ACCR';'AmygL';'AmygR'};
% expression = {'i1 == 31';'i1 == 32';'i1 == 41';'i1 == 42'};
% Input = {'H:\Toolbox\px_toolbox\SPM5ResultsLabeling\aal.img,1'};
% opath = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\';
% for i = 1: length(oname);
% px_spm8_imcalc(Input,oname{i},opath,expression{i});
% end

% clear
% clc
% oname = 'ACC';
% expression = 'i1 + i2';
% Input = {'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\ACCL.img';...
%     'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\ACCR.img'};
% opath = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Amyg';
% expression = 'i1 + i2';
% Input = {'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\AmygL.img';...
%     'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\AmygR.img'};
% opath = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = {'MCCL';'MCCR'};
% expression = {'i1 == 33';'i1 == 34'};
% Input = {'H:\Toolbox\px_toolbox\SPM5ResultsLabeling\aal.img,1'};
% opath = 'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\';
% for i = 1: length(oname);
% px_spm8_imcalc(Input,oname{i},opath,expression{i});
% end

% clear
% clc
% oname = 'MCC1111111del';
% expression = 'i1 - i2';
% Input = {'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\MCCL.img';...
%     'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\MCCR.img'};
% opath = 'I:\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Heschl_L.img';
% expression = 'i1 == 79';
% Input = {'M:\Backup\Backup_Batch_2013_10_17\matlab_toolbox\templates\px_aal.img'};
% opath = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Heschl_R.img';
% expression = 'i1 == 80';
% Input = {'M:\Backup\Backup_Batch_2013_10_17\matlab_toolbox\templates\px_aal.img'};
% opath = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Heschl.img';
% expression = 'i1 +i2';
% ip = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl\';
% Input = px_ls('reg',ip,'-F',1,'.img');
% opath = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl\';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'AmygR';
% expression = 'i1 == 42';
% Input = {fullfile(px_toolbox_root,'templates','aal_ba','px_aal.img')};
% opath = '/Volumes/Data/PX/TAModel/DataResults/Masks/';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Amyg';
% expression = 'i1+i2';
% Input = {'/Volumes/Data/PX/TAModel/DataResults/Masks/AmygL.img';'/Volumes/Data/PX/TAModel/DataResults/Masks/AmygR.img'};
% opath = '/Volumes/Data/PX/TAModel/DataResults/Masks/';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'AmygR';
% expression = 'i1 == 42';
% Input = {fullfile(px_toolbox_root,'templates','aal_ba','px_aal.img')};
% opath = '/Volumes/Data/PX/TAModel/DataResults/Masks/';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'PutamenL';
% expression = 'i1 == 75';
% Input = {fullfile(px_toolbox_root,'templates','aal_ba','px_aal.img')};
% opath = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2';
% px_spm8_imcalc(Input,oname,opath,expression);
% clear
% clc
% oname = 'PutamenR';
% expression = 'i1 == 76';
% Input = {fullfile(px_toolbox_root,'templates','aal_ba','px_aal.img')};
% opath = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2';
% px_spm8_imcalc(Input,oname,opath,expression);
% clear
% clc
% oname = 'Putamen';
% expression = 'i1 +i2';
% Input = {'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2\PutamenL.img';
%     'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2\PutamenR.img'};
% opath = 'H:\Projects\AP006_TAModel\DataAnalysis\DataResults\Masks\MaskRaw2';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'AI';
% expression = 'i1 +i2';
% Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/AIL.img';
%     '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/AIR.img'};
% opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'dlPFC';
% expression = 'i1 +i2';
% Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/FL.img';
%     '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/FR.img'};
% opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'LP';
% expression = 'i1 +i2';
% Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/PL.img';
%     '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/PR.img'};
% opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'Salience';
% expression = 'i1 +i2';
% Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/AI.img';
%     '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/dACC.img'};
% opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
% px_spm8_imcalc(Input,oname,opath,expression);

% clear
% clc
% oname = 'FPNetwork';
% expression = 'i1 +i2';
% Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/dlPFC.img';
%     '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/LP.img'};
% opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
% px_spm8_imcalc(Input,oname,opath,expression);

clear
clc
oname = 'vmPFC';
expression = 'i1 +i2';
Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/vmPFC1.img';
    '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/vmPFC2.img'};
opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
px_spm8_imcalc(Input,oname,opath,expression);

clear
clc
oname = 'PCC';
expression = 'i1 +i2';
Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/PCC1.img';
    '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/PCC2.img'};
opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
px_spm8_imcalc(Input,oname,opath,expression);


clear
clc
oname = 'DMN';
expression = 'i1 +i2';
Input = {'/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/vmPFC.img';
    '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc/PCC.img'};
opath = '/media/WM/Projects/AP006_TAModel/DataAnalysis/DatafMRI/LAT/LAT/group/group_pm_gl_hm/ANOVAc';
px_spm8_imcalc(Input,oname,opath,expression);