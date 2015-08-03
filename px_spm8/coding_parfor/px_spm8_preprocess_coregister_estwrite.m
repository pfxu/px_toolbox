function [para] = px_spm8_preprocess_coregister_estwrite(data_ref,data_source,data_other,para)
%FORMAT [para] = px_spm8_preprocess_coregister_estwrite(fdp,para)
% Usage Call the spm8 for coregistration(both estimation and reslice).
%   Input
%     fdp.ref - full path of the reference image. Cell format for input,
%           with one run in one brace. e.g., {{run1};{run2}}.
%     fdp.source - full path of the source image. Cell format for input,
%           with one run in one brace. e.g., {{run1};{run2}}.
%     fdp.other - full path of other image to corgesiter. Cell format for
%           input, with one run in one brace. e.g., {{run1};{run2}}.
%     para.op    - output path for batch. <default = fdp.source>
%     para.pf  - prefix for output files. <default = 'r'>
%     para.core_fwhm - FWHM Gaussian filter for coregistration. <default, [7 7]>
%   Oputput
%     Files after estimated and resliced with the specific prefix.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para.pf = 'r';end
if ~isfield(para,'core_fwhm');para.core_fwhm = [7 7];end
if ~isfield (para,'pf'); para.pf = 'r';end
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
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = data_ref;
matlabbatch{1}.spm.spatial.coreg.estwrite.source = data_source;
matlabbatch{1}.spm.spatial.coreg.estwrite.other = data_other;
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = para.core_fwhm;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = para.pf;
save (fullfile(op,'prep_coregister_estwrite'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end