function px_dcm_anonymize_batch(dp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FORMAT px_dcm_anonymize_batch(dp,para)
%  Input
%   dp.ip         - input path of the dicom files.
%   dp.op         - output path of the dicom files.%   
%   para.protocol - Names of the protocol. e.g.,{'ANT-R','GNT','LAT','t1'};
%   para.Nruns    - Number of runs in corresponding protocol. e.g.,{4,4,2,1};
%   para.Nfiles   - Number of dicom files in each run of corresponding
%                   protocol. e.g.,{210,180,286,144};
%   para.subid    - subject id.
%   para.dcmtype  - dcicom data type. e.g., 'IMA','dcm',''(no suffix).
%   para.sname    - new subject ID for anonym.
% 
% Pengfei Xu, 09/07/2013, @QCCUNY.
%==========================================================================

%check input
if ~isfield(para,'sname')
    para.sname = [];
end
if ~isfield(para,'subid')
    para.subid = [];
    flag = 1;
end
if ~exist(dp.op,'dir');mkdir(dp.op);end

fprintf('\n    Dicom anonymize start:\n');
for p = 1: length(para.protocol)
    pi = fullfile(dp.ip, para.protocol{p});
    po = fullfile(dp.op, para.protocol{p});
    if ~exist(po,'dir');
        mkdir(po);
    end
    subdir = px_ls('Reg',pi,'-D',1);
    if flag == 1;
        para.subid{p} = 1:length(subdir);
    end
    for sub = para.subid{p}
        fprintf('Anonymize: %s\n',subdir{sub});
        [~, sname] = fileparts(subdir{sub});
        if isempty(para.sname);
            para.sname = sname;
        end
        subout = fullfile(po,sname);
        rundir = px_ls('Reg',subdir{sub},'-D',1);
        Nrun = length(rundir);
        for run = 1: Nrun
            fdp.dcm = px_ls('Reg',rundir{run},'-F',1,para.dcmtype);
            [~, rname] = fileparts(rundir{run});
            para.op = fullfile(subout,rname);
            px_dcm_anonymize(fdp,para);
        end
        fprintf(['Anonymize: ',subdir{sub},' to ',subout,'  done!\n']);
    end
end
fprintf('\n    Dicom anonymize done!');
end