%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Configuration file for trial_by_trial_rsa_wholebrain.m
%-Created bt Jared and Shaozheng in Summer, 2013
%-Modified and unified by Shaozheng Qin on December 2, 2013
%-Added parellell processing by Shaozheng Qin on December 4, 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rsa_trialwise_roi_trained(ConfigFile)

disp('==================================================================');
disp('rsa_trialwise_roi.m is running');
fprintf('Current directory is: %s\n', pwd);
fprintf('Config file is: %s\n', ConfigFile);
disp('------------------------------------------------------------------');
disp('Send error messages to Shaozheng/Jared');
disp('==================================================================');
fprintf('\n');


CurrentDir = pwd;

ConfigFile = strtrim(ConfigFile);
addpath('/mnt/musk2/home/fmri/fmrihome/SPM/spm8/');
addpath('/mnt/musk2/home/fmri/fmrihome/SPM/spm8_scripts/');
addpath /home/fmri/fmrihome/SPM/spm8/toolbox/marsbar/;
addpath /home/fmri/fmrihome/SPM/spm8/toolbox/marsbar/spm5/;
addpath /home/fmri/fmrihome/SPM/spm8/

if ~exist(ConfigFile,'file')
  fprintf('Error: cnnot find the configuration file ... \n');
  return;
end

ConfigFile = ConfigFile(1:end-2);

eval(ConfigFile);

ServerPath   = strtrim(paralist.ServerPath);
SubjectList  = strtrim(paralist.SubjectList);
MapType      = strtrim(paralist.MapType);
MapIndex     = paralist.MapIndex;
SessCon      = paralist.SessCon;
MaskFile     = strtrim(paralist.MaskFile);
StatsFolder  = strtrim(paralist.StatsFolder);
OutputDir    = strtrim(paralist.OutputDir);
% SearchShape  = strtrim(paralist.SearchShape);
% SearchRadius = paralist.SearchRadius;
roi_folder   = strtrim(paralist.roi_folder);
roi_list     = strtrim(paralist.roi_list);

disp('-------------- Contents of the Parameter List --------------------');
disp(paralist);
disp('------------------------------------------------------------------');
clear paralist;

Subjects = ReadList(SubjectList);
NumSubj = length(Subjects);
nSS = SessCon(1);
nCon = SessCon(2);
%if NumMap ~= 2
%  error('Only 2 MapIndex are allowed');
%end

%Configure output file
outf = fullfile(OutputDir, 'roi_variability_output_trained.txt');
fid = fopen(outf, 'w');
fprintf(fid, 'columns correspond to ROIs, rows to subjects\n\n');

for iSubj = 1:NumSubj
  display(strcat('Processing subject: ', Subjects{iSubj}, '; ', int2str(iSubj), '/', int2str(length(Subjects))));
  DataDir = fullfile(ServerPath, ['20', Subjects{iSubj}(1:2)], Subjects{iSubj}, ...
    'fmri', 'stats_spm8', StatsFolder);
  
  spm_mat = load(fullfile(DataDir, 'SPM.mat'));
  SPM = spm_mat.SPM;
  
   design_mtx = SPM.xX.name;
  nReg = nCon + 6; %Number of regressors of each session
  
  cnt = 0;
  nCorr = 0;
  Indices = zeros(nSS*nCon,1);
  for i = 1:size(design_mtx,2)
        if length(design_mtx{i}) >= 17 %taking substring of "Sn(1) Trained_Acc_1*bf(1)"
            if strcmpi(design_mtx{i}(7:17), 'Trained_Acc')
                nCorr = nCorr + 1;
                if i < nReg 
                    CorrIndex(nCorr,1) = i; end
                if i >= nReg %for session 2
                    CorrIndex(nCorr,1) = i - 6; end  %Leaving out 6 movement regressors
                if i >= 2*nReg %for session 3
                    CorrIndex(nCorr,1) = i - 2*6; end %Leaving out 6 movement regressors
                if i >= 3*nReg %for session 4
                    CorrIndex(nCorr,1) = i - 3*6;  end %Leaving out 6 movement regressors
            end
        end
  end
     
  NumMap = nCorr;
  VY = cell(NumMap, 1);
  MapName = cell(NumMap, 1);
  
  switch lower(MapType)
    case 'tmap'
      for i = 1:NumMap
          VY{i} = fullfile(DataDir, SPM.xCon(CorrIndex(i)).Vspm.fname);
          MapName{i} = SPM.xCon(CorrIndex(i)).name;      
      end
    case 'conmap'
      for i = 1:NumMap
         VY{i} = fullfile(DataDir, SPM.xCon(CorrIndex(i)).Vcon.fname);
         MapName{i} = SPM.xCon(CorrIndex(i)).name;
      end
  end
  
  if isempty(MaskFile)
    VM = fullfile(DataDir, SPM.VM.fname);
  else
    VM = MaskFile;
  end
  
  OutputFolder = fullfile(OutputDir, Subjects{iSubj}, 'ROI');
  if ~exist(OutputFolder, 'dir')
    mkdir(OutputFolder);
  end
  %k = 1;
  numPairs = NumMap * (NumMap - 1)/2;
  
  %-ROI list

  if ~isempty(roi_list)
    ROIName = ReadList(roi_list);
    NumROI = length(ROIName);
    roi_file = cell(NumROI, 1);
    for iROI = 1:NumROI
      ROIFile = spm_select('List', roi_folder, ROIName{iROI});
      if isempty(ROIFile) 
        error('Folder contains no ROIs'); 
      end
      roi_file{iROI} = fullfile(roi_folder, ROIFile);
    end
  end
      
  roi_column = [];
  nroi = numel(roi_file);
  
  roi_file;
  ROIFile;

  for r = 1:nroi
      for i = 1:NumMap
          %for r=1:nroi % for each ROI
                   % setup ROI
                   roi_obj = maroi(roi_file{r});
                  %beta_voxelwise.roi_name{r} = label(roi_obj); % ROI names

                   roi_betascores{r} = getdata(roi_obj, VY{i}, 'l'); 
    %              roi_betascores{r}(isnan(roi_betascores{r})) = [];
    %              beta_average.data_roi_sess_event{r}{s}(e) = mean(roi_betascores(find(roi_betascores < inf)));
    %              %leave out NaNs in mean
         %  end
        roi_values = roi_betascores{r};
        roi_column{i} = reshape(roi_values,1,[]);
        roi_values = [];
      end

      CorrCoefs = zeros(NumMap, NumMap);
      %CorrCoefs = CorrCoefs + eye(NumMap);%Put the dianogal as 1
      for n = 1:NumMap
          for j = n+1:NumMap
              CoefMat = [];
              CoefMat = corrcoef(roi_column{n}, roi_column{j});
              CorrCoefs(n,j) = CoefMat(1,2);
          end
      end
      totals = 0;
      Zscores = 0;
      tempCorr = [];
      counter = 0;
      for m = 1:NumMap
          for j = m+1:NumMap
              totals = totals + CorrCoefs(m,j);
              %For Fisher's z-transformation     
              Zscores = Zscores + 0.5*log((1+CorrCoefs(m,j))/(1-CorrCoefs(m,j)));
              %counter = counter + 1;
              %tempCorr(counter) = CorrCoefs(m,j);
          end
      end
      average{r} = totals/numPairs;
      average_Zscore{r} = Zscores/numPairs;
      
      %average_normalized{r} = mean((tempCorr - mean(tempCorr))/std(tempCorr));
      CorrMatrix(iSubj, r).CorrCoefs = CorrCoefs + CorrCoefs' + eye(NumMap); %Put the dianogal as 1
  end

%  averages(numPairs, OutputFolder);
    fprintf(fid,'%s: \t', Subjects{iSubj});
    for yyz = 1:nroi 
        fprintf(fid,'%f\t', average{yyz}); %Raw averaged correlation scores
    end
    for yyz = 1:nroi
        fprintf(fid,'%f\t', average_Zscore{yyz}); %Fisher's Z scores
    end
%     for yyz = 1:nroi
%         fprintf(fid,'%d\t', average_normalized{yyz}); %Normalized Z scores
%     end
    fprintf(fid, '\n');
end

%save grandmean_CorrMatrix.mat CorrMatrix

fclose(fid);
disp('-----------------------------------------------------------------');
fprintf('Changing back to the directory: %s \n', CurrentDir);
cd(CurrentDir);
disp('ROI trial-by-trial RSA is done.');
clear all;;

end