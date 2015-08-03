
function Image_ROIs_Child(Mask_img, dim1_Index, dim2, dim3, Radium, ResultantFile)

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

hdr = spm_vol(Mask_img);
[Data, mmCoords] = spm_read_vols(hdr);

num = 0;
for j = 1:dim2
    for k = 1:dim3
        
        if Data(dim1_Index, j, k) & ~isnan(Data(dim1_Index, j, k))
            num = num + 1;
            Sphere_ROI(num).Center_Vox = [dim1_Index j k];
            Sphere_ROI(num).Center_index = sub2ind(size(Data), dim1_Index, j, k);
            Sphere_ROI(num).Neighbor_Index = gen_ROI(Sphere_ROI(num).Center_Vox, Radium, hdr, mmCoords);
        end
        
    end
end

if ~num
    Sphere_ROI = '';
end

save(ResultantFile, 'Sphere_ROI');