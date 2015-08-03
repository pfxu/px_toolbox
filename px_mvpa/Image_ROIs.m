
function Image_ROIs(Mask_img, Radium, ResultantFolder)

%
% For each voxel in the mask image, a sphere with this voxel as center will
% be acquired
%
% Mask_img:
%    The path of the mask image
%
% Radium:
%    Radium of the sphere
%

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

if ~exist(ResultantFolder)
    mkdir(ResultantFolder);
end

Vref = spm_vol(Mask_img);
dim1 = Vref.dim(1);
dim2 = Vref.dim(2);
dim3 = Vref.dim(3);

% Split the whole jobs into many small tasks
for i = 1:dim1
     
    JobName = ['ROI_' num2str(i)];
    ResultantFile = [ResultantFolder filesep 'ROI_' num2str(i) '.mat'];
    pipeline.(JobName).command = 'Image_ROIs_Child(opt.Mask_img, opt.dim1_Index, opt.dim2, opt.dim3, opt.Radium, opt.ResultantFile)';
    pipeline.(JobName).opt.Mask_img = Mask_img;
    pipeline.(JobName).opt.dim1_Index = i;
    pipeline.(JobName).opt.dim2 = dim2;
    pipeline.(JobName).opt.dim3 = dim3;
    pipeline.(JobName).opt.Radium = Radium;
    pipeline.(JobName).opt.ResultantFile = ResultantFile;
    pipeline.(JobName).files_out{1} = ResultantFile;

end

JobName_Merge = 'ROIs_Merge';
ResultantFile = [ResultantFolder filesep 'All_ROIs.mat'];
pipeline.(JobName_Merge).command = 'ROIs_Merge(files_in, files_out{1})';
for i = 1:dim1
    JobName_I = ['ROI_' num2str(i)];
    pipeline.(JobName_Merge).files_in{i} = pipeline.(JobName_I).files_out{1};
end
pipeline.(JobName_Merge).files_out{1} = ResultantFile;


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

