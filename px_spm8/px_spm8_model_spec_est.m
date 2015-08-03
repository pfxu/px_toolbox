function px_spm8_model_spec_est(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_model_spec_est(fdp,para)
%  Useage 
%    This function is used to call the spm8 for the model specification and 
%    estimation.'
%  Input
%    fdp.scan    - full path of the image files in each run. Cell format, {runs,1}
%    fdp.design  - full path of the design mat file.
%    fdp.rp      - full path of the rp*.txt files in each run. Cell format,
%                  {runs,1}. <DEFAULT,''>
%    fdp.mask    - full path of the explicity mask image. <DEFAULT,''>
%    para.op     - output path of the results of glm;
%    para.on     - name of the output directory, e.g., 'glm';
%    para.nsess  - number of sessions/runs.
%    para.units  - units for design.(units of  onset)
%                  - 'secs'
%                  - 'scan'
%    para.RT     - interscan interval, seconds.
%    para.t      - the number of time-bins per scan used when building
%                  regressors. <DEFAULT, 16>
%    para.t0     - the first time-bin at which the regressors are resampled
%                  to coincide with data acquisitoin. <DEFAULT, 1>
%    para.gm     - global mean correction. <DEFAULT, 0>
%                  - 0, no; 
%                  - 1, yes;
%  Output
%    Directory - para.op
%     ./ .mat file of matlabbatch
%     ./ .mat file of SPM
% Pengfei Xu, 2012/10/03, BNU
%==========================================================================

% Check input
if length(fdp.scan) ~= length(fdp.design)
    error('Number of scan''run ~= number of design''s run.');
end
load(fullfile(px_toolbox_root,'px_spm8','px_spm8_model_spec_est.mat'));
nrun = length(fdp.scan);
for run = 1: nrun
    if ischar(fdp.scan{run})
        fdp.scan{run} = cellstr(fdp.scan{run});
    end
    if ischar(fdp.scan{run})
        fdp.design{run} = cellstr(fdp.design{run});
    end
    if isempty(fdp.scan{run});
        error('Check the fdp.scan, which includes empty cell.');
    end
    if isempty(fdp.design{run});
        error('Check the fdp.design, which includes empty cell.');
    end
end
if ~isfield(para,'on'), para.on = 'glm';end
if ~isfield(para,'units'), error('Undefined variable para.units');end
if ~isfield(para,'RT'), error('Undefined variable para.RT');end
if ~isfield(para,'t'), para.t = 16;end
if ~isfield(para,'t0'), para.t0 = 1;end
if ~isfield(para,'gm'), para.gm = 0;end
if ~isfield(fdp,'rp'), rp = ''; else rp = fdp.rp;end
if ~isfield(fdp,'mask'), mask = ''; else mask = fdp.mask;end
if ~exist(para.op,'dir');mkdir(para.op);end
if para.gm == 0;
    gmc = '';
elseif para.gm == 1;
    gmc = 'Scaling';
else
    error('Check the global intensity normalisation, para.gm!');
end

matlabbatch{1}.spm.stats.fmri_spec.dir = {para.op};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = para.units;
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = para.RT;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = para.t;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = para.t0;

for s = 1:para.nsess
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).scans = fdp.scan{s};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi = fdp.design(s);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = {rp};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).hpf = 128;
end

matlabbatch{1}.spm.stats.fmri_spec.global = gmc;
matlabbatch{1}.spm.stats.fmri_spec.mask = {mask};
%%%----------------------------- save -------------------------------------
save (fullfile(para.op,[para.on '_model_spec_est']), 'matlabbatch')
%%%----------------------------- run --------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);