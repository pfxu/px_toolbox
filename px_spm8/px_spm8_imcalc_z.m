function px_spm8_imcalc_z(x,y,para)

if ~exist(para.op,'dir');
    mkdir(para.op);
end
if size(x) > 1
    error('Too many x imgs: x should be only one img file.');
end
cwd = pwd;

para_m.op = para.mp;
para_m.on = para.mn;
px_spm8_imcalc_mean(y,para_m);

para_s.op = para.sp;
para_s.on = para.sn;
px_spm8_imcalc_std(y,para_s);

xV = spm_vol(x);
xY = spm_read_vols(xV);

m  = fullfile(para_m.op,para_m.on); 
mV = spm_vol(m);
mY = spm_read_vols(mV);

if xV.dim ~= mV.dim;
    error('Dim: x ~= y.');
end
if xV.mat ~= mV.mat;
    error('Mat: x ~= y.');
end

s  = fullfile(para_s.op,para_s.on);
sV = spm_vol(s);
sY = spm_read_vols(sV);

zY = (xY - mY)./sY;


oV = xV;
oV.dt(1) = 16;
oV.fname = para.on;
cd (para.op);
spm_write_vol(oV,zY);
cd(cwd);
fprintf('\nCalculate the z value done.');
return