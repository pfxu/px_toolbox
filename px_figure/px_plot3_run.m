% clear all
% clc
% load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/BehaviorData/behavior_stat');
% x = behavior.stat.STAI([1:2,6:10,12:18,20:25]);
% y = behavior.stat.FrameNum([1:2,6:10,12:18,20:25])';
% z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/LACCTC/VOI001.txt');
% px_mesh(x,y,z)
% % Xmax = max(x);
% % Xmin = min(x);
% % Ymax = max(y);
% % Ymin = min(y);
% % [X,Y] = meshgrid(linspace(Xmin,Xmax),linspace(Ymin,Ymax));
% % Z = griddata(x,y,z,X,Y,'v4');%interpolate
% % figure;
% % mesh(X,Y,Z);
% % hold on;
% % plot3(x,y,z,'r.','Marker','.','LineStyle','none','Color',[1 0 0]);
% % % Create xlabel
% xlabel({'STAI'});
% % Create ylabel
% ylabel({'FrameEffect'});
% % Create zlabel
% zlabel({'ACC activation'});

% clear all
% clc
% load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/BehaviorData/behavior_stat');
% x = behavior.stat.STAI([1:2,6:10,12:18,20:25]);
% y = behavior.stat.FrameNum([1:2,6:10,12:18,20:25])';
% %z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/AmygL/VOI001.txt');
% %z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/ACCR/VOI001.txt');
% %z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/AIR/VOI001.txt');
% %z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/vmPFCR/VOI001.txt');
% % z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/vmPFCL/VOI001.txt');
% % z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/mPFC/VOI001.txt');
% % z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/PCC/VOI001.txt');
% 
% z = load('/Volumes/Data/data/pengfeixu/DataAnalysis/young/TaskYoung/NoSeg_GlobCorr/Analysis/group_filter2/Interaction/ACCR2/VOI001.txt');
% px_mesh(x,y,z)
% % % Create xlabel
% xlabel({'STAI'});
% % Create ylabel
% ylabel({'FrameEffect'});
% % Create zlabel
% zlabel({'ACCR activation'});


clear all
clc
load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\BehaviorData\behavior_stat');
x = behavior.stat.STAI([1:2,6:10,12:18,20:25]);
y = behavior.stat.FrameNum([1:2,6:10,12:18,20:25])';
%z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\AmygL\VOI001.txt'); 
%z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\ACCR\VOI001.txt'); NOTGOOD
%z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\AIR\VOI001.txt');
%z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\vmPFCR\VOI001.txt');
% z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\vmPFCL\VOI001.txt');
%z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\mPFC\VOI001.txt');
 %z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\PCC\VOI001.txt');

% z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\AmygR\VOI001.txt');
z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\ACCL\VOI001.txt');
% z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\AIL\VOI001.txt');
% z = load('G:\TaskYoung\NoSeg_GlobCorr\Analysis\group_filter2\Interaction\Results_VOI\vmPFCL\VOI001.txt');
px_mesh(x,y,z)
% % Create xlabel
xlabel({'STAI'});
% Create ylabel
ylabel({'FrameEffect'});
% Create zlabel
zlabel({'AmygdalaR activation'});