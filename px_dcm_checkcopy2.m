function px_dcm_checkcopy2(ip,op,protocol,Nruns,Nfiles,vector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% px_checkcopy(ip,op,protocol,Nruns,Nfiles,vector)
% 
% ip = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataSortTask';
% op = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataReady';
% protocol = {'ANT-R','GNT','LAT','t1'};
% Nruns = {4,4,2,1};% Number of runs in corresponding protocol
% Nfiles = {210,180,286,144};% Number of dicom files in each run of corresponding protocol
% vector = {1:5,1:10,1};
% 
% Pengfei Xu, 12/22/2012, @BNU
% Revised by PX 07/15/2013, the error run will be not copied.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for p = 1: length(protocol)
    pi = fullfile(ip, protocol{p});
    po = fullfile(op, protocol{p});
    if ~exist(po,'dir');mkdir(po);end
    subdir = px_ls('Reg',pi,'-D',1);
    flist =  fopen(fullfile(po,'fileinfo.txt'),'a+');
    fid =  fopen(fullfile(po,'checkinfo.txt'),'a+');
    for sub = vector{p}
        [~, subname] = fileparts(subdir{sub});
        rundir = px_ls('Reg',subdir{sub},'-D',1);
        Nrun = length(rundir);
        if Nrun ~= Nruns{p} & Nrun ~= 0;%Nrun ~= 0, there is no sub-folder if only one run.
            fprintf(fid,'%s,  Nrun(%d) ~=  %0.0f  \n',subdir{sub},Nrun,Nruns{p});
            disp([subdir{sub},' Nrun(',num2str(Nrun),') ~= ', num2str(Nruns{p}), ', check your data!!!\n'])
        end
        for run = 1: Nrun
            filelist = px_ls('Reg',rundir{run},'-F',1);
            Nfile = length(filelist);
            if Nfile ~= Nfiles{p}
                fprintf(fid,'%s, Nfile(%d) ~=  %0.0f   \n ',rundir{run}, Nfile,Nfiles{p});
                disp([rundir{run},' Nfile(',num2str(Nfile),') ~= ', num2str(Nfiles{p}), ', check your data!!!\n'])
            else
                [~, runname] = fileparts(rundir{run});
                dirout = fullfile(po,subname,runname);
                if ~exist(dirout,'dir');mkdir(dirout);end
                copyfile(rundir{run},dirout);
                fprintf(flist,'%s    %s  \n',rundir{run},dirout);
            end
        end
        %         dirout = fullfile(po,subname);
        %                 if ~exist(dirout,'dir');mkdir(dirout);end
        %                 copyfile(subdir{sub},dirout);
        %                 fprintf(flist,'%s    %s  \n',subdir{sub},dirout);
        disp(['Copy & Check: ',subdir{sub},' to ',subout,'  done!']);
    end
end
fclose(fid);
fclose(flist);