function [V] = px_spm8_imcalc_std(P,para)
cwd = pwd;

iV = spm_vol(P);

d4  = size(P,1);
dim = [iV(1).dim, d4];
Y4D = zeros(dim);

for d = 1:d4
    Y3D          = spm_read_vols(iV(d));
    Y4D(:,:,:,d) = Y3D;
end

sY = std(Y4D,0,4);

oV = iV(1);
oV.dt(1) = 16;
oV.fname = para.on;
cd (para.op);
[V] = spm_write_vol(oV,sY);
cd(cwd);
fprintf('\nCalculate the std value done.');
return