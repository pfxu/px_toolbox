function [para] = px_spm8_convert(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FORMAT px_spm8_convert(fdp,para)
%   %%FORMAT px_spm8_convert(ip,op,idt,ht,dt)
%      fdp.scan   full data path, e.g. ip = '/Volume/DataRaw/Sub001/*.dcm';
%      para.op    output data path, e.g. para.op = '/Volume/DataImg/Sub001';
%      para.ht    hierarchy type.
%            'flat'       - do not produce file tree [default] <DEFAULT>
%        With all other options, files will be sorted into directories 
%        according to their sequence/protocol names.
%            'date_time'  - Place files under ./<StudyDate-StudyTime>/<ProtocolName>
%            'patid'      - Place files under ./<PatID>/<ProtocolName>
%            'patid_date' - Place files under ./<PatID>/<StudyDate>/<ProtocolName>
%            'patname'    - Place files under ./<PatName>/<ProtocolName>
%            'series'     - Place files in series folders, without
%                           creating patient folders
%      para.ndt     NIfTI data type for output.
%            'img'        - dual file(hdr+img)NIfTI 
%            'nii'        - single file(nii)NIfTI   <DEFAULT>
%
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2013/3/18 00:00:00
% Revised by PX, change the DEFAULT para.ndt from '.img' to '.nii', 2013/08/08
% Revised by px, change the input from path to full path.
%==========================================================================

if nargin == 1; para = [];end
if ~isfield(para,'ht');para.ht = 'flat';end
if ~isfield(para,'ndt');para.ndt = 'nii';end
if ~exist(para.op,'dir');mkdir(para.op);end
%% batch
matlabbatch{1}.spm.util.dicom.data = fdp.scan;%cellstr(dcmdata);
matlabbatch{1}.spm.util.dicom.root = para.ht;
matlabbatch{1}.spm.util.dicom.outdir = {para.op};
matlabbatch{1}.spm.util.dicom.convopts.format = para.ndt;
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
save (fullfile(para.op,'matlabbatch_convert'), 'matlabbatch')
%% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
% cd(cwd)
spm_jobman('serial', matlabbatch);