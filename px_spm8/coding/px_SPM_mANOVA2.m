function px_SPM_mANOVA2(output,name,path,prefix,vector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%px_SPM_mANOVA2(output,name,path,prefix,vector)

% path  g1c1; g1c2;g2c1; g2c2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(path,1) ~= 4 || size(prefix,1) ~= 4 || size(vector,1) ~= 2
    error('Please check your input path or prefix or vector');
end
if ~exist(output,'dir'); mkdir(output);end
imagedata1 = cell(0,1); imagedata2 = cell(0,1);
m = 0;
for i = vector{1}
    m = m+1;
    imagedata1(m,1) = cellstr(spm_select('ExtFPList',path{1},['.*',prefix{1},num2str(i,'%03.0f'),'*\.img$']));
    imagedata2(m,1) = cellstr(spm_select('ExtFPList',path{2},['.*',prefix{2},num2str(i,'%03.0f'),'*\.img$']));
end
n = 0;
for j = vector{2}
    n = n+1;
    imagedata3(n,1) = cellstr(spm_select('ExtFPList',path{3},['.*',prefix{3},num2str(j,'%03.0f'),'*\.img$']));
    imagedata4(n,1) = cellstr(spm_select('ExtFPList',path{4},['.*',prefix{4},num2str(j,'%03.0f'),'*\.img$']));
end
%%
matlabbatch{1}.spm.stats.factorial_design.dir = {output};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = name{1};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = name{2};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1;1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans = imagedata1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [1;2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans = imagedata2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [2;1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).scans = imagedata3;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2;2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).scans = imagedata4;
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
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = [name{1} 'VS' name{2}];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec = {[1 0 -1 0; 0 1 0 -1]};%;-1 0 1 0;0 -1 0 1]}';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
%%
inputs = cell(0, 1);
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch, '', inputs{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%