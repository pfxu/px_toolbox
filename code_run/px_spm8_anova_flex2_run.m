clear
clc
%% The path for output 2nd level results.
datapath = 'H:\ASD_SCR_PX\data\rsfMRI\07_0699\DPARSF_S8V2_test_0108\Results';
% if ~exist(op,'dir');mkdir(op);end
c1 = fullfile(datapath,'FCNoGMCNoSCR_PCC');% did not regress out SCR
c2 = fullfile(datapath,'FCNoGMCSCR_PCC');% regress out SCR
g1c1 = cellstr(spm_select('ExtFPList',c1,'^zFCMap_1.*\.nii'));
g1c2 = cellstr(spm_select('ExtFPList',c2,'^zFCMap_1.*\.nii'));
g2c1 = cellstr(spm_select('ExtFPList',c1,'^zFCMap_2.*\.nii'));
g2c2 = cellstr(spm_select('ExtFPList',c2,'^zFCMap_2.*\.nii'));
% px_txt(datapath,'g1c1',g1c1);
% px_txt(datapath,'g1c2',g1c2);
% px_txt(datapath,'g2c1',g2c1);
% px_txt(datapath,'g2c2',g2c2);

% para.p = fullfile(datapath,'flex_nogmc_group');
% para.f = 'g'; 
% data.img{1,1} = g1c1;
% data.img{1,2} = g1c2;
% data.img{2,1} = g2c1;
% data.img{2,2} = g2c2;
% px_spm8_anova_flex2 (para,data);
% 
% para.p = fullfile(datapath,'flex_nogmc_condition');
% para.f = 'c'; 
% px_spm8_anova_flex2 (para,data);

para.p = fullfile(datapath,'flex_nogmc_main');
para.f = 'main'; 
data.img{1,1} = g1c1;
data.img{1,2} = g1c2;
data.img{2,1} = g2c1;
data.img{2,2} = g2c2;
% px_spm8_anova_flex2_maineffect (para,data);

para.p = fullfile(datapath,'flex_nogmc_interaction');
para.f = 'interaction'; 
px_spm8_anova_flex2_maineffect(para,data)