function px_spm8_glm_block (fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_glm_block (fdp,para)
%    Usage This function is used for block design model.Here one run is  
% one block.
%  Input
%    fdp.scan     - full path of the image files in each run. Cell format, {runs,1}
%    fdp.rp       - full path of the rp*.txt files in each run. Cell format, {runs,1}.
%    fdp.cov      - full path of the cov files in each run. Cell format, {runs,1}.
%    para.op      - output path of the results of glm;
%    para.on      - name of the output directory, e.g., 'GLM';
%    para.rnames  - name of each run. Cell format, one run in one row.
%    para.consets - oneset time of each event in each run. Cell format,
%                   one run in one row.
%    para.pvalue - value of each trial. <Optional, only for paramatric function>
%    para.units   - units for design.(units of  onset)
%                   - 'secs'
%                   - 'scan'
%    para.RT      - interscan interval, seconds.
%    para.t       - the number of time-bins per scan used when building
%                   regressors. <DEFAULT, 16>
%    para.t0      - the first time-bin at which the regressors are resampled
%                   to coincide with data acquisitoin. <DEFAULT, 1>
%    para.gm      - global mean correction. <DEFAULT, 0>
%                   - 0, no; 
%                   - 1, yes;
%  Output
%    Directory - para.on
%     ./
% Pengfei Xu, 2012/09/04,BNU
% Revised by PX, 02/13/2014, input
% Revised by PX, 04/22/2014, cov
%==========================================================================

% Check input
if cellfun(@numel,fdp.scan{:}) == 0; error('Check the fdp.scan, which includes empty cell.');end
if cellfun(@numel,fdp.rp{:}) == 0; error('Check the fdp.rp, which includes empty cell.');end
if any(size(fdp.scan) ~= size(fdp.rp)); error('The number of fdp.scan and fdp.rp do not match.'); end
if any(size(para.rnames) ~= size(para.consets)); error('The number of para.rnames and para.consets do not match.'); end
if size(fdp.scan,1) ~= size (para.rnames,1); error('Runs of fdp.scan and para.rnames do not match.');end
if ~isfield(para,'on'), para.on = 'GLM';end
if ~isfield(para,'units'), error('Undefined variable para.units');end
if ~isfield(para,'RT'), error('Undefined variable para.RT');end
if ~isfield(para,'t'), para.t = 16;end
if ~isfield(para,'t0'), para.t0 = 1;end
if ~isfield(para,'gm'), para.gm = 0;end
if ~exist(para.op,'dir');mkdir(para.op);end
if para.gm == 0;
    GMC = '';
elseif para.gm == 1;
    GMC = 'Scaling';
else
    error('Check the global mean parameter, para.gm!');
end

nrun = size(para.rnames,1);
ncon = size(para.rnames,2);
nmod = size(para.pnames,2);
%%%----------------------------- batch ------------------------------------
matlabbatch{1}.cfg_basicio.cfg_named_dir.name = 'Subject';
matlabbatch{1}.cfg_basicio.cfg_named_dir.dirs = {{para.op}};
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1) = cfg_dep;
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tname = 'Directory';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).sname = 'Named Directory Selector: Subject(1)';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).src_output = substruct('.','dirs', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1) = cfg_dep;
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tname = 'Parent Directory';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).sname = 'Named Directory Selector: Subject(1)';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).src_output = substruct('.','dirs', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.name = para.on;
matlabbatch{4}.spm.stats.fmri_spec.dir(1) = cfg_dep;
matlabbatch{4}.spm.stats.fmri_spec.dir(1).tname = 'Directory';
matlabbatch{4}.spm.stats.fmri_spec.dir(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.stats.fmri_spec.dir(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{4}.spm.stats.fmri_spec.dir(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.stats.fmri_spec.dir(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.stats.fmri_spec.dir(1).sname = ['Make Directory: Make Directory ' '''' para.on ''''];
matlabbatch{4}.spm.stats.fmri_spec.dir(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1});
matlabbatch{4}.spm.stats.fmri_spec.dir(1).src_output = substruct('.','dir');
matlabbatch{4}.spm.stats.fmri_spec.timing.units = para.units;
matlabbatch{4}.spm.stats.fmri_spec.timing.RT =  para.RT;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t = para.t;
matlabbatch{4}.spm.stats.fmri_spec.timing.fmri_t0 = para.t0;
for run = 1: nrun
    matlabbatch{4}.spm.stats.fmri_spec.sess(run).scans = fdp.scan{run,1};
    n = 0;
    for con = 1:ncon
        if cellfun('isempty', para.consets(run,con))%% exclude the condition without no eligible trial.
            fid = fopen (fullfile(para.op, 'NoOnsetTrials.txt'),'a+');
            fprintf(fid,'Onset of ''%s'' in run %d is empty.\n',para.rnames{run,con},run);
            fclose(fid);
            warning(['Onset of ''' para.rnames{run,con} ''' in run ' num2str(run) ' is empty.']);
            fprintf('\n');
            continue;
        end
        n = n + 1;
        matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).name = para.rnames{run,con};
        matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).onset = para.consets{run,con};
        matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).duration = 0;
        matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).tmod = 0;
        if ~isfield(para,'pvalue')
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).pmod = struct('name', {}, 'param', {}, 'poly', {});
        elseif isfield(para,'pvalue') && ~isempty(find(para.pvalue{run,con},1));% Exclude the condition (in which all value are zero) for the para modulatoin.
            for mod = 1:nmod
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).pmod(mod).name  = para.pnames{run,mod};
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).pmod(mod).param = para.pvalue{run,mod};
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).pmod(mod).poly  = 1;
            end
        elseif isfield(para,'pvalue') && isempty(find(para.pvalue{run,con},1));% isempty(find(para.pvalue{run,con} ~= 0))
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).cond(n).pmod = struct('name', {}, 'param', {}, 'poly', {});
            fid = fopen (fullfile(para.op, 'NoParaModValueTrials.txt'),'a+');
            fprintf(fid,'Parametric modulation value of ''%s'' in run %d is empty.',para.rnames{run,run},run);
            fprintf(fid,'\n');
            fclose(fid);
            warning('Parametric modulation value of ''%s'' in run %d is empty.',para.rnames{run,run},run);
            fprintf('\n');
        end
    end
    matlabbatch{4}.spm.stats.fmri_spec.sess(run).multi = {''};
    if isfield(para,'covn')
        for c = 1: length(para.covn)
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).regress(c).name = char(para.covn{c});
            covs = load(char(fdp.cov{run,1}));
            matlabbatch{4}.spm.stats.fmri_spec.sess(run).regress(c).val = covs(:,c);
        end
    else
        matlabbatch{4}.spm.stats.fmri_spec.sess(run).regress = struct('name', {}, 'val', {});
    end
    matlabbatch{4}.spm.stats.fmri_spec.sess(run).multi_reg = fdp.rp{run,1};
    matlabbatch{4}.spm.stats.fmri_spec.sess(run).hpf = 128;
end
matlabbatch{4}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{4}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{4}.spm.stats.fmri_spec.volt = 1;
matlabbatch{4}.spm.stats.fmri_spec.global = GMC;% Global mean correction!
matlabbatch{4}.spm.stats.fmri_spec.mask = {''};
matlabbatch{4}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{5}.spm.stats.fmri_est.method.Classical = 1;
%%%----------------------------- save -------------------------------------
save (fullfile(para.op,'matlabbatch_glm_block'), 'matlabbatch')
%%%----------------------------- run --------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);