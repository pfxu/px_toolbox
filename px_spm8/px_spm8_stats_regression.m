function px_spm8_stats_regression(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_stats_regression(fdp,para)
% 
%  fdp.scan   - full path of the scans, cell format;
%  fdp.cov    - full path of the covariates, cell format. Covariates matrix  
%               in .txt or .mat file. One covaraite in one folumun;
%  para.op    - ouput path, string, e.g. '/data/results';
%  para.cname - names of covariates for the multiple regression, cell 
%               format. One covaraite in one cell, e.g. para.cname = 
%               {'anxiety'}.
% 
% Pengfei Xu, @BNU, 12/10/2012
% Revised by Pengfei Xu,09/03/2013,@QCCUNY
%==========================================================================
if ~exist(para.op,'dir'); mkdir(para.op);end

matlabbatch{1}.spm.stats.factorial_design.dir = {para.op};
matlabbatch{1}.spm.stats.factorial_design.des.mreg.scans = fdp.scan;
covs = load(fdp.cov);
% covs = fdp.cov;
for nv = 1: length(para.cname)
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(nv).c = covs(:,nv);
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(nv).cname = para.cname{nv};
    matlabbatch{1}.spm.stats.factorial_design.des.mreg.mcov(nv).iCC = 1;
end
matlabbatch{1}.spm.stats.factorial_design.des.mreg.incint = 1;
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
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
n = 0;
for nv = 1: length(para.cname)
    n = n + 1;
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.name = [para.cname{nv} 'pos'];
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.convec = [zeros(nv) 1];
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
    n = n + 1;
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.name = [para.cname{nv} 'neg'];
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.convec = [zeros(nv) -1];
    matlabbatch{3}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
    n = n + 1;    
    matlabbatch{3}.spm.stats.con.consess{n}.fcon.name = [para.cname{nv} 'ftest'];
    matlabbatch{3}.spm.stats.con.consess{n}.fcon.convec = {zeros(nv) 1};
    matlabbatch{3}.spm.stats.con.consess{n}.fcon.sessrep = 'none';
end
matlabbatch{3}.spm.stats.con.delete = 0;
save (fullfile(para.op,'matlabbatch_regression'), 'matlabbatch')
%%
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);