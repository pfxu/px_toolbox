function px_spm8_model_spec_est(data_img,data_des,data_rp,op,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_model_spec_est(fdp,para)
%  Useage 
%    This function is used to call the spm8 for the model specification and 
%    estimation.'
%  Input
%    data_img    - full path of the image files in each run. Cell format, {runs,1}
%    data_des  - full path of the design mat file.
%    data_rp      - full path of the rp*.txt files in each run. Cell format,
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
if length(data_img) ~= length(data_des)
    error('Number of scan''run ~= number of design''s run.');
end
nrun = length(data_img);
for run = 1: nrun
    if ischar(data_img{run})
        data_img{run} = cellstr(data_img{run});
        data_des{run} = cellstr(data_des{run});
        if isempty(data_img{run});
            error('Check the data_img, which includes empty cell.');
        end
        if isempty(data_des{run});
            error('Check the data_des, which includes empty cell.');
        end
    end
end
if ~isfield(para,'on'), para.on = 'glm';end
if ~isfield(para,'units'), error('Undefined variable para.units');end
if ~isfield(para,'RT'), error('Undefined variable para.RT');end
if ~isfield(para,'t'), para.t = 16;end
if ~isfield(para,'t0'), para.t0 = 1;end
if ~isfield(para,'gm'), para.gm = 0;end
% if ~isfield(fdp,'rp'), rp = ''; else rp = data_rp;end
% if ~isfield(fdp,'mask'), mask = ''; else mask = fdp.mask;end
if ~exist(op,'dir');mkdir(op);end
if para.gm == 0;
    gmc = '';
elseif para.gm == 1;
    gmc = 'Scaling';
else
    error('Check the global intensity normalisation, para.gm!');
end
load(fullfile(px_toolbox_root,'px_spm8','px_spm8_model_spec_est.mat'));
matlabbatch{1}.spm.stats.fmri_spec.dir = {op};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = para.units;
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = para.RT;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = para.t;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = para.t0;

for s = 1:para.nsess
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).scans = data_img{s};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi = data_des{s};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress = struct('name', {}, 'val', {});
    if ~isempty(data_rp)
        matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = {data_rp};
    else
        matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = {''};
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).hpf = 128;
end

matlabbatch{1}.spm.stats.fmri_spec.global = gmc;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
% matlabbatch{1}.spm.stats.fmri_spec.mask = {mask};
%%%----------------------------- save -------------------------------------
save (fullfile(op,[para.on '_model_spec_est']), 'matlabbatch')
%%%----------------------------- run --------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);