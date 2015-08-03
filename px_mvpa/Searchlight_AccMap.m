
function Searchlight_AccMap(Img_Template, ROIAcc_Cell, ResultantFolder)

%
% ResultantFile:
%    .nii format, example: /data/s1/xy.nii
%    path of one of the subjects' image (for acquiring dimensions of subjects' images)
%
% ROIAcc_Cell:
%    Cell of Acc files for each ROI file
%

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

hdr = spm_vol(Img_Template);
Accuracy_Map = zeros(hdr.dim);

ROI_Accuracy = [];
for i = 1:length(ROIAcc_Cell)
    tmp = load(ROIAcc_Cell{i});
    ROI_Accuracy = [ROI_Accuracy tmp.ROI_Accuracy];    
end

for i = 1:length(ROI_Accuracy)
    Axis_x = ROI_Accuracy(i).Center_Vox(1);
    Axis_y = ROI_Accuracy(i).Center_Vox(2);
    Axis_z = ROI_Accuracy(i).Center_Vox(3);
    Accuracy_Map(Axis_x, Axis_y, Axis_z) = ROI_Accuracy(i).Accuracy;
end
save([ResultantFolder filesep 'Accuracy_Map.mat'], 'Accuracy_Map');
hdr.fname = [ResultantFolder filesep 'Accuracy_Map.nii'];
spm_write_vol(hdr, Accuracy_Map);



