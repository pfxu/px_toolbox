function [para] = px_spm8_preprocess_smooth(para,data,op)
%FORMAT px_spm8_preprocess_smooth(data,para)
% Usage Call the spm8 for smoothing.
%   Input
%       data      - full path of the data files. Cell format for input, 
%                   with one run in one brace. e.g., {{run1};{run2}}
%       para.fwhm - the full-width at half maximun(FWHM) of the Gaussian
%                   smoothing kernel in mm.
%       para.pf   - prefix for output files. <default = 's'>
%       op        - output path for batch. <default = data>
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
if nargin < 3;
    try
        op = fileparts(data{1,1}{1});
    catch
        op = fileparts(data{1});
    end
end
if ~exist(op,'dir');mkdir(op);end
% batch
matlabbatch{1}.spm.spatial.smooth.data = data;
matlabbatch{1}.spm.spatial.smooth.fwhm = para.fwhm;
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = para.pf;
save (fullfile(op,'prep_smooth'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end