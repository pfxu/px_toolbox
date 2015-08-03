function [para] = px_spm8_preprocess_normalise_write(data_mat,data_res,para,op)
%FORMAT px_spm8_preprocess_normalise_write(fdp,para)
% Usage Call the spm8 for normalisation (write only). 
%   Input 
%     data_mat - full path of the data files. Cell format for input, with one 
%           run in one brace. e.g., {{run1};{run2}}
%     para
%       para.bb  - boulding box
%       para.vox - voxel size
%       para.pf  - prefix for output files. <default = 'w'>
%       para.op  - output path for batch. <default = fdp.res>
%   Oputput
%     The files after normalisationwith the specific prefix <default =
%     'w'>.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield (para,'bb'); para.bb = [-78 -112 -50;78 76 85];end
if ~isfield (para,'vox'); para.vox = [2 2 2];end
if ~isfield (para,'pf'); para.pf = 'w';end
if nargin < 4;
    try
        op = fileparts(data_res{1,1}{1});
    catch
        op = fileparts(data_res{1});
    end
end
if ~exist(para.op,'dir');mkdir(para.op);end
% batch
matlabbatch{1}.spm.spatial.normalise.write.subj.matname = data_mat;
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = data_res;
matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = para.bb;
matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = para.vox;
matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = para.pf;
save (fullfile(op,'prep_normalise_write'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end