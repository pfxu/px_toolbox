function [para] = px_spm8_preprocess_smooth(fdp,para)
%FORMAT px_spm8_preprocess_smooth(fdp,para)
% Usage Call the spm8 for smoothing.
%   Input
%       fdp.scan  - full path of the data files. Cell format for input, 
%                   with one run in one brace. e.g., {{run1};{run2}}
%     para
%       para.fwhm - the full-width at half maximun(FWHM) of the Gaussian
%                   smoothing kernel in mm.
%       para.pf   - prefix for output files. <default = 's'>
%       para.op   - output path for batch. <default = fdp.scan>
%   Oputput
%     The files after smoothing with the specific prefix <default = 's'>.
%     
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield (para,'fwhm'); para.fwhm = [8 8 8];end
if ~isfield (para,'pf'); para.pf = 's';end
if ~isfield(para,'op');
    try
        para.op = fileparts(fdp.scan{1,1}{1});
    catch
        para.op = fileparts(fdp.scan{1});
    end
end
if ~exist(para.op,'dir');mkdir(para.op);end
% batch
matlabbatch{1}.spm.spatial.smooth.data = fdp.scan;
matlabbatch{1}.spm.spatial.smooth.fwhm = para.fwhm;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = para.pf;
save (fullfile(para.op,'prep_smooth'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end