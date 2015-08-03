function px_spm8_report_results(SPMpath,ncon,threshdesc,thresh)
if ischar(threshdesc);threshdesc = cellstr(threshdesc);end
matlabbatch{1}.spm.stats.results.spmmat = {SPMpath};
for n = numel(ncon)
    matlabbatch{1}.spm.stats.results.conspec(n).titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec(n).contrasts = ncon(n);
    matlabbatch{1}.spm.stats.results.conspec(n).threshdesc = threshdesc{n};
    matlabbatch{1}.spm.stats.results.conspec(n).thresh = thresh(n);
    matlabbatch{1}.spm.stats.results.conspec(n).extent = 0;
    matlabbatch{1}.spm.stats.results.conspec(n).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
end
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = true;
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);