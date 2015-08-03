function px_dcm_sort_batch(dp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_dcm_sort_batch(dp,para)
% Input
%   dp.ip         - Input path of the dicom files.
%   dp.op         - Output path for the sorted dicom files.
%   para.mode     - The mode to run.{'sortrun','sorttask','checkcopy'};
%   para.dcmtype  - The File name prefix (e.g., 'sub') or surfix (e.g. 
%                   'IMA','dcm' or 'none') of the DICOM files. 
%   para.anonym   - Anonynize the personal information of the subject.
%                   - 0, No;
%                   - 1, Yes.
%   para.NIDs    - New subject ID, opiotnal,only used for anonym;
%   para.flag     - The Hierarchy of Directory:
%                   - 0, SubjectName/SeriesName;
%                   - 1, SeriesName/SubjectName.
%   para.vsub    - Subject id.
%   para.protocol - Names of the protocol. e.g.,{'ANT-R','GNT','LAT','t1'};
%   para.runnames - strings contrained in the run names. e.g., '_REST_' in
%                   the run of rest scanning.
%   para.Nruns    - Number of runs in corresponding protocol. e.g.,{4,4,2,1};
%   para.Nfiles   - Number of dicom files in each run of corresponding
%                   protocol. e.g.,{210,180,286,144};
%   para.vsubcc  - Subject id for check & copy. e.g.,{1:5,1:10,1};
% Output%
%  dcm_sort_batch.mat
%  New Directory
%   - DataSortRun,
%     - sort_run_info.log.
%   - DataSortTask,
%     - sort_task_info.log;
%     - sort_task_check.log.
%   - DataSortReady
%     - sort_copy_info.log;
%     - sort_check_info.log.
% Pengfei Xu, 05/09/2013, @QCCUNY
%==========================================================================

% if ~isfield(dp,'op'); dp.op = dp.ip;end
if ~exist(dp.op,'dir'); mkdir(dp.op);end
if ~isfield(para,'vsub'); para.vsub = [];end
for nm = 1: length(para.mode)
    flag = lower(para.mode{nm});
    switch flag
        case 'sortrun'
            dp_sr.ip        = dp.ip;
            dp_sr.op        = fullfile(dp.op,'DataSortRun');
            para_sr.vsub    = para.vsub;
            para_sr.dcmtype = para.dcmtype;
            para_sr.anonym  = para.anonym;
            para_sr.flag    = para.flag;
            px_dcm_sort_run(dp_sr,para_sr);
            dp.ip = dp_sr.op;
        case 'sorttask'
            dp_st.ip          = dp.ip;
            dp_st.op          = fullfile(dp.op,'DataSortTask');
            para_st.vsub      = para.vsub;
            para_st.tasknames = para.protocol;%%para.tasknames
            para_st.runnames  = para.runnames;
            px_dcm_sort_task(dp_st,para_st);
            dp.ip = dp_st.op;
        case'checkcopy'
            dp_cc.ip = dp.ip;
            dp_cc.op = fullfile(dp.op,'DataSortReady');
            if isfield(para,'vsubcc')
                para_cc.vsub = para.vsubcc;
            else
                para_cc.vsub = [];
            end
            para_cc.protocol = para.protocol;
            %para_cc.rname    = para.rname;
            para_cc.Nruns    = para.Nruns;
            para_cc.Nfiles   = para.Nfiles;
            px_dcm_checkcopy(dp_cc,para_cc);
    end
end
end

function px_dcm_sort_run(dp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_dcm_sort_run(ip,op,para)
%
% dp.ip - DataRaw
% dp.op - DataSortRun
% para.vsub - subject id.
%
% Pengfei Xu, 05/09/2013, @QCCUNY
%==========================================================================
para.op = dp.op;
if ~exist(para.op,'dir'); mkdir(dp.op);end
sublist = px_ls('Reg',dp.ip,'-D',1);
if isempty(sublist);error('No subject folders under %s.',dp.ip);end
if isempty(para.vsub)
    para.vsub = 1:length(sublist);
end
fprintf('\n    Dicom sort run start: \n');
for s = para.vsub
    sp = sublist{s};
    fprintf('\nSort: %s',sp);
    [fdp.dcm sts] = px_ls('Rec',sp,'-F',['^' para.dcmtype]);
    if sts == 0;
        [fdp.dcm sts]= px_ls('Rec',sp,'-F',['^*.*\.' para.dcmtype '$']);
    end    
    if sts == 0;error('there is no %s file under %s',para.dcmtype,sp);end
    if para.anonym == 1;
        if ~isfield(para,'names');
            [~,para.NIDs,~] = filparts(sp);
        else
            para.NIDs = para.names{s};
        end
    end
    px_dcm_sort(fdp,para);
end
ns = length(para.vsub);
fprintf('\n    Dicom sort run done, sorted %d subject(s).\n',ns);
end

function px_dcm_sort_task(dp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_dcm_sort_task(dp,para)
%
% dp.ip - DataSortRun
% dp.op - DataSortTask
%
% Pengfei Xu, 05/09/2013, @QCCUNY
%==========================================================================
if ~exist(dp.op,'dir'); mkdir(dp.op);end
sublist = px_ls('Reg',dp.ip,'-D',1);
if isempty(para.vsub)
    para.vsub = 1:length(sublist);
end
fprintf('\n    Dicom sort task start...\n');
for i = para.vsub
    fprintf('Sort: %s \n',sublist{i});
    runlist = px_ls('Reg',sublist{i},'-D',1);
    for j = 1: length(runlist)
        taskname = {};
        for r = 1: length(para.runnames)
            if ~isempty(regexp(runlist{j},para.runnames{r},'match'))
                taskname = para.tasknames{r};
            end
        end
        if isempty(taskname);
            flog =  fopen(fullfile(dp.op,'sort_task_check.log'),'a+');
            fprintf(flog,'%s is not match any task name \n',runlist{j});
            fclose(flog);
            continue;
        end
        [~,sname]  = fileparts(sublist{i});
        [~,rname]  = fileparts(runlist{j});
        taskdir = fullfile(dp.op,taskname);
        
        subjdir  = fullfile(taskdir,sname);
        if ~exist(subjdir,'dir');mkdir(subjdir);end
        rundir  = fullfile(taskdir,sname,rname);
        if isunix
            cmd = ['cp -R ' runlist{j} ' ' subjdir];% UNIX cp  will copy the FOLDER to the destination folder.
            system(cmd);
        else
            if ~exist(rundir,'dir'); mkdir(rundir);end
            copyfile(runlist{j},rundir);% MATLAB copyfile will copy the FILE under the folder to the destination folder.
            
        end
        fid =  fopen(fullfile(taskdir,'sort_task_copy.log'),'a+');
        fprintf(fid,'%s    %s  \n',runlist{j},rundir);%subjdir
        fclose(fid);
        fprintf(['Sort: ',runlist{j},' done!\n'])
    end
    ns = length(para.vsub);
end
fprintf('\n    Dicom sort task done, sorted %d subject(s).\n',ns);
end

function px_dcm_checkcopy(dp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_dcm_checkcopy(dp,para)
%
% dp.ip = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataSortTask';
% dp.op = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataReady';
% para.protocol = {'ANT-R','GNT','LAT','t1'};
% para.Nruns = {4,4,2,1};% Number of runs in corresponding protocol
% para.Nfiles = {210,180,286,144};% Number of dicom files in each run of corresponding protocol
% para.vsub = {1:5,1:10,1};
% para.rname = {'',''};
%
% Pengfei Xu, 12/22/2012, @BNU
% Revised by PX 07/15/2013, the error run will be not copied.
%==========================================================================

%check input
flag = 0;
if isempty(para.vsub);
    flag = 1;
end
fprintf('\n    Dicom check & copy start:\n');
for p = 1: length(para.protocol)
    pi = fullfile(dp.ip, para.protocol{p});
    po = fullfile(dp.op, para.protocol{p});
    if ~exist(po,'dir');
        mkdir(po);
    end
    flist  = fopen(fullfile(po,'sort_ready_copy.log'),'a+');
    fid    = fopen(fullfile(po,'sort_ready_check.log'),'a+');
    subjlist = px_ls('Reg',pi,'-D',1);
    if flag == 1;
        para.vsub{p} = 1:length(subjlist);
    end
    for sub = para.vsub{p}
        fprintf('Copy & Check: %s\n',subjlist{sub});
        [~, sname] = fileparts(subjlist{sub});
        subjdir     = fullfile(po,sname);
        if ~exist(subjdir,'dir');mkdir(subjdir);end
        runlist     = px_ls('Reg',subjlist{sub},'-D',1);
        Nrun = length(runlist);
        if Nrun ~= para.Nruns{p} && Nrun ~= 0;%Nrun ~= 0, there is no sub-folder if only one run.
            fprintf(fid,'%s,  Nrun(%d) ~=  %0.0f  \n',subjlist{sub},Nrun,para.Nruns{p});
            fprintf([subjlist{sub},' Nrun(',num2str(Nrun),') ~= ', num2str(para.Nruns{p}), ', check your data!!!\n'])
        end
        for run = 1: Nrun
            %filelist = px_ls('Reg',runlist{run},'-F',1);
            filelist = px_ls('Rec',runlist{run},'-F');
            Nfile    = length(filelist);
            if Nfile ~= para.Nfiles{p}
                fprintf(fid,'%s, Nfile(%d) ~=  %0.0f   \n ',runlist{run},Nfile,para.Nfiles{p});
                fprintf([runlist{run},' Nfile(',num2str(Nfile),') ~= ', num2str(para.Nfiles{p}), ', check your data!!!\n'])
            else
                [~, rname] = fileparts(runlist{run});
                rundir = fullfile(subjdir,rname);
                if isunix
                    cmd = ['cp -R ' [runlist{run}] ' ' subjdir];% UNIX cp  will copy the FOLDER to the destination folder.
                    system(cmd);
                else
                    if ~exist(rundir,'dir');mkdir(rundir);end
                    copyfile(runlist{run},rundir);% MATLAB copyfile will copy the FILE under the folder to the destination folder.
                end
                fprintf(flist,'%s    %s  \n',runlist{run},rundir);
            end
        end
        fprintf(['Copy & Check: ',subjlist{sub},' to ',subjdir,'  done!\n']);
    end
    fclose(fid);
    fclose(flist);
end
fprintf('\n    Dicom check & copy done!');
end