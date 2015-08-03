% clear
% clc
% PI = 'G:\XPF\DataAnalysis\TaskYoung\Mask\Amyg.img';
% PO = 'G:\XPF\DataAnalysis\TaskYoung\Mask\Reslice';
% TargetSpace = 'G:\XPF\DataAnalysis\RestYoung\DataAnalysis\Results\FC\ROI1FCMap_Sub001.img';
% rest_ResliceImage(PI,PO,[2 2 2],0,TargetSpace);

% clear
% clc
% PI = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\ACC.img';
% PO = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask\Rescliced_ACC.img';
% if ~exist(fileparts(PO),'dir');mkdir(fileparts(PO));end
% TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
% rest_ResliceImage(PI,PO,[2 2 2],0,TargetSpace);

% clear
% clc
% pathin = 'I:\DataAnalysis\TaskYoung\TYNoSeg\PPI\Mask';
% imglist = px_ls(pathin,'-F',1,'.img');
% for i = 1: length(imglist)
%     pathout = fullfile(pathin,'Resliced');
%     if ~exist(pathout,'dir');mkdir(pathout);end
%     [p imgname ext] = fileparts(imglist{i});
%     imgout = fullfile(pathout,[imgname ext]);
%     TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
%     rest_ResliceImage(imglist{i},imgout,[2 2 2],0,TargetSpace);
%     disp(['Reslice:' imglist{i},' >>>> ',imgout,' done!']);
% end
% 
% clear
% clc
% pathin = 'I:\DataAnalysis\TaskYoung\NoSeg_GlobCorr\PPI\Mask\';
% imglist = px_ls(pathin,'-F',1,'.img');
% for i = 1: length(imglist)
%     pathout = fullfile(pathin,'Resliced');
%     if ~exist(pathout,'dir');mkdir(pathout);end
%     [p imgname ext] = fileparts(imglist{i});
%     imgout = fullfile(pathout,[imgname ext]);
%     TargetSpace = 'I:\DataAnalysis\TaskYoung\TYNoSeg\group_filter2\Interaction\1sampleT\con_0002.img';
%     rest_ResliceImage(imglist{i},imgout,[2 2 2],0,TargetSpace);
%     disp(['Reslice:' imglist{i},' >>>> ',imgout,' done!']);
% end

clear
clc
pathin = 'I:\Demo\Mask\';
imglist = px_ls('Reg',pathin,'-F',1,'.img');
for i = 1: length(imglist)
    pathout = fullfile(pathin,'Resliced_2');
    if ~exist(pathout,'dir');mkdir(pathout);end
    [p imgname ext] = fileparts(imglist{i});
    imgout = fullfile(pathout,[imgname ext]);
    TargetSpace = 'I:\Demo\con_0001.img';
    px_spm8_reslice_image(imglist{i},imgout,[3 3 3],0,TargetSpace);
%     rest_ResliceImage(imglist{i},imgout,[2 2 2],0,TargetSpace); 
%     disp(['Reslice:' imglist{i},' >>>> ',imgout,' done!']);
end