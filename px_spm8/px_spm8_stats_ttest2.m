function px_spm8_stats_ttest2 (op,x,y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage Perform two sample t-test based on spm8.
%  FORMAT px_spm8_stats_ttest2 (op,x,y)
%    op - output path, string, e.g. '/data/results'
%    x.plist - path list of contrast img data in group 1,cell format.
%    y.plist - path list of contrast img data in group 2,cell format.
%    x.tn test name of group a, string, e.g. string, 'NC'
%    y.tn test name of group2, string, e.g. 'PT'
% 
%  FORMAT px_spm8_stats_ttest2 (op,x,y)
%    op output path, string, e.g. '/data/results'
%
%    x.path  image data path of group a, string, e.g. '/data/Control'
%    y.path  image data path of group b, string, e.g. '/data/Patient
%
%    x.ss sequence of subject in group a, e.g. [1 3:5 7:10]
%    y.ss sequence of subject in group b, e.g. [1 3:5 7:10]
%
%    x.dn prefix name of data a, string, e.g. '1'
%    y.dn prefix name of data b, string, e.g. '2'
%
%    x.tn test name of group a, string, e.g. string, 'NC'
%    y.tn test name of group2, string, e.g. 'PT'
%
%  Pengfei Xu, QCCUNY, 1/23/2012
%  Revised by PX, 05/16/2013, BNU, add input path list of img data directly.
%==========================================================================
%% check input
xfn = fieldnames(x);
yfn = fieldnames(y);
if numel(xfn)~= numel(yfn); 
    error(['Check fieldnames of ''x'' and ''y'', they are not equal(x = %d, y = %d)', numel(xfn),numel(yfn)]);
end
if find(strcmp(xfn,yfn) == 0)
    error('Check fieldnames of ''x'' and ''y'', they are not same(x = %s, y = %s)',xfn,yfn);
end
%
if ~isfield(x,'tn')
    x.tn = 'GA';
    y.tn = 'GB';
end
if  ~isfield(x,'dn')
    x.dn = []; 
    y.dn = [];
end
%
if ~exist(op,'dir'); mkdir(op);end
%%
if ~isfield(x,'ss')
    imagedata1 = textread(x.plist,'%s');
    imagedata2 = textread(y.plist,'%s');
else
    imagedata1 = cell(0,1); 
    imagedata2 = cell(0,1);
    n = 0;
    for i = x.ss
        n = n+1;
        imagedata1{n,1} = spm_select('ExtFPList',x.path,...
            ['^',x.dn,num2str(i,'%03.0f'),'.*\.img$']);
        if isempty(imagedata1{n,1});
            error(['There is no ', ['^',x.dn,num2str(i,'%03.0f'),'.*.img$'],' under %s'],x.path);
        end
    end
    n = 0;
    for i = y.ss
        n = n+1;
        imagedata2{n,1} = spm_select('ExtFPList',y.path,...
            ['^',y.dn,num2str(i,'%03.0f'),'.*\.img$']);
        if isempty(imagedata2{n,1});
            error(['There is no ', ['^',x.dn,num2str(i,'%03.0f'),'.*.img$'],' under %s'],y.path);
        end
    end
end
%%
matlabbatch{1}.spm.stats.factorial_design.dir = {op};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = ...
    cellstr(imagedata1);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = ...
    cellstr(imagedata2);
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
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
matlabbatch{3}.spm.stats.con.spmmat(1).sname = ...
    'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct...
    ('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = [x.tn '-' y.tn];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = [y.tn '-' x.tn];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = 'ftest';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.convec = {[0.5 -0.5;-0.5 0.5]};
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
%%
save (fullfile(op,'matlabbatch_ttes2'), 'matlabbatch')
%%
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%