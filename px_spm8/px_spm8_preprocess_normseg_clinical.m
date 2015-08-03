function px_spm8_preprocess_normseg_clinical (ftp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_preprocess_normseg_clinical (para,para)
%  Useage This function is used to normalize and segment the T1 with lesoin
%    map, based on a clinical tool box of spm. see 
%    http://www.mccauslandcenter.sc.edu/CRNL/clinical-toolbox
%  Input
%    ftp.ana - fullpath of structual file; 
%    ftp.les - fullpath of lesoin map;
%   Optional input
%    ftp.t2  - fullpath of t2 file;
%    para.tp  - template
%               - 0, the spm default MNI152 template 
%               - 1, a elderly template (which is based on older adults, and 
%                 thus has large ventricles) from clinical toolbox 
%    para.clean - cleanup level
%                 - 0, 'none';
%                 - 1, 'light';
%                 - 2, 'thorough';
%    para.bb    - bounding box;
%    para.vox   - voxel size ;
%    para.ssthr - scalp strip threshold
%    para.imi   - intermediate images;
%                 - 0, keep;
%                 - 1, delete;
%    para.op    - output path for batch. <default = fdp.ana>
%  Output 
%    1, t1 folder, normalized t1,'^wm*' file;
%    2, t1 folder, parameters of the normseg (_seg_sn.mat)and its inversion (_seg_inv_sn.mat).
%    3, lesion folder, the lesion map after binarized normalize writed smoothed, '^bws*' file.
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if ~isfield(ftp,'t2');    ftp.t2    = '';end
if nargin == 1; para = [];end
if ~isfield(para,'clean'); para.clean = 2;end
if ~isfield(para,'bb');    para.bb    = [-78 -112 -50;78 76 85];end
if ~isfield(para,'vox');   para.vox   = [1 1 1];end
if ~isfield(para,'ssthr'); para.ssthr = 0.005;end
if ~isfield(para,'imi');   para.imi   = 1;end
if ~isfield(para,'op');
    try
        para.op = fileparts(ftp.ana{1,1}{1});%para.op = fileparts(ftp.ana{1});
    catch
        para.op = fileparts(ftp.ana{1});%para.op = fileparts(char(ftp.ana));
    end
end
if ~exist(para.op,'dir');mkdir(para.op);end
% batch
matlabbatch{1}.spm.tools.MRI.MRnormseg.anat = ftp.ana;
matlabbatch{1}.spm.tools.MRI.MRnormseg.les = ftp.les;
matlabbatch{1}.spm.tools.MRI.MRnormseg.t2 = '';
matlabbatch{1}.spm.tools.MRI.MRnormseg.clinicaltemplate = 0;
matlabbatch{1}.spm.tools.MRI.MRnormseg.clean = 2;
matlabbatch{1}.spm.tools.MRI.MRnormseg.bb = para.bb;
matlabbatch{1}.spm.tools.MRI.MRnormseg.vox = para.vox;
matlabbatch{1}.spm.tools.MRI.MRnormseg.ssthresh = para.ssthr;
matlabbatch{1}.spm.tools.MRI.MRnormseg.DelIntermediate = para.imi;
save (fullfile(para.op ,'prep_normseg'), 'matlabbatch');
% run
tbx_cfg_clinical;
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);