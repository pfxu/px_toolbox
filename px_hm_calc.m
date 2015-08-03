function [HeadMotion] = px_hm_calc(fdp,op,on)
%========================================================================== 
%FORMAT [HeadMotion] = px_hm_calc(fdp,op,on)
% Input
%   on - subject ID/name
% Reference
% 1. Van Dijk, K.R., Sabuncu, M.R., Buckner, R.L., 2012. The influence of 
%    head motion on intrinsic functional connectivity MRI. Neuroimage 59, 431-438.
% 2. Power, J.D., Barnes, K.A., Snyder, A.Z., Schlaggar, B.L., Petersen, S.E., 
%    2012. Spurious but systematic correlations in functional connectivity MRI networks arise from subject motion. Neuroimage 59, 2142-2154. 
% Revised base on DPRASF by Pengfei Xu
% 
%Pengfei Xu, 2013/08/08,QC,CUNY
%==========================================================================    

HM = load(char(fdp));

maxHM = max(abs(HM));
maxHM(:,4:6) = maxHM(:,4:6)*180/pi;

meanHM = mean(abs(HM));
meanHM(:,4:6) = meanHM(:,4:6)*180/pi;

%root-mean-squared.
TRMS = sqrt(sum(HM(:,1:3).^2,2));% TranslationRMS
save(fullfile(op,['TRMS_',on,'.txt']), 'TRMS', '-ASCII', '-DOUBLE','-TABS');

% Calculate FD Van Dijk, relative RMS
FD_VanDijk = abs(diff(TRMS));
FD_VanDijk = [0;FD_VanDijk];
save(fullfile(op,['FD_VanDijk_',on,'.txt']), 'FD_VanDijk', '-ASCII', '-DOUBLE','-TABS');

% Calculate FD Power
HMDiff = diff(HM);
HMDiff = [zeros(1,6);HMDiff];
HMDiffSphere = HMDiff;
HMDiffSphere(:,4:6) = HMDiffSphere(:,4:6)*50;
FD_Power = sum(abs(HMDiffSphere),2);
save(fullfile(op,['FD_Power_',on,'.txt']), 'FD_Power', '-ASCII', '-DOUBLE','-TABS');

MeanTRMS = mean(TRMS);
MeanFD_VanDijk = mean(FD_VanDijk);
MeanFD_Power = mean(FD_Power);

% Head Motion Regressors
% Use the Friston 24-parameter model: current time point, the previous time point and their squares of rigid-body 6 realign parameters. e.g., Txi, Tyi, Tzi, ..., Txi-1, Tyi-1, Tzi-1,... and their squares (total 24 items).
% (Ref: Friston autoregressive model (Friston, K.J., Williams, S., Howard, R., Frackowiak, R.S., Turner, R., 1996. Movement-related effects in fMRI time-series. Magn Reson Med 35, 346-355.)
Friston24 = [HM, [zeros(1,size(HM,2));HM(1:end-1,:)], HM.^2, [zeros(1,size(HM,2));HM(1:end-1,:)].^2];
save(fullfile(op,['Friston24_',on,'.txt']), 'Friston24', '-ASCII', '-DOUBLE','-TABS');

HeadMotion = [maxHM,meanHM,MeanTRMS,MeanFD_VanDijk,MeanFD_Power];% Not Friston24
fprintf('.');