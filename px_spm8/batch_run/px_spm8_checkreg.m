clear all
clc;

dp = '/media/WM/Projects/Project_006_TAModel/DataAnalysis/DataResults/ANT-R/ANT-R/';
subv = 25:30;
%%
fdp = cell(length(subv),1);
n = 0;
for s = subv
    n = n + 1;
    fdp{n,1} = fullfile(dp,[pre num2str('%03.0f',s)],'GLM_NoGlob','mask.img');
end
px_spm8_checkreg(fdp);