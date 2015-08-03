
function Sphere_Index = gen_ROI(Center_vox, Radium, hdr, Ref_img_mmCoords)

%
%        Center:
%               Center coordinates of the ROIs (# of ROIs*3 array);
%        Radium:
%               Radium for Sphere;
%        hdr:
%               Head file for reference image;
%               Acquired with spm_vol
%               hdr = spm_vol(Ref_img);
%        Ref_img_mmCoords:
%               Acquired with spm_vol & spm_read_vols commands
%               hdr = spm_vol(Ref_img);
%               [~, Ref_img_mmCoords] = spm_read_vols(hdr);
%

[rowsQuantity, ~] = size(Center_vox);
if rowsQuantity ~= 3
    Center_vox = Center_vox';
end
Center_mm = hdr.mat * [Center_vox; 1];

xs = Ref_img_mmCoords(1,:) - Center_mm(1);
ys = Ref_img_mmCoords(2,:) - Center_mm(2);
zs = Ref_img_mmCoords(3,:) - Center_mm(3);

radii = sqrt(xs.^2+ys.^2+zs.^2);
Sphere_Index = find(radii <= Radium);
