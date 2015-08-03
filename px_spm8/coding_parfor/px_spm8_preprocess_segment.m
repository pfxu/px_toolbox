function [para] = px_spm8_preprocess_segment(fdp,para,op)
%FORMAT [para] = px_spm8_preprocess_segment(fdp,para)
% Usage Call the spm8 for segmentation. 
%   Input 
%     fdp - full path of the data files. Cell format for input, with one 
%           run in one brace. e.g., {{run1};{run2}}
%     para
%       para.clean   - Clean up any partitions
%                      - 0, Dont do cleanup;
%                      - 1, Light Clean; <Default>
%                      - 2, Thorough Clean;
%       para.regtype - Affine regularisation
%                      - '', No affine registration;
%                      - 'mni', ICBM space template - European brains;
%                      - 'eastern', ICBM space template - East Asian brains; 
%                      - 'subj', Average sized template;
%                      - 'none', No regularisation.
%       para.op      - Output path for batch. <default = fdp.data{1}>
%   Oputput
%     1. spatial normalisation parameters (* seg sn.mat files);
%     2. inverse normalisation;
%    Optional:
%     3. The native space option will produce a tissue class image (c*) 
%        that is in alignment with the original (c1 - grey matter;  
%        c2 - white matter; c3 - Cerebro-Spinal Fluid).
%     4. spatially normalised versions - both with (mwc*) and without (wc*) 
%        modulation 
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'clean'); para.clean = 1;end
if ~isfield(para,'regtype'); error('Check para.regtype, what template is going to be used for Affine regularisation');end
if nargin < 3;
    try
        op = fileparts(fdp{1});
    catch
        op = fileparts(fdp{1,1}{1});
    end
end
% batch
matlabbatch{1}.spm.spatial.preproc.data = fdp;
matlabbatch{1}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{1}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{1}.spm.spatial.preproc.output.cleanup = para.clean;
matlabbatch{1}.spm.spatial.preproc.opts.tpm = {fullfile(spm('dir'),'tpm','grey.nii')
                                                fullfile(spm('dir'),'tpm','white.nii')
                                                fullfile(spm('dir'),'tpm','csf.nii')};
matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2;2;2;4];
matlabbatch{1}.spm.spatial.preproc.opts.regtype = para.regtype;
matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};
save (fullfile(op,'prep_segment'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end