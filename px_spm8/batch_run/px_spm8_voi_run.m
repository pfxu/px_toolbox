% % clear
% % clc
% op              = '/Volumes/Data/PX/TAConnect/Demo';
% dp              = fullfile(op,'FunImgARCWF');
% % dp = '/Volumes/Data/PX/TAConnect/Demo/FunImgA/';
% para.op         = fullfile(op,'TCMatrix');%output path of the time series .mat file.
% para.mn    = 'ROI264.nii';
% para.vt         = 'r';
% para.mt         = 's';
% para.XYZmm              = load(fullfile(px_toolbox_root,'templates','ROI264.txt'));
% para.R  = 10;
% vs = 2:3;
% presub = '1';
% para.dt = '.nii';
% para.mt = 's';
% for ns = 2%vs
%     sn = [presub num2str(ns,'%03.0f')];
%     sp = fullfile(dp,sn);
%     fdp.P           = spm_select('ExtFPList',sp, '^F.*\.nii$');
%     VOITC = px_spm8_voi(fdp,para);
%     save (fullfile(op,'TCMatrix',[num2str(sn),'VOITC']),'VOITC');
% end

clear
clc
dp          = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Left';
op          = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\ROIs';
para.op     = fullfile(op,'volumes');%output path of the time series .mat file.
para.vt     = 'r';
para.mt     = 'm';
fdp.T       = 'G:\Projects\Cooperation_005_HearLoss\DataAnalysis\t1Results\Mask\Heschl_Resliced\Resliced_Heschl_L.nii';
para.ROIInd = 1;
vs = [1:7,9:17,19,22:24,30];
presub = 'Sub_1';
para.dt = '.img';
for ns = vs
    sn = [presub num2str(ns,'%03.0f')];
    sp = fullfile(dp,sn,'t1');
    fdp.P           = spm_select('ExtFPList',sp, '^sm0wrp1s.*\.nii$');
    VOI_volume = px_spm8_voi(fdp,para);
    save (fullfile(op,'Heschl_L',[num2str(sn),'VOI']),'VOI_volume');
end