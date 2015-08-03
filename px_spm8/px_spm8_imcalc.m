function px_spm8_imcalc(fip,on,op,exp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% FORMAT  px_spm8_imcalc(fip,on,op,exp)
%    Usage    This function is used to calculate the imgae by calling spm8. 
%    input
%       fip  - full input path of the img file, cell format, e.g.,{'path1';'path2'}
%       on  - output file name, e.g., 'Amyg.img'.
%       op  - output path, e.g., '/data/...'.
%       exp - expression of calculation, e.g.,'i1 == 1';'i1+i2'
% 
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: Oct/20/2012 00:00:00
%==========================================================================
if ~exist(op,'dir');mkdir(op);end
if ischar(fip); fip = cellstr(fip);end
if iscell(op); op = char(op);end
%%
matlabbatch{1}.spm.util.imcalc.input = fip;
matlabbatch{1}.spm.util.imcalc.output = on;
matlabbatch{1}.spm.util.imcalc.outdir = {op};
matlabbatch{1}.spm.util.imcalc.expression = exp;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = -6;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
if length(on)>4
    if strcmpi(on(end-3:end), '.hdr') || strcmpi(on(end-3:end), '.img')  || strcmpi(on(end-3:end), '.nii')
        on = on(1:end-4);
    end
end
save(fullfile(op,on),'matlabbatch');
%%
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%