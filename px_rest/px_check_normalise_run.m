clear all
clc
ip      = '/media/WM/Projects/Project_006_TAModel/DataAnalysis/DataResults/ANT-R/ANT-R';
para.op = fullfile(ip,'CheckNormalise');
if ~exist(para.op,'dir');mkdir(para.op);end
pre     = '10';
subdir  = 'run001';%'GLM_NoGlob';%
fn       = 'mask.img';%'*.img';%con_0035.img'

subs    = px_ls('reg',ip,'-D',1,pre);
para.id = px_ls('reg',ip,'-D',0,pre);
fdp     = cell(length(subs),1);
for s =  1: length(subs)
    fname = dir(fullfile(subs{s},subdir,fn));
    fdp{s,1} = fullfile(subs{s},subdir,fname(1).name);
end
px_check_normalise(fdp,para)