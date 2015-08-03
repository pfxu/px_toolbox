function px_spm8_anova_flex(para,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   px_spm8_anova_flex(para,data)
% 
%   useage      This function is used for mixed 2x2 or 2x3 anova with 
%           one within-subject and one between-subject factor(2|3 levels).
% 
%   format      px_spm8_anova_flex(para,data)
% 
%   para.p      output datapath, string
%
%   para.f      'g' main effect of group
%               'c' main effect of condition and interaction between group
%               and condition
% 
%   data.img   Input path of imgfile,cellformat, n by m matrix with rows
%           corresponding to groups and columns to 2 factorial levels: e.g.
%           {Group1Condition1,Group1Condition2}. For the 
%           Group1Condition1,still cell format, with one columns of all
%           subjects, one row one subject.
% 
%   data.cov    Input path of covariates, n by m matrix with rows 
%           corresponding to obervations and columns to covariables.
%
%   Pengfei Xu, 2012/3/22, @BNU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist(para.p,'dir'); mkdir(para.p);end
ng = size(data.img,1);
nc = size(data.img,2);
%% check data
for g = 1 : ng
    if size(data.img{g,1},1) ~= size(data.img{g,2},1);
        error(['Subject number of group ' num2str(g) ...
            'in the 1st condition is ' num2str(size(data.img{g,1},1)) ...
            ', which is not equal to the number in the 2nd condition (' ...
            num2str(size(data.img{g,2},1)) ')']);
    end
end
%%-------------------------------------------------------------------------
if ~isfield(data,'cov')
    data.cov = [];
    matlabbatch{1}.spm.stats.factorial_design.cov = ...
        struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
else
    covcorr = zeros(2*size(data.cov,1),size(data.cov,2));
    n = 0;
    for k = 1: size(data.cov ,1)
        covcorr(k+n,:) = data.cov(k,:);
        covcorr(k+n+1,:) = data.cov(k,:);
        n = n+1;
    end
    for k = 1: size (data.cov,2)
        matlabbatch{1}.spm.stats.factorial_design.cov(k).c = covcorr(:,k); %%covcorr
        matlabbatch{1}.spm.stats.factorial_design.cov(k).cname = ['Cov',...
            num2str(k,'%03.0f')];
        matlabbatch{1}.spm.stats.factorial_design.cov(k).iCFI = 1;
        matlabbatch{1}.spm.stats.factorial_design.cov(k).iCC = 1; %%% only
        %%%for BFC
    end
end
matlabbatch{1}.spm.stats.factorial_design.dir = {para.p};

nsub = 0;
for g = 1: ng
    subs = size(data.img{g,1},1);
    subgroup(g) = size(data.img{g,1},1);
    for sub= 1:subs
        nsub = nsub+1;
        ncons = 0; %% number of within-subject condition
        scan = {};%% cell format
        cond = [];%% charactor
        for c = 1: nc
            ncons = ncons + 1;
            scan = [scan;data.img{g,c}{sub}];
            cond = [cond;g c];
        end
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(nsub).scans = scan;
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(nsub).conds = cond;
    end
end
save(fullfile(para.p,'subgroup'), 'subgroup');

%%----------------------------- contrast ----------------------------------
%MEc = [1:nc]-mean(1:nc);
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'condition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;

if strcmp(para.f,'g')
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
    if ng == 2
        cnames = {'Main effect of group'};
        MEg = [1 -1];
        cvecs = [MEg zeros(1,size(data.cov,2))];
    end
    if ng == 3
        cnames  = {'Group: 1-2';'Group: 1-3';'Group: 2-3'};
        cvecs = [[1 -1 0 zeros(1,size(data.cov,2))];...
            [1 0 -1 zeros(1,size(data.cov,2))];...
            [0 1 -1 zeros(1,size(data.cov,2))]];
    end
elseif strcmp(para.f,'c')
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.inter.fnums = [2;3];
    if nc == 2;
        MEc = [1 -1];%MEc = [1:ncon]-mean(1:ncon);
        if ng == 2
            cnames = {'Main effect of condition'; 'Interaction group x condition'};
            cvecs = [[zeros(1,nsub) MEc MEc];[zeros(1,nsub) MEc -MEc]];
        end
        if ng == 3;
            cnames = {'Main effect of condition';...
                'Interaction group(1,2) x condition';...
                'Interaction group(1,3) x condition';...
                'Interaction group(2,3) x condition'};
            cvecs =[[zeros(1,nsub) repmat(MEc,1,ng)];...
                [zeros(1,nsub) MEc -MEc zeros(1,nc)];...
                [zeros(1,nsub) MEc zeros(1,nc) -MEc];...
                [zeros(1,nsub) zeros(1,nc) MEc -MEc]];
        end
    end
else error('Check the input of flag,please');
end

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
n = 0;
for c = 1:length(cnames)
%     for f = 1:2 %flip t contrast
        cname = cnames{c};
        cvec = cvecs(c,:);
%         if f == 2;cname = ['flip ' cnames{c}];cvec = -cvec;end
        n = n + 1;
        matlabbatch{3}.spm.stats.con.consess{n}.fcon.name = cname;
        matlabbatch{3}.spm.stats.con.consess{n}.fcon.convec = {cvec};%%% cell format for f-contrast
        matlabbatch{3}.spm.stats.con.consess{n}.fcon.sessrep = 'none';
%     end
end
matlabbatch{3}.spm.stats.con.delete = 0;
save (fullfile(para.p,'flex_anova_matlabbatch'), 'matlabbatch');
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);