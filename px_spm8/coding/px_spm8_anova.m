% function px_spm8_anova(ip,op,factor,pre,sv,iv,flag)
factor.n = {'group','seq','val'};
factor.l = [2 2 2];
% % factor.d
% % factor.v
% % sv vector of subject;
% % iv vector of image;
% % pre = {'PT_';'NC_'};
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % nsub = lenth(vector);
nfac = length(factor.n);
% for f = 1:nfac
%     nlev = length(factor.l);
%     for l = 1:nlev
%     end
% end
% matlabbatch{1}.spm.stats.factorial_design.dir = {op};
% for f = 1:nfac
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).name = factor.n{f};
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).levels = factor.l(f);
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).dept = factor.d(f);
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).variance = factor.d(f);
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).gmsca = 0;
%     matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(f).ancova = 0;
% end
% %%%---------------------------------------------------------------------%%%
mat = [];
ncon = 0;
for f = 1:nfac
    nlev = factor.l(f);
    for lev = 1:nlev 
        ncon = ncon +1;
            mat(ncon,f) = lev
    end
end
ncon = 0;
for f = 1:nfac
    nlev = length(factor.l);
    for l = 1:nlev      
        ncon = ncon + 1;
%         mat = [mat factor.l(l)];
        scan = {};
        for sub = sv
            scan = [scan;[ip pre{g} num2str(sub,'%03.0f') '_con_' num2str(iv(con),'%04.0f') '.img,1']];
%             spm_select('ExtFPList',ip, '^w.*\.img$');
        end
        matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(ncon).levels = mat(ncon,:);
        matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(ncon).scans = scan;
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
save(fullfile(op,'anova_matlabbatch'));
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);