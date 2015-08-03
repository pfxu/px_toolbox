function  px_spm8_vbm_showslice(fdp,para)
%FORMAT px_spm8_vbm_showslice(fdp,para)
% Usage This function used to display a group of slices (n files should be  
%       more than 1, one horizontal slice for one subject) to check the 
%       results of segmetation and normalization.
%  Input
%   fdp.scan  - full path of input data, cell format.[e.g. the ?wm*? 
%                files, which are the normalized bias corrected volumes]
%   para.scale - proportional scaling.
%                - 0, 'No'
%                - 1, 'Yes'. e.g., when you dispaly t1 volumes.<DEFAULT>
%   para.slice - the horizontal slice in mm. <DEFAULT,0>.
%  Pengfei Xu, 2013/08/26, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'scale'); para.scale = 1;end
if ~isfield(para,'sclice'); para.sclice = 0;end
% batch
matlabbatch{1}.spm.tools.vbm8.tools.showslice.data = fdp.scan;
matlabbatch{1}.spm.tools.vbm8.tools.showslice.scale = para.scale;
matlabbatch{1}.spm.tools.vbm8.tools.showslice.slice = para.sclice;
% run
F = spm_figure('Create','Graphics','Graphics','on');
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
spm_figure('Print',F);
end

