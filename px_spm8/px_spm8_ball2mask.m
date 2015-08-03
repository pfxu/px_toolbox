function  [V, mask] = px_spm8_ball2mask(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format px_spm8_ball2mask(fdp,para)
%  Usage  This function was used to generate a mask which constituted
%         by a sets of ROIs with the input coordinates and radius.
%  Input
%     fdp.T      - fullpath of one input NIfTI file for generate the 
%                  template. e.g. '../EPI.nii'
%     para.XYZmm - coordinates of each ROI in the template.
%                    [4 x m] or [3 x m] location matrix (voxel)
%     para.R     - radius of each ROI in the template.
%     para.op    - output directory, 
%     para.mn    - mask name. e.g. 'ROI.nii' OR 'ROI.img'.
%  Note:
%     The T file and the C should be in the same space (Typically, MNI standard space)
% 
% Pengfei Xu, 05/01/2013, @BNU
%==========================================================================

if ~exist(para.op,'dir');mkdir(para.op);end
% check whether or not the file exists
fname = fullfile(para.op,para.mn);
if exist(fname,'file');delete(fname); error('%s exist already, deleted!',fname);end
% check the dimension of XYZmm
XYZmm = para.XYZmm;
if size(XYZmm,1) ~= 3;
    XYZmm = XYZmm';
end
% read the information of T file.
V    = spm_vol(fdp.T);
if length(V) > 1; 
    warning('Multiple images was input, but the maske template is generated based on the 1st one!');
    V    = V(1);% only use 1st image; 
end
DIM  = V.dim(1:3);
VOX  = diag(V.mat);
VOX  = abs(VOX(1:3))';
mask = zeros(DIM);

% [~,XYZ] = spm_read_vols(V);
% XYZ     = XYZ';
% for i = 1: size(XYZmm,2)
%     xyz         = XYZmm(i,:);
%     xyz         = repmat(xyz, [size(XYZ, 1), 1]);
%     D           = sqrt(sum((xyz-XYZ).^2, 2)); % D = round(sqrt(sum((xyz-XYZ).^2, 2)));
%     index       = find(D <= R);
%   % [I,J,K]     = ind2sub(V.dim,index);
%   % mask(I,J,K) = i;
%     mask(index) = i;
% end
XYZ = cell(size(XYZmm,2),1);
for pos = 1: size(XYZmm,2)
    ROI = XYZmm(:,pos);
    ROI = reshape(ROI, 1,length(ROI));
    if isfield(V,'mat')
        ROI = round(inv(V.mat)*[ROI,1]');
        ROI = ROI(1:3);
        ROI = reshape(ROI, 1,length(ROI));
    end    
    % radius in x
    RADx = round(para.R / VOX(1)); 
    if (ROI(1)-RADx) >= 1 && (ROI(1)+RADx) <= DIM(1)
        EDGx	= (ROI(1)-RADx):(ROI(1)+RADx); % edge on x
    elseif (ROI(1)-RADx) <1 && (ROI(1)+RADx) <= DIM(1)
        EDGx	= 1:(ROI(1)+RADx);
    elseif (ROI(1)-RADx) >= 1 && (ROI(1)+RADx) > DIM(1)
        EDGx	= (ROI(1)-RADx):DIM(1);
    else
        EDGx = 1:DIM(1);
    end    
    % radius in y
    RADy = round(para.R / VOX(2));
    if (ROI(2)-RADy) >= 1 && (ROI(2)+RADy) <= DIM(2)
        EDGy	= (ROI(2)-RADy):(ROI(2)+RADy);
    elseif (ROI(2)-RADy) <1 && (ROI(2)+RADy) <= DIM(2)
        EDGy	= 1:(ROI(2)+RADy);
    elseif (ROI(2)-RADy) >= 1 && (ROI(2)+RADy) > DIM(2)
        EDGy	= (ROI(2)-RADy):DIM(2);
    else
        EDGy = 1:DIM(2);
    end
    % radius in z
    RADz = round(para.R / VOX(3));
    if (ROI(3)-RADz) >= 1 && (ROI(3)+RADz) <= DIM(3)
        EDGz	= (ROI(3)-RADz):(ROI(3)+RADz);
    elseif (ROI(3)-RADz) <1 && (ROI(3)+RADz) <= DIM(3)
        EDGz	= 1:(ROI(3)+RADz);
    elseif (ROI(3)-RADz) >= 1 && (ROI(3)+RADz) > DIM(3)
        EDGz	= (ROI(3)-RADz):DIM(3);
    else
        EDGz = 1:DIM(3);
    end
    % generate mask
    coord = [];
    for x = EDGx
        for y = EDGy
            for z = EDGz
                %Ball Definition, Computing within a cubic to minimize the time to be consumed
                if norm(([x, y, z] -ROI).*VOX) <= para.R,
                    mask(x, y, z) = pos;
                    coord = [coord; [x,y,z]];
                end
            end
        end
    end
    coord(:,4) = 1;
    XYZ{pos,1} = coord';
end
V.descrip  = [repmat('ROICenter = [',size(XYZmm,2),1), num2str(XYZmm'), repmat(['], ROIRadius = ' num2str(para.R)],size(XYZmm,2),1)];
% V.descrip = [blanks(1) 'ROI mask: Center = [' num2str(reshape(XYZmm,1,size(XYZmm,1)*size(XYZmm,2))) '], Radius = ' num2str(para.R)];
V.pinfo   = [1;0;0]; % The value in V.pinfo(1) of the T file should equal 1. See spm_vol for details.
V.fname   = fname;
V.dt      = [16,0];% maxval = inf
V.ind     = 1:size(XYZmm,2);
V.XYZmm   = XYZ;
spm_write_vol(V,mask);
end