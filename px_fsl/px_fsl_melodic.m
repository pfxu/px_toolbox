function px_fsl_melodic(fdp,para)
% fdp.scan - see melodic -i
% fdp.mask - see melodic -m
% para.op  - see melodic -o
% para.tr  - see melodic -tr
% fdp.Sdes - see melodic --Sdes
% fdp.Scon - see melodic --Scon

if ~exist(para.op,'dir');mkdir(para.op);end
cmd = ['melodic -i  ' fdp.scan ' -o ' para.op ' -m ' fdp.mask ...
       ' --nobet --report --tr=' num2str(para.tr) ' --Oall -v -a concat'];
      %' -f 0 --Sdes=' fdp.Sdes ' --Scon=' fdp.Scon
fprintf('%s',cmd);
system(cmd);