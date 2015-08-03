clear
clc
dp = ''; %input folders
op = ''; %output folders for the .ps files
sn = px_ls('Reg',dp,'-D',0);% subjects name
for s = 1: length(sn)
    rn = px_ls('Reg',dp,'-D',0);%runs name
    for r = 1: length(rn)
        sn = [sn{s},'_' rn{r}];
        ip = fullfile(dp,sn);
        px_hm_plot(ip,op,sn);
    end
end