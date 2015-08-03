% % % clear all
% % % clc
% % % %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% % % %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% % % P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% % % %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% % % XYZmm = [-5, 30, 30];
% % % radius = 6;
% % % Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/LACCTC';
% % % if ~exist(Output,'dir'); mkdir(Output);end
% % % for i = 1:size(XYZmm,1)
% % %        VOIname = ['VOI',num2str(i,'%03.0f')];
% % %        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% % % end
% %
% %
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-24, -4, -10];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/AmygL';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [16, 22, 30];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/ACCR';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [36,18,10];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/AIR';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [22 42 4];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/vmPFCR';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-18 38 -6];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/vmPFCL';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-4 28 58];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/mPFC';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-2 -36 32];
% radius = 6;
% P = spm_select('ExtFPList','/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction', '^Sub.*\.img$');
% Output = '/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/PCC';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end

%% Coherence VOI
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [11, -54, 17];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [5,23,27];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCACC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [36,22,3];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCAI/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [26,-11,40];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCWM/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

%% left
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-11, -54, 17];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCPCC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-5,23,27];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCACC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-36,22,3];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCAI/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-26,-11,40];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCWM/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

%% R10
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [11, -54, 17];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCPCC10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [5,23,27];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCACC10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [36,22,3];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCAI10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [26,-11,40];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCWM10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
%% LEFT10
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-11, -54, 17];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCPCC10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-5,23,27];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCACC10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-36,22,3];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCAI10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [-26,-11,40];
% radius = 10;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/LTCWM10/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

%% R Activation
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [8,-56,28];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCPCCActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [6,6,44];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCACCActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [32,18,4];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCAIActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

% clear all
% clc
% %[pathstr, name, ext] = fileparts(which('px_toolbox'));
% %Textfile = '/data/Experiment/px_function/Template/MNI_Coordinates_264.txt';
% %XYZmm = load([pathstr,filesep,'Template',filesep,'MNI_Coordinates_264.txt']);
% XYZmm = [36,-20,30];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',['/Volumes/Data/data/rsfMRI/07_0699/analysis_SPMDPARSFCOV_Glob_0112/analysis/2',num2str(i,'%03.0f'),'/run1/'], '^swraf.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence/TCWMActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

%% R 264 regress out WM
%
% clear all
% clc
% imagepath = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/FunImgNormalizedSmoothedDetrendedCovremoved/';
% XYZmm = [11, -54, 17];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_CR_264/TCPCC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% XYZmm = [5,23,27];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_CR_264//TCACC/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% XYZmm = [36,22,3];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_CR_264//TCAI/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% XYZmm = [26,-11,40];
% radius = 5;
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_CR_264//TCWM/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

%% R Activation regress out WM 4mm
% clear all
% clc
% imagepath = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/FunImgNormalizedSmoothedDetrendedCovremoved/';
% radius = 4;
%
% %PCC
% XYZmm = [8,-56,28];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_4mm/TCPCCActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% %ACC
% XYZmm = [6,6,44];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_4mm/TCACCActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % AI
% XYZmm = [30,20,6];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_4mm/TCAIActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % WM
% XYZmm = [36,-20,30];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = '/Volumes/Data/data/rsfMRI/07_0699/Coherence_4mm/TCWMActivzation/';
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

% %% R Activation regress out WM 3mm
% clear all
% clc
% imagepath = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/FunImgNormalizedSmoothedDetrendedCovremoved/';
% radius = 3;
%
% %PCC
% XYZmm = [8,-56,28];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCPCC/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% %ACC
% XYZmm = [6,6,44];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCACC/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % AI
% XYZmm = [30,20,6];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCAI/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % WM
% XYZmm = [36,-20,30];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCWM/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
% %% R Activation regress out WM 10mm
% clear all
% clc
% imagepath = '/Volumes/Data/data/rsfMRI/07_0699/DPARSF_S8V2_test_0112/FunImgNormalizedSmoothedDetrendedCovremoved/';
% radius = 10;
%
% %PCC
% XYZmm = [8,-56,28];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCPCC/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
%
% %ACC
% XYZmm = [6,6,44];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCACC/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % AI
% XYZmm = [30,20,6];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCAI/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end
%
% % WM
% XYZmm = [36,-20,30];
% for i = [1,3:7,10:18]
% P = spm_select('ExtFPList',[imagepath,'2',num2str(i,'%03.0f'),'/'], '^.*\.img$');
% Output = ['/Volumes/Data/data/rsfMRI/07_0699/Coherence_Activzation_',num2str(radius,'%03.0f'),'mm/TCWM/'];
% if ~exist(Output,'dir'); mkdir(Output);end
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm, radius, P);
% end

% clear all
% clc
% XYZmm = [-32, -2, -22];
% radius = 5;
% P = spm_select('ExtFPList','G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\', '^Sub.*\.img$');
% Output = 'G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\AmygR';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
% clear all
% clc
% XYZmm = [-2, 32, 32];
% radius = 5;
% P = spm_select('ExtFPList','G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\', '^Sub.*\.img$');
% Output = 'G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\ACCL';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
% clear all
% clc
% XYZmm = [-36, 18, 4];%[-42, 26, 0];
% radius = 5;
% P = spm_select('ExtFPList','G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\', '^Sub.*\.img$');
% Output = 'G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\AIL';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%
% clear all
% clc
% XYZmm = [-8, 42, 4];%[-8, 52, 4];
% radius = 5;
% P = spm_select('ExtFPList','G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\', '^Sub.*\.img$');
% Output = 'G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\vmPFCL';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end

%% repeat
% clear all
% clc
% XYZmm = [2, -28, 30];%[-8, 52, 4];
% radius = 5;
% P = spm_select('ExtFPList','I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis', '^con_0019\.img$');
% Output = 'I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis\ROI_PCC';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['1st',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
% clear all
% clc
% XYZmm = [2, -28, 30];%[-8, 52, 4];
% radius = 5;
% P = spm_select('ExtFPList','I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis', '^con_0021\.img$');%%'^con_0019\.img$'
% Output = 'I:\DataAnalysis\Runing\Lesion\Repeat\fMRI\DataAnalysis\sub001\Analysis\ROI_PCC';
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['2nd',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P)
% end
%%
% clear all
% clc
% XYZmm = [-24 -4 -10];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\AmygL');
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end
%
% clear all
% clc
% XYZmm = [14,20,32];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\ACCR');
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end
%
% clear all
% clc
% XYZmm = [36,18,10];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\AIR');
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end
%
% clear all
% clc
% XYZmm = [-40,10,2];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\AIL');
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end
% clear all
% clc
% XYZmm = [24,32,30];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\vmPFCR'); %%% mPFCR
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end

% clear all
% clc
% XYZmm = [-8,8,36];
% radius = 5;
% DataPath = 'H:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% Output = fullfile(DataPath,'ROIs\ACCL');
% if ~exist(Output,'dir'); mkdir(Output);end
% for i = 1:size(XYZmm,1)
%        VOIname = ['VOI',num2str(i,'%03.0f')];
%        px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end

%% 07/12/2013
% clear all
% clc
% XYZmm = [-14 2 -24;12 2 -20;-2 8 56;2 24 44];
% VOIs = {'AmygL';'AmygR';'ACCL';'ACCR'};
% radius = 5;
% DataPath = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% for i = 1:size(XYZmm,1)
%     VOIname = VOIs{i};
%     Output = fullfile(DataPath,'ROIs_PreDefined',VOIname);
%     if ~exist(Output,'dir'); mkdir(Output);end
%     px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end

% clear all
% clc
% XYZmm = [-14 2 -24;12 2 -20;-2 8 56;2 24 44];
% VOIs = {'AmygL';'AmygR';'ACCL';'ACCR'};
% radius = 10;
% DataPath = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% for i = 1:size(XYZmm,1)
%     VOIname = VOIs{i};
%     Output = fullfile(DataPath,'ROIs_PreDefined_10mm',VOIname);
%     if ~exist(Output,'dir'); mkdir(Output);end
%     px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end

% clear all
% clc
% XYZmm = [-24 -4 -10;14 20 32];
% VOIs = {'AmygL';'ACCR'};
% radius = 10;
% DataPath = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/';
% P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
% for i = 1:size(XYZmm,1)
%     VOIname = VOIs{i};
%     Output = fullfile(DataPath,'ROIs_10mm',VOIname);
%     if ~exist(Output,'dir'); mkdir(Output);end
%     px_VOITC (Output,VOIname, XYZmm(i,:), radius, P);
% end

clear all
clc
XYZmm = [-24 -4 -10;14 20 32];
VOIs = {'AmygL';'ACCR'};
radius = 10;
DataPath = '/Volumes/Data/PX/Disk/DataAnalyzing/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/';
P = spm_select('ExtFPList',DataPath, '^Sub.*\.img$');
for i = 1:size(XYZmm,1)
    VOIname = VOIs{i};
    Output = fullfile(DataPath,'ROIs_10mm',VOIname);
    if ~exist(Output,'dir'); mkdir(Output);end
    px_mean_tc_voi (Output,VOIname, XYZmm(i,:), radius, P);
end