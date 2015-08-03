function px_spm8_stats_ttest(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Perform one sample t-test based on spm8.
%  FORMAT: px_spm8_ttest(op,x)
%    x - path list of the input contrast img data.
% 
%  FORMAT: px_spm8_stats_ttest (op,ip,prefix,vector)
%      op     - ouput path, string, e.g. '/data/results'
%      ip     - input image data, string, e.g. '/data/NormalControl'
%      prefix - prefix name of image data, string, e.g. 'sub_' 
%      vector - number of subject, e.g. [1 3:5 7:10]
% 
%  Pengfei Xu, QCCUNY, Nov 23rd, 2011
%  Revised by PX, 05/16/2013, BNU, add input of imgdata directly.
%==========================================================================
if ~exist(varargin{1},'dir'); mkdir(varargin{1});end
if nargin == 2
    imagedata = textread(varargin{2},'%s'); %  Revised by PX, 05/16/2013, BNU, add input of imgdata directly.
elseif nargin == 4
    imagedata = cell(0,1);
    n = 0;
    for i = varargin{4}
        n = n+1;
        imagedata{n,1} = spm_select('ExtFPList',varargin{2},...
            ['.*',varargin{3},num2str(i,'%03.0f'),'.*\.img$']);
    end
end
%%
matlabbatch{1}.spm.stats.factorial_design.dir = varargin(1);%{varargin{1}}
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(imagedata);
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'ttest_pos';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'ttest_neg';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = 'ftest';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.convec = {1};
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
save (fullfile(varargin{1},'matlabbatch_ttest'), 'matlabbatch')
fprintf(' Save batch to %s',varargin{1});
%%
spm_jobman('initcfg'); 
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);