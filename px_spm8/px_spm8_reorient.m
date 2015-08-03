function px_spm8_reorient(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_spm8_reorient(fdp,para)
% Usage This function is used to reorient center of the image to the origin
%       (AC ponit).
% Input
%   fdp.scan     - full path of the image files, cell format.
%   para.P  - parameters for transform,one subject in one row;the order is 
%              1) - T, translation;
%              2) - R, rotation (yaw, roll & pitch);
%              3) - Z, scale(zoom);
%              4) - S, shear.
%              see spm_matrix for help.
%   para.T  - transform matrix
%   para.pf - prefix for output files. <default = 'O'>
% Output
%   Image files after reorientation.
% 
% Pengfei Xu, 1/28/2014, @BNU
% 
% Note: (pitch,roll,yaw)
% --------------------------------------
%  Template   Data       Reorient FUN
% --------------------------------------
%   1 0 0     0 0 1     -      -     -  Last step
%   0 1 0     1 0 0    Yaw     -P    -  First step
%   0 0 1     0 1 0    Roll   Pitch  -  Second step
% --------------------------------------
%
% --------------------------------------
%  Template   Data       Reorient t1
% --------------------------------------
%   1 0 0     0  0  1     -      -    -
%   0 1 0     0  0 -1    Yaw     P    -
%   0 0 1     0  1  0    Roll    -    -
% --------------------------------------
%==========================================================================
% check input
if isfield (para,'P');para.M = spm_matrix(para.P);end
if ~isfield (para,'pf'); para.pf = 'o';end
% if length(fdp.scan) ~= size(para.P,1);
%     error(['the number of image file(' num2str(length(fdp.scan)) ') ~= number of para.P(' num2str(size(para.P,1)) ')']);
% end
matlabbatch{1}.spm.util.reorient.srcfiles = fdp.scan;
matlabbatch{1}.spm.util.reorient.transform.transM = para.M;
% matlabbatch{1}.spm.util.reorient.transform.transprm = para.P;
matlabbatch{1}.spm.util.reorient.prefix = para.pf;
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end