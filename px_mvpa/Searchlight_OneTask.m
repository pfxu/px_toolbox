
function Searchlight_OneTask(SubjectsData_Path, SubjectsLabel, All_ROIs_Path, Task_ID, Pre_Method, ResultantFile)

%
% SubjectsData_Path:
%     .mat file with a matrix n*m (n is quantity of subjects, m is quantity of features)
%
% Can be acquired using commands listed:
%
% NC_Cell = g_ls('/data/s1/cuizaixu/DATA_ShuHua_Dyslexia_NCRandom/GMV/NC/*nii');
% Dyslexia_Cell = g_ls('/data/s1/cuizaixu/DATA_ShuHua_Dyslexia_NCRandom/GMV/Dyslexia/*nii');
% SubjectsImg_Path = [NC_Cell; Dyslexia_Cell];
% SubjectsData = [];
% for i = 1:length(SubjectsImg_Path)
%     Vref = spm_vol(SubjectsImg_Path{i});
%     Data = spm_read_vols(Vref);
%     Data = reshape(Data, 1, Vref.dim(1)*Vref.dim(2)*Vref.dim(3));
%     SubjectsData = [SubjectsData; Data];
% end
% save /data/s1/cuizaixu/DATA_ShuHua_Dyslexia_NCRandom/GMV/SubjectsData.mat SubjectsData;
%
% SubjectsLabel:
%     array of -1 or 1
%
% All_ROIs_Path:
%     acquired from function Image_ROIs function
%
% Task_ID:
%     which task in the whole jobs, see code of Searchlight_Analysis.m
%
% Pre_Method:
%     'Normalize' of 'Scale'
% 

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

load (SubjectsData_Path);
load (All_ROIs_Path);

% SubjectsData = [];
% for i = 1:length(SubjectsImg_Path)
%     hdr = spm_vol(SubjectsImg_Path{i});
%     Data = spm_read_vols(hdr);
%     Data = reshape(Data, 1, hdr.dim(1)*hdr.dim(2)*hdr.dim(3));
%     SubjectsData = [SubjectsData; Data];
% end

ROIs_Quantity = length(All_ROIs);
num = 0;
if Task_ID * 200 <= ROIs_Quantity
    Job_End = Task_ID * 200;
else
    Job_End = ROIs_Quantity;
end
for i = (Task_ID - 1) * 200 + 1 : Job_End
    num = num + 1;
    ROI_Data = SubjectsData(:, All_ROIs(i).Neighbor_Index);
    ROI_Accuracy(num).Center_Vox = All_ROIs(i).Center_Vox;
    [ROI_Accuracy(num).Accuracy ROI_Accuracy(num).Sensitivity ROI_Accuracy(num).Specificity] = SVM_2group_ForSL(ROI_Data, SubjectsLabel, Pre_Method);
end

save(ResultantFile, 'ROI_Accuracy');