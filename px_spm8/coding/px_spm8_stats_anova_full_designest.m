function px_spm8_stats_anova_full_designest(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_spm8_stats_anova_full_designest(fdp,para)
% Usage This function is used to call spm8 for one-way anova of between
%       subject design.
%  Input
%   fdp.scan   - full path of scans,one group in one cell;
%   fdp.cov    - full path of covariates, strings. For the in put .txt or
%                .mat file, one covariates in one column;
%   para.op    - output folder of results of one-way anova
%   para.fname
%   para.nlevel
%   para.dept
%   para.var
%   para.gmsca
%   para.ancova
% 
%   para.flevel
%   fdp.scan
%   fdp.cov
%   para.cname - name of covariate, strings. e.g.,'age'.
%   para.iCFT
%   para.iCC
%   para.dept
%   fdp.excmask
%   para.class
%  Pengfei Xu, 2013/09/02, QC,CUNY.
%==========================================================================

% check input
if ~exist(para.op,'dir');mkdir(para.op);end
if ~isfield(fdp,'cov'); fdp.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});end
% output dir
matlabbatch{1}.spm.stats.factorial_design.dir = para.op;%para.op
% factors & levels
for nf = 1:length(para.fname)
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).name = para.fname{nf};%para.fname
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).levels = para.nlevel{nf};%para.nlevel
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).dept = 0;%para.dept
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).variance = 1;%para.var
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).gmsca = 0;%para.gmsca
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(nf).ancova = 0;%para.ancova
end
% scans & levels
for nf = 1:length(para.fname)
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(nf).levels = para.flevel{nf};%para.flevel
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(nf).scans = fdp.scan{nf};%fdp.scan
end
% covs
if isempty(fdp.cov)
    matlabbatch{1}.spm.stats.factorial_design.cov = fdp.cov;%fdp.cov
else
    cov = load(fdp.cov);
    for ncov = 1:size(cov,2)
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).c = cov(:,ncov);%
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).cname = para.cname;%para.cname
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).iCFI = 1;%para.iCFT
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).iCC = 1;%para.iCC
    end
end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};% excmask
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
%
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;% para.class
save (fullfile(para.op,'matlabbatch_stats_anova_full_designest'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);