function [para] = px_spm8_preprocess_slicetiming(para,fdp,op)
%FORMAT px_spm8_preprocess_slicetiming(fdp,para)
% Usage Call the spm8 for slice timing. 
%   Input 
%     fdp - full path of the data with NIfTI or Anlyze format. Cell format
%     for input, with one run in one brace. e.g., {{run1};{run2}}
%     para
%       para.ns - number of slices.
%       para.tr - TR.
%       para.so - slice order. e.g., [1:2:33,2:2:32].
%       para.rs - reference slice. <default = 1>
%       para.pf - prefix for output files. <default = 'a'>
%       para.op - output path for batch. <default = fdp >
%   Oputput
%     The files after slice timing with the specific prefix <default =
%     'a'>.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if ~isfield(para,'rs'); para.rs = 1;end
if ~isfield(para,'pf'); para.pf = 'a';end
if nargin < 3;
    try
        op = fileparts(fdp{1,1}{1});
    catch
        op = fileparts(fdp{1});
    end
end
if ~exist(op,'dir');mkdir(para.op);end

% batch
matlabbatch{1}.spm.temporal.st.scans = fdp;
matlabbatch{1}.spm.temporal.st.nslices = para.ns ;
matlabbatch{1}.spm.temporal.st.tr = para.tr;
matlabbatch{1}.spm.temporal.st.ta = para.tr-(para.tr/para.ns) ;
matlabbatch{1}.spm.temporal.st.so = para.so;
matlabbatch{1}.spm.temporal.st.refslice = para.rs;
matlabbatch{1}.spm.temporal.st.prefix = para.pf;
save(fullfile(op,'prep_slicetiming'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end