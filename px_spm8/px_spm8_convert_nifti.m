function px_spm8_convert_nifti(ip,op)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_convert_nifti(ip,op)
%   Usage: Convert NIfTI between single file (.nii) and dual file (.hdr&.img).
%   Input:
%     ip - input full path for .nii file or .hdr&.img file.
%     op - output full path for .hdr&.img file or .nii file.
%   Output:
%     NIFTI hdr/img pairs.
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 4/08/2013 00:00:00
%==========================================================================
V       = spm_vol(ip);
[Y,~]   = spm_read_vols(V);
V.fname = op;
spm_write_vol(V,Y);