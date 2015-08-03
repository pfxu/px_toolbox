clear
clc
% % % datapath = 'K:\NESDA\words_MJ\Prediction\MADRS\ANCOVA_Center_MADRS\FlexANOVA\EncodingPhase0809\';
% % % path{1,1} = 'K:\BFC\A1B1.txt';
% % % path{1,2} = 'K:\BFC\A1B2.txt';
% % % path{2,1} = 'K:\BFC\A2B1.txt';
% % % path{2,2} = 'K:\BFC\A2B2.txt';
% % % path{3,1} = 'K:\BFC\A3B1.txt';
% % % path{3,2} = 'K:\BFC\A3B2.txt';
%% The path for output 2nd level results.
datapath = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/';
%% Note: The order of the following 6 paths should be correct.
path{1,1} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A1B1'; %% group 1 condition 1
path{1,2} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A1B2'; %% group 1 condition 2
path{2,1} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A2B1'; %% group 1 condition 1
path{2,2} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A2B2'; %% group 2 condition 2
path{3,1} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A3B1'; %% group 1 condition 1
path{3,2} = '/data/local_share/huiai/Documents/NESDA/Script/secondlevel/Flexible_HCNONRE/encoding/A3B2'; %% group 3 condition 2
ng = size(path,1);
nc = size(path,2);
data = cell(ng,nc);
for g = 1:ng 
    for c = 1:nc
        data.img{g,c} = textread(path{g,c},'%s');
    end
end
% MADRS = load([datapath,'MADRS.txt']);
% BAIS = load([datapath,'BAIS.txt']);
% data.cov = [MADRS,BAIS];

para.p = fullfile(datapath,'group');
para.f = 'g'; 
px_spm8_anova_flex (para,data);

para.p = fullfile(datapath,'condition');
para.f = 'c'; 
px_spm8_anova_flex (para,data);