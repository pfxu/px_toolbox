function px_spm8_checkreg(fdp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT px_spm8_checkreg(fdp)
%   Input fdp - full path of normalized data (e.g., 'mask.img')
%  Pengfei Xu, 01/08, 2014, @UMCG
%--------------------------------------------------------------------------
tmp_data  = fullfile(spm('dir'),'canonical','single_subj_T1.nii');
norm_data = fdp;
matlabbatch{1}.spm.util.checkreg.data = {tmp_data;norm_data};
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);