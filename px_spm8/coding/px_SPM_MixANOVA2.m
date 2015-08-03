%px_SPM_MixANOVA2 (op,ip,pre,num1,num2)
clear
clc
% op = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_92_PCC_R_FAnova/'};
% ip = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R/'};

% op = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_217_ACC_R_FAnova/'};
% ip = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_217_ACC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_217_ACC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_217_ACC_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_217_ACC_R/'};

% op = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_209_AI_R_FAnova/'};
% ip = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_209_AI_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_209_AI_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_209_AI_R/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_209_AI_R/'};

% op = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIs_ANOVA/FC_208_AI_L_FAnova/'};
% ip = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_208_AI_L/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_208_AI_L/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_208_AI_L/';...
%     '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_208_AI_L/'};
op = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/Results_PCC/FAnova/'};
ip = {'/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/Results_PCC/FCNoSCR/';...
    '//Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/Results_PCC/FCSCR/';...
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/Results_PCC/FCNoSCR/';...
    '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/Results_PCC/FCSCR/'};

pre = {'zFCMap_1';'zFCMap_1';'zFCMap_2';'zFCMap_2'};
num1 = [1:3,5:11,13:19];%[1:3,5:11,13:19];
num2 = [1,3:7,10:18];%[1,3:7,10:18];
if ~exist(char(op),'dir'); mkdir(char(op));end
matlabbatch{1}.spm.stats.factorial_design.dir = op;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'condition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;
m = 0;
for i = num1
    m = m+1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(m).scans = ...
    {spm_select('ExtFPList',ip{1},[pre{1} num2str(i,'%03.0f') '.*\.img$']);spm_select('ExtFPList',ip{2},[pre{2} num2str(i,'%03.0f') '.*\.img$'])};
% {
%                                                                                   '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R/zFCMap_1001.img,1'
%                                                                                   '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R/zFCMap_1001.img,1'
%                                                                                   };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(m).conds = [1 1;1 2];%[1 1;1 2];
end
n = m;
for j = num2
    n = n+1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(n).scans = ...
    {spm_select('ExtFPList',ip{3},[pre{3} num2str(j,'%03.0f') '.*\.img$']);spm_select('ExtFPList',ip{4},[pre{4} num2str(j,'%03.0f') '.*\.img$'])};
% {
%                                                                                   '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsBefore/FC_92_PCC_R/zFCMap_2001.img,1'
%                                                                                   '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0108/ResultsVOIsAfter/FC_92_PCC_R/zFCMap_2001.img,1'
%                                                                                   };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(n).conds = [2 1;2 2];%[2 1;2 2];
end

matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.fmain.fnum = 3;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{4}.inter.fnums = [2;3];
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

n1 = m;n2 = n-m;nc = 2;ng = 2;MEc = [1:nc]-mean(1:nc);MEg = [1 -1];
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
%% %main effect including 1(subjects), 2, 3 when designed
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Main Effect of Group';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [ones(1,n1)/n1 -ones(1,n2)/n2 MEg zeros(1,nc) ones(1,nc)/nc -ones(1,nc)/nc];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Main Effect of condition';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [zeros(1,n1+n2) zeros(1,ng) MEc MEc*[n1/(n1+n2)] MEc*[n2/(n1+n2)]];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Interaction group x condition';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [zeros(1,n1+n2) zeros(1,ng) zeros(1,nc) MEc -MEc];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'flip Interaction group x condition';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [zeros(1,n1+n2) zeros(1,ng) zeros(1,nc) -MEc MEc];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

% %% %main effect including 1(subjects) when designed
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Main Effect of Group';
% %matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [ones(1,nc)/nc -ones(1,nc)/nc ones(1,n1)/n1 -ones(1,n2)/n2];%[ones(1,n1)/n1 -ones(1,n2)/n2 ones(1,nc)/nc -ones(1,nc)/nc];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [ones(1,n1)/n1 -ones(1,n2)/n2 ones(1,nc)/nc -ones(1,nc)/nc];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Main Effect of condition';
% %matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [MEc MEc zeros(1,n1+n2)];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [zeros(1,n1+n2) MEc MEc];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Interaction group x condition';
% %matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [MEc -MEc zeros(1,n1+n2)];
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [zeros(1,n1+n2) MEc -MEc];
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'flip Interaction group x condition';
% %matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-MEc MEc zeros(1,n1+n2)];
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [zeros(1,n1+n2) -MEc MEc];
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.delete = 0;



% %% %main effect including 2, 3 when designed
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Main Effect of Group';
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [MEg zeros(1,nc) ones(1,nc)/nc -ones(1,nc)/nc];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Main Effect of condition';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [zeros(1,ng) MEc MEc*[n1/(n1+n2)] MEc*[n2/(n1+n2)]];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Interaction group x condition';
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [zeros(1,ng) zeros(1,nc) MEc -MEc];
% matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'flip Interaction group x condition';
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [zeros(1,ng) zeros(1,nc) -MEc MEc];
% matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.delete = 0;
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);



