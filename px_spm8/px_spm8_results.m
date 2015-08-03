function [hReg,xSPM,SPM] = px_spm8_results(fdp,ic,thresDesc,p,k,mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT   [hReg,xSPM,SPM] = px_spm8_results(ip,ic,thres,p,k)
%    Usage This function is used to load the special contrast result.
%    Input
%       fdp.SPM        - fullpath of SPM.mat
%       ic        - indices of contrasts (in SPM.xCon).
%       thresDesc - description of height threshold (string), 
%                   'FWE|FDR|none'.
%       p         - p value
%       k         - extent threshold {voxels}
%       mask      - %indices of masking contrasts (in xCon)
%                 mask.type
%                          0 none mask            <DEFAULT>
%                          1 contrast
%                          2 image
%                 If mask.type is 1, the following should be inputed.
%                 mask.Im  indices of masking contrasts (in xCon)
%                 mask.pm  p-value for masking (uncorrected)
%                 mask.Ex  flag for inclusive or exclusivemasking
%                          0  inclusive
%                          1  exclusive
%                 If mask.type is 2, the following should be inputed.
%                 mask.Im  full path of the mask image file
%                 mask.Ex  flag for inclusive or exclusivemasking
%    Output
%       hReg      - handle of MIP XYZ registry object
%                   (see spm_XYZreg.m for details).
%       xSPM      - structure containing SPM, distribution & filtering 
%                   details.(see spm_getSPM.m for contents)
%       SPM       - SPM structure containing generic parameters
%                   (see spm_spm.m for contents)
% 
% Pengfei Xu, 2013/01/26,@BNU
%==========================================================================
if nargin == 5; mask.type = 0; end
load(fdp.SPM);
spm('defaults', 'FMRI');
xSPM.swd = fileparts(fdp.SPM);
xSPM.Ic = ic;
if mask.type == 1; xSPM.Im = mask.Im; xSPM.pm = mask.pm; xSPM.Ex = mask.Ex;
elseif mask.type == 2; xSPM.Im = mask.Im; xSPM.Ex = mask.Ex;
else xSPM.Im = [];
end
xSPM.title = SPM.xCon(xSPM.Ic).name;%title for comparison (string)
xSPM.thresDesc = thresDesc;
xSPM.u = p;
xSPM.k = k;
[hReg,xSPM,SPM] = spm_results_ui('Setup',xSPM);