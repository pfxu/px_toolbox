%function px_spm8_anova_factoral(op,factor,pre,vector)
% factor.n
% factor.l
% factor.d
% factor.v

clear
clc
matlabbatch{1}.spm.stats.factorial_design.dir = {'I:\Demo\2nd_level_factor'};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'seq';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).name = 'val';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(3).ancova = 0;
%%% factor matrix %%%%%%
mat = [];
for i = 1:2
    for j = 1:2
        for k = 1:2
            mat = [mat;i j k];
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%
nsub = 2;
ncon = j*k;
ncons = 0;
group = {'PT_';'NC_'};
for g = 1: length(group)
    for con = 1: ncon        
        ncons = ncons + 1;
        scan = {};
        for sub = 1:nsub
            scan = [scan;['I:\Demo\1st_level\' group{g} num2str(sub,'%03.0f') '_con_' num2str(con,'%04.0f') '.img,1']];
        end
        matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(ncons).levels = mat(ncons,:);
        matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(ncons).scans = scan;
    end
end
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
save matlabbatch
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);