function [volume] = px_spm8_reslice(ip,op,vs,hld,tmp)

% FORMAT [volume] = px_spm8_reslice(ip,op,vs,hld, tmp)
% Input:
%   ip  - fullfile name of the input image file
%   op  - fullfile name of the output image file
%   vs  - 1x3 matrix of new vox size.
%   hld - interpolation method. 0: nearest neighbour. 1: trilinear.
%   tmp - A template image to define the target space and the new vox size. 
%         (Note: The vs parameter will be discarded if it is
%          different from the vox size of the tmp.)
% Output:
%   volume  - The resliced output volume and the resliced image file stored
%             in op.
%__________________________________________________________________________
% See spm_reslice.m & rest_RescliceImage.m

if nargin > 4
    head_ref = spm_vol(tmp);
    mat      = head_ref.mat;
    dim      = head_ref.dim;
else
    head_ref = spm_vol(ip);
    origin   = head_ref.mat(1:3,4);
    origin   = origin+[head_ref.mat(1,1);head_ref.mat(2,2);head_ref.mat(3,3)]-[vs(1)*sign(head_ref.mat(1,1));vs(2)*sign(head_ref.mat(2,2));vs(3)*sign(head_ref.mat(3,3))];
    origin   = round(origin./vs').*vs';
    mat      = [vs(1)*sign(head_ref.mat(1,1))                 0                                   0                       origin(1)
        0                         vs(2)*sign(head_ref.mat(2,2))              0                       origin(2)
        0                                      0                      vs(3)*sign(head_ref.mat(3,3))  origin(3)
        0                                      0                                   0                          1      ];

    dim      = (head_ref.dim-1).*diag(head_ref.mat(1:3,1:3))';
    dim      = floor(abs(dim./vs))+1;
end

head_sour = spm_vol(ip);

[x1,x2,x3] = ndgrid(1:dim(1),1:dim(2),1:dim(3));
d          = [hld*[1 1 1]' [1 1 0]'];
C          = spm_bsplinc(head_sour, d);
v          = zeros(dim);

M  = inv(head_sour.mat)*mat; % M = inv(mat\head_sour.mat) in spm_reslice.m
y1 = M(1,1)*x1+M(1,2)*x2+(M(1,3)*x3+M(1,4));
y2 = M(2,1)*x1+M(2,2)*x2+(M(2,3)*x3+M(2,4));
y3 = M(3,1)*x1+M(3,2)*x2+(M(3,3)*x3+M(3,4));

volume = spm_bsplins(C, y1,y2,y3, d);

% Apply a mask from the source image: don't extend values to outside brain.
tiny = 5e-2; % From spm_vol_utils.c
mask = true(size(y1));
mask = mask & (y1 >= (1-tiny) & y1 <= (head_sour.dim(1)+tiny));
mask = mask & (y2 >= (1-tiny) & y2 <= (head_sour.dim(2)+tiny));
mask = mask & (y3 >= (1-tiny) & y3 <= (head_sour.dim(3)+tiny));

volume(~mask) = 0;
 
head_out          = head_sour;
head_out.fname    = op;
head_out.mat      = mat;
head_out.dim(1:3) = dim;

V = spm_write_vol(head_out,volume);
disp(['Reslice:' ip,' >>>> ',op,' done!']);