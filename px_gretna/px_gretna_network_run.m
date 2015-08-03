function px_gretna_network_run(Nsub)
% clear
% clc
dp = '/Volumes/Data/PX/DataAnalyzing/Resting/';
ip = fullfile(dp,'NetworkConstruct', 'FCMatrix');
op = fullfile(dp,'MNI_264NoGMC', 'GretnaMetrics');
con = 'BC';
% OutputDir = fullfile(dp, con,'ROI264NoGMC', 'GretnaMetrics');
group = {'1','2'};
% vector = {[1:6,8:14],1:28};
vector = {Nsub,Nsub};
% ModeList = {'SmallWorld'; 'Efficiency'; 'Modularity'; 'Assortativity';...
%     'Hierarchy'; 'Synchronization';'nodedegree';...
%     'NODEEFFICIENCY';'NODEBETWEENNESS'};
ModeList = {'efficiency'};% {'small_world'; 'modularity'; 'assortativity';...
    %'hierarchy'; 'synchronization';'nodedegree';'nodeefficiency';'nodebetweenness'};%'efficiency'; 
Para.ThresRegion = '0.05:0.01:0.5';
Para.ThresType = 's';
Para.NetType = 'b';
Para.ModulAlorithm = 'g';
Para.NumRandNet = 100;
for g = 2%: length(group)
    for SubjNum = vector{g}
        sn = [group{g},num2str(SubjNum,'%.3d')];
        Matrix = fullfile(ip,[sn '.txt']);
        px_gretna_network(Matrix , ModeList , Para , op , sn);
        fprintf(['Subject: ' sn ' Done! ................... \n']);
    end
end
% %Initialize Matlab Parallel Computing Enviornment
% CoreNum = 4;
% if matlabpool('size')<=0
%     matlabpool('open','local',CoreNum);
% else
%     disp('Already initialized');
% end
% matlabpool close