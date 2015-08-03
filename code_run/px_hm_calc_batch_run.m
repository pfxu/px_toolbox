clear
clc
para.ip = '/Volumes/Data/PX/TAModel/DataAnalysis/DataResults/GNT/GNT'; % input folders
para.op = '/Volumes/Data/PX/TAModel/DataAnalysis/DataResults/GNT/GNT/HeadMotion'; % output path
%%
fdp.rp  = [];
sp      = px_ls('Reg',para.ip,'-D',1);%runs name
m       = 0;
for s = 1: length(sp)-2
    m     = m + 1;
    rpath = px_ls('Reg',sp{s},'-D',1);%runs name
    n = 0;
    for r = 2: length(rpath)
        n           = n + 1;
        fdp.rp{m,n} = px_ls('Reg',rpath{r},'-F',1,'rp');%runs name
        if isempty(fdp.rp{m,n}); error('No rp*.txt file under %',rpath{r});end
    end
end
px_hm_calc_batch(fdp,para);