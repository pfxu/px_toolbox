function px_fsl_flirt_applyxfm(fip,fref,fop,fmat)
if ~exist(fip,'file');
    error('%s does not exist.');
end
cmd = ['flirt -in ' fip ' -ref ' fref ' -out ' fop ' -applyxfm -init ' fmat];
display(cmd);
system(cmd);