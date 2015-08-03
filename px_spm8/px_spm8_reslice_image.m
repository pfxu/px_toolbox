function px_spm8_reslice_image(PI,PO,NewVoxSize,hld, TargetSpace)
% FORMAT px_spm8_reslice_image(PI,PO,NewVoxSize,hld, TargetSpace)
%   PI - input full path filename
%   PO - output full path filename
%   NewVoxSize - 1x3 matrix of new vox size.
%   hld - interpolation method. 0: Nearest Neighbour. 1: Trilinear. Usually
%   use 0.
%   TargetSpace - Define the target space. 'ImageItself': defined by the 
% image itself (corresponds  to the new voxel size); 'XXX.img': defined by 
% a target image 'XXX.img' (the NewVoxSize parameter will be discarded in 
% such a case).
%   Example: y_Reslice('D:\Temp\mean.img','D:\Temp\mean3x3x3.img',[3 3 3],
% 1,'ImageItself')
%       This was used to reslice the source image 'D:\Temp\mean.img' to a
%       resolution as 3mm*3mm*3mm by trilinear interpolation and save as 
% 'D:\Temp\mean3x3x3.img'.
%__________________________________________________________________________
% Written by YAN Chao-Gan 090302 for DPARSF. Referenced from SPM5.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing 
% Normal University, China, 100875
% ycg.yan@gmail.com
%__________________________________________________________________________
% Last Revised by YAN Chao-Gan 100401. Fixed a bug while calculating the 
% new dimension.
% Revicesd by Pengfei Xu 2013/1/24.Replace the function 
% rest_ReadNiftiImage.m by spm_vol.m.

if nargin<=4
    TargetSpace='ImageItself';
end
% get the target space from the target image or image itself
if ~strcmpi(TargetSpace,'ImageItself')
    VTAR = spm_vol(TargetSpace);
    mat  = VTAR.mat;
    dim  = VTAR.dim;
else
    VTAR   = spm_vol(PI);
    origin = VTAR.mat(1:3,4);
    origin = origin+[VTAR.mat(1,1);VTAR.mat(2,2);VTAR.mat(3,3)]-[NewVoxSize(1)*sign(VTAR.mat(1,1));NewVoxSize(2)*sign(VTAR.mat(2,2));NewVoxSize(3)*sign(VTAR.mat(3,3))];
    origin = round(origin./NewVoxSize').*NewVoxSize';
    mat    = [NewVoxSize(1)*sign(VTAR.mat(1,1))                 0                                   0                       origin(1)
        0                         NewVoxSize(2)*sign(VTAR.mat(2,2))              0                       origin(2)
        0                                      0                      NewVoxSize(3)*sign(VTAR.mat(3,3))  origin(3)
        0                                      0                                   0                          1      ];
    %dim=(VTAR.dim).*diag(VTAR.mat(1:3,1:3))';
    %dim=ceil(abs(dim./NewVoxSize)); %dim=abs(round(dim./NewVoxSize));
    % Revised by YAN Chao-Gan, 100401.
    dim    = (VTAR.dim-1).*diag(VTAR.mat(1:3,1:3))';
    dim    = floor(abs(dim./NewVoxSize))+1;
end

%reslice the source image
VI          = spm_vol(PI);
VO          = VI;
VO.fname    = deblank(PO);
VO.mat      = mat;
VO.dim(1:3) = dim;

[x1,x2,x3] = ndgrid(1:dim(1),1:dim(2),1:dim(3));
d     = [hld*[1 1 1]' [1 1 0]'];
C = spm_bsplinc(VI, d);
v = zeros(dim);

M = inv(VI.mat)*mat; % M = inv(mat\SourceHead.mat) in spm_reslice.m
y1   = M(1,1)*x1+M(1,2)*x2+(M(1,3)*x3+M(1,4));
y2   = M(2,1)*x1+M(2,2)*x2+(M(2,3)*x3+M(2,4));
y3   = M(3,1)*x1+M(3,2)*x2+(M(3,3)*x3+M(3,4));
DATA = spm_bsplins(C, y1,y2,y3, d);
%Revised by YAN Chao-Gan 121214. Apply a mask from the source image: don't extend values to outside brain.
tiny = 5e-2; % From spm_vol_utils.c
Mask = true(size(y1));
Mask = Mask & (y1 >= (1-tiny) & y1 <= (VI.dim(1)+tiny));
Mask = Mask & (y2 >= (1-tiny) & y2 <= (VI.dim(2)+tiny));
Mask = Mask & (y3 >= (1-tiny) & y3 <= (VI.dim(3)+tiny));
DATA(~Mask) = 0; 

V = spm_write_vol(VO,DATA);
disp(['Reslice:' PI,' >>>> ',PO,' done!']);