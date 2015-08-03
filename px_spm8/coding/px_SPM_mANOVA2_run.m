% cd /Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter;
% if ~exist('FC_92_PCC_R','dir'); mkdir('FC_92_PCC_R');end
% if ~exist('FC_107_PACC_L','dir'); mkdir('FC_107_PACC_L');end
% if ~exist('FC_110_PACC_R','dir'); mkdir('FC_110_PACC_R');end
% if ~exist('FC_113_ACC_L','dir'); mkdir('FC_113_ACC_L');end
% if ~exist('FC_133_PCC_L','dir'); mkdir('FC_133_PCC_L');end
% if ~exist('FC_208_AI_L','dir'); mkdir('FC_208_AI_L');end
% if ~exist('FC_209_AI_R','dir'); mkdir('FC_209_AI_R');end
% if ~exist('FC_217_ACC_R','dir'); mkdir('FC_217_ACC_R');end

% clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/209_AI_L';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_208_AI_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_208_AI_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_208_AI_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_208_AI_L'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);
% 
% clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_92_PCC_R';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);
% 
% clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_133_PCC_L';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_133_PCC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_133_PCC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_133_PCC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_133_PCC_L'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);

% clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/209_AI_R';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_209_AI_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_209_AI_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_209_AI_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_209_AI_R'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);
% 
% clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/113_ACC_L';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_113_ACC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_113_ACC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_113_ACC_L'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_113_ACC_L'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);clear
% clc
% output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/217_ACC_R';
% name = {'Group';'SCR'};
% path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_217_ACC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_217_ACC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_217_ACC_R'
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_217_ACC_R'};
% prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
% vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
% px_SPM_mANOVA2(output,name,path,prefix,vector);



clear
clc
output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/107_PACC_L';
name = {'Group';'SCR'};
path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_107_PACC_L'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_107_PACC_L'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_107_PACC_L'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_107_PACC_L'};
prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
px_SPM_mANOVA2(output,name,path,prefix,vector);clear
clc
output = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/110_PACC_R';
name = {'Group';'SCR'};
path = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_110_PACC_R'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_110_PACC_R'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_110_PACC_R'
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_110_PACC_R'};
prefix = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2';};
vector = {[1:3,5:11,13:19];[1,3:7,10:18]};
px_SPM_mANOVA2(output,name,path,prefix,vector);