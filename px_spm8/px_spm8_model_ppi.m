function px_spm8_model_ppi(op,pathrun,ppirun,pname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT  px_spm8_model_ppi(op,pathrun,ppirun,pname)
%    Usage  This function is used to model the ppi (glm).
%    op       -  output path
%    pathrun  -  input img file (after preprocessed) path of each run, cell
%    format, each run in one row.
%    ppirun   -  full file of ppi.mat file for each run,cell format, each
%    run in one row.
%    pname    -  names for the PPI variable, cell format.
%                pname{1} name of PPI.Y 
%                pname{2} name of PPI.P 
% Pengfei Xu, 12/26/2012, @BNU
%==========================================================================
if ~exist(op,'dir');mkdir(op);end
nrun = size(pathrun,1);
nsess = nrun;
datarun = cell(nrun,1);
rprun = cell(nrun,1);
for run = 1:nrun
    datarun{run,1} = cellstr(spm_select('ExtFPList',pathrun{run},'^swra.*\.img$'));
    rprun{run,1} = cellstr(spm_select('FPList',pathrun{run},'^rp.*\.txt$'));
end
matlabbatch{1}.spm.stats.fmri_spec.dir = {op};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
for s = 1: nsess
    clear PPI
    load(ppirun{s,1});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).scans = datarun{s,1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(1).name = 'Interaction';
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(1).val = PPI.ppi;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(2).name = pname{1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(2).val = PPI.Y;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(3).name = pname{2};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress(3).val = PPI.P;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = rprun{s,1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).hpf = 128;
end
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'Scaling';%%% global mean correction
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
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
rp = zeros(1,6);
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Interaction';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = repmat([1 0 0 rp],1,nsess);
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = pname{1};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = repmat([0 1 0 rp],1,nsess);
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = pname{2};
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = repmat([0 0 1 rp],1,nsess);
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
save(fullfile(op,'matlabbatch'),'matlabbatch')
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);