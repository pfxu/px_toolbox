function px_spm8_vbm_check_cov(fdp,para)
%FORMAT px_spm8_vbm_check_cov(fdp,para)
% Usage This function used to check sample homogeneity using covariance.
%  Input
%   fdp.scan   - full path of input data, cell format. [e.g., 'm0wrp1*',
%                which are the normalized (wr) GM segments (p1) modulated
%                for the non-linear components (m0)]
%   fdp.cov    - full path of input nuisance file, cell format. The input
%                nuisance file should be '.mat' or '.text', which contains
%                a m-by-n matrix, with m observers (in rows) and n nuisance
%                (in columns).
%   para.scale - proportional scaling.
%                - 0, 'No'
%                - 1, 'Yes'. e.g., when you dispaly t1 volumes.<DEFAULT>
%   para.gap   - Gap to skip slices. To speed up calculations you can
%                define that only every x slice the covariance is estimated.
%                <DEFAULT,5>
%   para.slice - the horizontal slice in mm. <DEFAULT,0>.
%  Pengfei Xu, 2013/08/26, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'scale'); para.scale = 1;end
if ~isfield(para,'sclice'); para.sclice = 0;end
if ~isfield(para,'gap'); para.gap = 5;end
if ~isfield(fdp,'cov'); fdp.cov =struct('c', {});end
% run
matlabbatch{1}.spm.tools.vbm8.tools.check_cov.data = fdp.scan;
matlabbatch{1}.spm.tools.vbm8.tools.check_cov.scale = para.scale;
matlabbatch{1}.spm.tools.vbm8.tools.check_cov.slice = para.slice;
matlabbatch{1}.spm.tools.vbm8.tools.check_cov.gap = para.gap;
if isempty(fdp.cov)
    matlabbatch{1}.spm.tools.vbm8.tools.check_cov.nuisance = fdp.cov;
else
    for ncov = 1:size(fdp.cov,2)
        matlabbatch{1}.spm.tools.vbm8.tools.check_cov.nuisance(nvoc).c = fdp.cov(:,ncov);
    end
end
% run
spm_figure('Create','Graphics','Graphics','on');
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end
