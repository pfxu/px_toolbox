function px_spm8_stats_anova1_between(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_spm8_stats_anova1_between(fdp,para)
% Usage This function is used to call spm8 for one-way anova of between
%       subject design.
%  Input
%   fdp.scan   - full path of scans,one group in one cell;
%   fdp.cov    - full path of covariates, strings. For the in put .txt or
%                .mat file, one covariates in one column;
%   para.op    - output folder of results of one-way anova
%   para.cname - name of covariate, strings. e.g.,'age'.
%  Pengfei Xu, 2013/09/02, QC,CUNY.
%==========================================================================

% check input
if ~exist(para.op,'dir');mkdir(para.op);end
if ~isfield(fdp,'cov'); fdp.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});end
% model
matlabbatch{1}.spm.stats.factorial_design.dir = {para.op};
for ng = 1:length(fdp.scan)
    matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(ng).scans = fdp.scan{ng};
end
matlabbatch{1}.spm.stats.factorial_design.des.anova.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anova.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anova.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anova.ancova = 0;
if isempty(fdp.cov)
    matlabbatch{1}.spm.stats.factorial_design.cov = fdp.cov;
else
    cov = load(fdp.cov);
    for ncov = 1:size(cov,2)
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).c = cov(:,ncov);
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).cname = para.cname;
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.cov(ncov).iCC = 1;
    end
end
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% estimate
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
% contrast
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
% f contrast of main effect (effect of interest)
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Main Effect (Effect of Interest)';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec = {eye(3)};
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
% t contrasts
ncon = {'Group 1';'Group 2';'Group 3';'Group 1 > Group 2';'Group 2 > Group 3';'Group 1 > Group 3'};
tcon = [eye(3);[1 -1 0];[0 1 -1];[1 -1 0]];
n = 1;
for nt = 1:length(ncon)
    for ttail = 1:2
        n = n + 1;
        tname = ncon{nt};
        tconvec = tcon(nt,:);
        if ttail == 2
            tname = ['filp' ncon{nt}];
            tconvec = -tcon(nt,:);
        end
        matlabbatch{3}.spm.stats.con.consess{n}.tcon.name = tname;
        matlabbatch{3}.spm.stats.con.consess{n}.tcon.convec = tconvec;
        matlabbatch{3}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
    end
end
matlabbatch{3}.spm.stats.con.delete = 0;
%%
save (fullfile(para.op,'matlabbatch_stats_anova1_between'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);