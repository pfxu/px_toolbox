function px_spm8_reorient(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT  px_spm8_reorient(fdp,para)
%    Usage  This function is used to batchly reorient image by calling spm8.
%    input
%           fdp.scan        - fullpaths of the image files to reorient.
%           para.parameters - [right forward up pitch roll yaw xscaling
%                              yscaling zscaling xaffine yaffine zaffine];
%           para.M          - affine transformation matrix.
%           para.pf         - prefix of out put image. <default,''>
%    Note:  para.parameters and para.M are alternatively.
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: Oct/06/2013 00:00:00
%==========================================================================
if ~isfield(para,'pf'); para.pf = 0;end
if isfield(para,'parameters')
    para.trans = spm_matrix(para.parameters);
elseif isfield(para,'M')
    para.trans = para.M;
else
    error('Check the input tranformation parameters or matrix')
end
matlabbatch{1}.spm.util.reorient.srcfiles = fdp.scan;
matlabbatch{1}.spm.util.reorient.transform.transM = para.trans;
matlabbatch{1}.spm.util.reorient.prefix = para.pf;
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);