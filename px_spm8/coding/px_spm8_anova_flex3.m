function px_spm8_anova_flex3(para,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% FORMAT  px_spm8_anova_flex3(para,data)
% Usage
%     This function is used for mixed 2x2x2 anova with one between-group 
% and two within-group factor.
% para
% para.p 
%     output path of the 2nd level analysis.
% para.n
%     names of the two within-subject factors.
% data
%     input path of img file, which generated from the linear contrast in 
%     1st level.     
%     data{1} and data{2} corresponds to two groups, respectively. Both of
%     data{1} and data{2} cell format, nsub x 4 matrix,with one column is 
%     one level of the within subject factor, one row is one subject
%     (including 4 conditions);
%     The first two column is the two level of the first factor.
%     
% 
% Pengfei Xu, Jan/02/2013, @BNU
%==========================================================================
%% check data
if ~exist(para.p,'dir'); mkdir(parap.p);end
ng = length(data);
if size(data{1},2) ~= size(data{2},2); % num od condition
    error(['The conditions in group is ' num2str(size(data{1},2))...
        'but in group two is ' num2str(size(data{2},2))...
        ', check your input data please!']);
end
% %------------------------------ load data -------------------------------
% %---------------------------- factor matrix -----------------------------
% % mat = [];
% % for i = 1:2
% %     for j = 1:2
% %         for k = 1:2
% %             mat = [mat;i j k];
% %         end
% %     end
% % end
% %------------------------------------------------------------------------
nsub = 0;
for g = 1: size(data,1) %% group
    for sub = 1:length(data{g})% size(data{g},1)
        nsub = nsub + 1;
        ncons = 0; %% within-subject condition
        scan = {};%% cell format
        mat = [];%% charactor
        for c1 = 1: 2 % condition1
            for c2 = 1:2 %condition2
                ncons = ncons + 1;
                scan = [scan;data{g}{sub,ncons}];
                mat = [mat; g c1 c2];
            end
        end
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(nsub).scans = scan;
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(nsub).conds = mat;
    end
end
n1 = length(data{1});
n2 = length(data{2});
% %---------------------------- design matrix -----------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {para.p};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = para.n{1};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 0;%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).name = para.n{2};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).variance = 0;%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(4).ancova = 0;

matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.inter.fnums = [2;3];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [2;4];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{4}.inter.fnums = [3;4];
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
%----------------------------- contrst ------------------------------------
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
%% Main effect
MEc = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'group';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec = ...
    {[ones(1,c1)/c1 -ones(1,c1)/c1 ...
    ones(1,c2)/c2 -ones(1,c2)/c2 ...
    zeros(1,c1*c2) ones(1,n1)/n1 -ones(1,n2)/n2]};
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = para.n{1};
matlabbatch{3}.spm.stats.con.consess{2}.fcon.convec = ...
{[MEc*(n1/(n1+n2)) MEc*(n2/(n1+n2)) zeros(1,ng*c2) ...
ones(1,c2)*(n1/(n1+n2)) -ones(1,c2)*(n1/(n1+n2)) zeros(1,n1+n2)]};%%% subject number weighted;
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = para.n{2};
matlabbatch{3}.spm.stats.con.consess{3}.fcon.convec = ...
    {[zeros(1,ng*c1) MEc*(n1/(n1+n2)) MEc*(n2/(n1+n2)) ...
    MEc*(n1/(n1+n2)) MEc*(n2/(n1+n2)) zeros(1,n1+n2)]};
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
%% Interaction
matlabbatch{3}.spm.stats.con.consess{4}.fcon.name = ['group*' para.n{1}];
matlabbatch{3}.spm.stats.con.consess{4}.fcon.convec =...
    {[MEc -MEc zeros(1,ng*c2) zeros(1,c1*c2) zeros(1,n1+n2)]};
matlabbatch{3}.spm.stats.con.consess{4}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.fcon.name = ['group*' para.n{2}];
matlabbatch{3}.spm.stats.con.consess{5}.fcon.convec = ...
    {[zeros(1,ng*c1) MEc -MEc zeros(1,c1*c2) zeros(1,n1+n2)]};
matlabbatch{3}.spm.stats.con.consess{5}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.fcon.name = [para.n{1} '*' para.n{1}];
matlabbatch{3}.spm.stats.con.consess{6}.fcon.convec = ...
    {[zeros(1,ng*c1) zeros(1,ng*c2) MEc -MEc zeros(1,n1+n2)]};
matlabbatch{3}.spm.stats.con.consess{6}.fcon.sessrep = 'none';

% matlabbatch{3}.spm.stats.con.consess{7}.fcon.name = ['group*' para.n{1} '*' para.n{1}];
% matlabbatch{3}.spm.stats.con.consess{7}.fcon.convec = ...
%     {[zeros(1,ng*c1) zeros(1,ng*c2) MEc -MEc zeros(1,n1+n2)]};
% matlabbatch{3}.spm.stats.con.consess{7}.fcon.sessrep = 'none';

% % matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Pos_Group*Seq';
% % matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec =...
% %     [MEc -MEc zeros(1,ng*c2) zeros(1,c1*c2) zeros(1,n1+n2)];
% % matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
% % matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Neg_Group*Seq';
% % matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = ...
% %     -[MEc -MEc zeros(1,ng*c2) zeros(1,c1*c2) zeros(1,n1+n2)];
% % matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
save(fullfile(para.p,'flexible_anova_matlabbatch'));
%%%------------------------- run batch ------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);