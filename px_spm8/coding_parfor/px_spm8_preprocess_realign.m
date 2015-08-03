function [para] = px_spm8_preprocess_realign(fdp,para,op)
%FORMAT px_spm8_preprocess_realign(fdp,para)
% Usage Call the spm8 for realignment. 
%   Input 
%     fdp.scan - full path of the data files. Cell format for input, with  
%                one run in one brace. e.g., {{run1};{run2}}
%     para
%       para.pf - prefix for output files. <default = 'a'>
%       para.op - output path for batch. <default = fdp >
%   Oputput
%     The files after realignment with the specific prefix <default =
%     'r'>.
%
%  Pengfei Xu, 2013/08/08, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'pf'); para.pf = 'r';end
if nargin < 3;
    try
        op = fileparts(fdp.scan{1,1}{1});
    catch
        op = fileparts(fdp.scan{1});
    end
end
if ~exist(op,'dir');mkdir(op);end
% batch
matlabbatch{1}.spm.spatial.realign.estwrite.data = fdp.scan;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = para.pf;
save (fullfile(op,'prep_realign'), 'matlabbatch');
% run
close all;
spm_figure('Create','Graphics','Graphics','on');
spm_jobman('initcfg');
spm('defaults', 'FMRI');
output_list = spm_jobman('run',matlabbatch); %output_list
end