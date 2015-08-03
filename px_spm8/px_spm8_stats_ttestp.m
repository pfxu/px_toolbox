function px_spm8_stats_ttestp(op,cond,vector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FROMAT  px_spm8_stats_ttestp(op,cond,vector)
%  Usage  paired t-test
%  op = '/Volumes/Data/data/PairedT';
% 
%  cond.path.a = '/Volumes/Data/data/cond1';
% 
%  cond.path.b = '/Volumes/Data/data/cond2';
% 
%  cond.dataname.a = 'cond1';
% 
%  cond.dataname.b = 'cond2';
%
%  cond.testname.a = 'cond1_con2';
% 
%  cond.testname.b = 'cond2_con1';
%
%  vector = [1,3:7,10:18];
%  
%  Pengfei Xu, QCCUNY, Nov 23rd, 2011
%==========================================================================
if  isempty(cond.dataname.a)
    cond.dataname.a = []; cond.dataname.b = []; 
    cond.testname.a = 'Cond1'; cond.testname.b = 'Cond2';
elseif isempty(cond.testname.a)
    if strcmp(prexfix1,cond.dataname.b)
        cond.testname.a = 'Cond1'; cond.testname.b = 'Cond2'; 
    else
        cond.testname.a = cond.dataname.a; cond.testname.b ...
            = cond.dataname.b; 
    end
end
if ~exist(op,'dir'); mkdir(op);end
matlabbatch{1}.spm.stats.factorial_design.dir = {op};
n = 0;
for i = vector
    n = n+1;
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(n).scans(1,1) = ...
        {spm_select('ExtFPList',cond.path.a,...
        ['.*',cond.dataname.a,num2str(i,'%03.0f'),'*\.img$'])};
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(n).scans(2,1) = ...
        {spm_select('ExtFPList',cond.path.b,...
        ['.*',cond.dataname.b,num2str(i,'%03.0f'),'*\.img$'])};
end
%%
matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct...
    ('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
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
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = ...
    'Factorial design specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct...
    ('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct...
    ('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct...
    ('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct....
    ('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = ...
    [cond.testname.a ' - ' cond.testname.b];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [zeros(1,n) 1 -1];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1 zeros(1,n)]; %%%spm12
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ...
    [cond.testname.b ' - ' cond.testname.a];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [zeros(1,n) -1 1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1 zeros(1,n)]; %%%spm12
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
save(fullfile(op,'matlabbatch'),'matlabbatch')
%%
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%