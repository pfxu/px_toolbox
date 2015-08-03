
function Searchlight_Analysis(SubjectsData_Path, SubjectsLabel, All_ROIs_Path, Img_Template, ResultantFolder)

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
% Img_Template:
%     .nii format
%     path of one of the subjects' image (for acquiring dimensions of subjects' images)
% 

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

load (All_ROIs_Path);
ROIs_Quantity = length(All_ROIs);
Tasks_Quantity = ceil(ROIs_Quantity / 200);
% Split the whole job into 200 tasks
for i = 1:Tasks_Quantity
    ResultantFile = [ResultantFolder filesep 'ROI_Accuracy_' num2str(i) '.mat'];
    JobName = ['ROI_Accuracy_' num2str(i)];
    pipeline.(JobName).command              = 'Searchlight_OneTask(opt.SubjectsData_Path, opt.SubjectsLabel, opt.All_ROIs_Path, opt.Task_ID, opt.Pre_Method, opt.ResultantFile)';
    pipeline.(JobName).opt.SubjectsData_Path = SubjectsData_Path;
    pipeline.(JobName).opt.SubjectsLabel    = SubjectsLabel;
    pipeline.(JobName).opt.All_ROIs_Path    = All_ROIs_Path;
    pipeline.(JobName).opt.Task_ID          = i;
    pipeline.(JobName).opt.Pre_Method       = 'Normalize';
    pipeline.(JobName).opt.ResultantFile    = ResultantFile;
    pipeline.(JobName).files_out{1}         = ResultantFile;
end

JobName = 'Accuracy_Map';
pipeline.(JobName).command           = 'Searchlight_AccMap(opt.Img_Template, files_in, opt.ResultantFolder)';
for i = 1:Tasks_Quantity
    JobName_I = ['ROI_Accuracy_' num2str(i)];
    pipeline.(JobName).files_in{i}   = pipeline.(JobName_I).files_out{1};
end
pipeline.(JobName).opt.Img_Template  = Img_Template;
pipeline.(JobName).opt.ResultantFolder  = ResultantFolder;

% Pipeline_opt.mode = 'batch';
Pipeline_opt.mode = 'background';
Pipeline_opt.qsub_options = '-q another.q';
% Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.mode_pipeline_manager = 'background';
Pipeline_opt.max_queued = 4;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
Pipeline_opt.flag_update = 1;
Pipeline_opt.path_logs = [ResultantFolder filesep 'logs'];

psom_run_pipeline(pipeline,Pipeline_opt);

