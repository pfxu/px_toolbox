%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-Configuration file for trial_by_trial_rsa_wholebrain.m
%-Created bt Jared and Shaozheng in Summer, 2013
%-Modified and unified by Shaozheng Qin on December 2, 2013
%-Added parellell processing by Shaozheng Qin on December 4, 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please specify the path to the folder holding subjects
paralist.ServerPath = '/fs/musk2';

%paralist.RawDataPath = '/fs/musk1';

% Plese specify the list of subjects or a cell array
%paralist.SubjectList = {'11-07-20.2', '06-05-31.1', '06-06-09-1'}%previously list.txt
%paralist.SubjectList = 'SI_subjectlist_n22.txt';
paralist.SubjectList = {'12-02-25.1_3T2'};%,'12-03-11.1_3T2','12-03-18.1_3T2','12-03-24.1_3T2','12-04-08.1_3T2'};

% Please specify the stats folder name from SPM analysis
paralist.StatsFolder = 'stats_spm8_4runs_swar_noderiv_single_trial';

% Please specify whether to use t map or beta map ('tmap' or 'conmap')
paralist.MapType = 'conmap';

% Please specify the index of tmap or contrast map (only 2 allowed)
% If the second t map is spmT_0003.img, the number is 3 (from 003) in the 
% second slot
paralist.SessCon = [4, 14]; %Number of sessions and number of contrasts each session
paralist.MapIndex = [1:1:56];
%previously paralist.MapIndex = [1,3];

% Please specify the mask file, if it is empty, it uses the default one from SPM.mat
paralist.MaskFile = '';

% Please specify the path to the folder holding analysis results
paralist.OutputDir = '/fs/apricot1_share1/intervention/shortIntervention/similarity/trial_by_trial_RSA/RSA/participants/Trained';

% Please specify the folder (full path) holding defined ROIs
paralist.roi_folder= '/fs/apricot1_share1/intervention/shortIntervention/similarity/trial_by_trial_RSA/RSA/ROIs';

% Please specify roi list file (with file name extensions)
%paralist.roi_list = 'list_rois.txt';
paralist.roi_list = 'list_rois.txt';
