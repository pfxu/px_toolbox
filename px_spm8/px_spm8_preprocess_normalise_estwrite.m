function [para] = px_spm8_preprocess_normalise_estwrite(fdp,para)
%FORMAT [para] = px_spm8_preprocess_normalise_est_write(fdp,para)
% Usage Call the spm8 for normalisation (write only).
%   Input
%     fdp - full path of the data files. Cell format for input, with one
%           run in one brace. e.g., {{run1};{run2}}
%       fdp.src   - source image;
%       fdp.wtsrc - (optional) source weighting image;
%       fdp.res   - image to write;
%       fdp.tmp   - template image;
%     para
%       para.regtype - Affine regularisation
%                      - 'mni'
%                      - 'subj'
%                      - 'none'
%       para.bb      - boulding box
%       para.vox     - voxel size
%       para.pf      - prefix for output files. <default = 'a'>
%       para.op      - output path for batch. <default = fdp.res>
%   Oputput
%     The files after normalization with the specific prefix <default =
%     'w'>.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================
% check input
if nargin == 1; para = [];end
if ~isfield (fdp,'wtsrc');fdp.wtsrc = [];end
if ~isfield (para,'regtype'); para.regtype = 'mni';end
if ~isfield (para,'bb'); para.bb = [-78 -112 -50;78 76 85];end
if ~isfield (para,'vox'); para.vox = [2 2 2];end
if ~isfield (para,'pf'); para.pf = 'w';end
if ~isfield (para,'op');
    try
        para.op = fileparts(fdp.res{1,1}{1});
    catch
        para.op = fileparts(fdp.res{1});
    end
end
if ~exist(para.op,'dir');mkdir(para.op);end
% batch
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source = fdp.src;
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = fdp.wtsrc;
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = fdp.res;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = fdp.tmp;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = para.regtype;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = para.bb;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = para.vox;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = para.pf;
save (fullfile(para.op,'prep_normalise_estwrite'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end