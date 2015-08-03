function dirlist = px_dcm_sort(fdp,para)
% FORMAT dirlist = px_dcm_sort(fdp,para)
%   Input:
%     fdp.dcm      - The full input path of dicom files
%     para.op      - The output directory for the sorted dir
%     para.anonym  - Anonynize the personal information of the subject.
%                    - 0, No;
%                    - 1, Yes.
%     para.NIDs    - New subject ID, opiotnal,only used for anonym;
%     para.flag    - The Hierarchy of Directory:
%                    - 0, SubjectName/SeriesName;
%                    - 1, SeriesName/SubjectName.
%     para.ncore   - number of parallel working
%   Output:
%     - *.IMA/*.dcm/*.*, Sorted DICOM images.
%     - sort_run_info.log
% 
% Pengfei Xu, Reveised from REST, 2012/09/01,BNU
% Revised by PX 10/12/2013, revised info.ProtocolName to  info.SeriesDescription
%------------------------------------------------------------------------------------------------------------------------------
if ~exist(para.op,'dir');mkdir(para.op);end
if ~isfield(para,'ncore');para.ncore = 0;end

if para.anonym == 1;
    px_dcm_anonymize(fdp,para);
end
flag = para.flag;
op = para.op;
dirlist = {};
% fid = fopen (fullfile(para.op,'sort_run_info.log'),'a+');
% fprintf(fid, [repmat('-',1,30) datestr(clock,31) repmat('-',1,30) '\n']);
if  matlabpool('size') > 0;matlabpool('close');end
matlabpool(para.ncore);
parfor i = 1:length(fdp.dcm)
    info = dicominfo(fdp.dcm{i});
    study_id      = num2str(info.StudyID);
    series_number = num2str(info.SeriesNumber,'%03.0f');
    series_name   = regexprep(info.SeriesDescription,'\W','_');%[^a-zA-Z0-9] %info.ProtocolName
    if isfield(info,'SeriesDate')
        series_date   = regexprep(info.SeriesDate,'\W','_');
    elseif isfield(info,'ContentDate')
        series_date   = regexprep(info.ContentDate,'\W','_'); % for series no SeriesDate
    end
    subject_name  = regexprep(info.PatientID,'\W','_');
    if flag == 0
        dirname = [op,filesep,subject_name,filesep,study_id,'_',series_number,'_',series_name,'_',series_date];
    else
        dirname = [op,filesep,study_id,'_',series_number,'_',series_name,'_',series_date,filesep,subject_name];
    end
    if ~isdir(dirname)
        mkdir(dirname);
        %dirlist = [dirlist;dirname];
    end
    copyfile(fdp.dcm{i},dirname);
%     fprintf(fid,'%s          %s \n',fdp.dcm{i},dirname);
    fprintf('.');
end
matlabpool close;
fprintf('\n');
% fprintf(fid, [repmat('-',1,70) '\n']);
% fclose(fid);