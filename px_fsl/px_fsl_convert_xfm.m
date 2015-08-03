function px_fsl_convert_xfm(fip,fop)
if ~exist(fip,'file');
    error('%s does not exist.');
end
if nargin == 1;
    [op on] =  fileparts(fip);
    on      = [on '_inverse.mat'];
    fop     = fullfile(op,on);
end
cmd = ['convert_xfm -omat ' fop ' -inverse ' fip  ];
display(cmd);
system(cmd);