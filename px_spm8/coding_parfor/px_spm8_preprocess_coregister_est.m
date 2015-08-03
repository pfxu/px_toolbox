function [para] = px_spm8_preprocess_coregister_est(para,data_ref,data_source,data_other,op)
%FORMAT [para] = px_spm8_preprocess_coregister_est(fdp,para)
% Usage Call the spm8 for coregistration(estimation only).
%   Input 
%     fdp.ref    - full path of the reference image. Cell format for input, 
%           with one run in one brace. e.g., {{run1};{run2}}.
%     fdp.source - full path of the source image. Cell format for input, 
%           with one run in one brace. e.g., {{run1};{run2}}.
%     fdp.other  - full path of other image to corgesiter. Cell format for 
%           input, with one run in one brace. e.g., {{run1};{run2}}.
%     para.op    - output path for batch. <default = fdp.source>
%     para.core_fwhm - FWHM Gaussian filter for coregistration. <default, [7 7]>
%   Oputput
%     Only estimation without reslice. Registration parameters are stored 
%     in the headers of the 'source' and the 'other' images.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'core_fwhm');para.core_fwhm = [7 7];end
if nargin < 4; data_other = {''};end
if nargin < 5;
    try
        op = fileparts(data_source{1,1}{1});
    catch
        op = fileparts(data_source{1});%para.op = fileparts(char(fdp.source));
    end
end
if ~exist(op,'dir');mkdir(op);end
% batch
matlabbatch{1}.spm.spatial.coreg.estimate.ref = data_ref;
matlabbatch{1}.spm.spatial.coreg.estimate.source = data_source;
matlabbatch{1}.spm.spatial.coreg.estimate.other = data_other;
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = para.core_fwhm;
save (fullfile(op,'prep_coregister_est'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end