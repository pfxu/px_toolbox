clear
% clc

% dp.op = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataAnalysis/t1';
dp.op = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataAnalysis/Test/';

% dp.fun = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataReady/Repeat';
% dp.ana = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataReady/t1';
dp.fun = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataAnalysis/Test/Repeat';
dp.ana = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataAnalysis/Test/t1';
dp.les = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataAnalysis/Test/Mask';

para.vsub = [1,2];%[1:6,8:14];
para.nrun = 3;
para.predirsub = '2';%'1'
para.predirfundcm = 'func';
para.prediranadcm = 't1_mprage';
para.predirfun = 'run';
para.predirana = 't1';
para.predirles = '';
para.prefun = 'r';%'r'
para.preana = 's';%'s'
para.preles = '1';
para.datatype = 'nii';
para.dcmtype = 'IMA';
%% slicetiming
para.ns = 33;
para.tr = 2;
para.so = [1:2:33,2:2:32];
para.rs = 1;
% lesion
% segment
para.clean = 2;%Thorough Clean
para.regtype = 'mni';%- European brains
% normaliz
para.bb  = [-78 -112 -50;78 76 85];% boulding box
para.vox = [2 2 2];% voxel size
% smooth
para.fwhm = [8 8 8];%
%% 
% mode = {'realign'};
if strcmp(para.predirsub,'1');
    mode = {'dcm2nii'};
%     mode = {'slicetiming','realign','coregisterest','lesion','normalise','smooth'};
else
    mode = {'dcm2nii','slicetiming','realign','coregisterest','segment','normalise','smooth'};
end
px_spm8_preprocess_pipeline(dp,para,mode)