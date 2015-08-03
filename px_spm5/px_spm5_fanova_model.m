function px_spm5_fanova_model(pathout,data,flag,cov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        FROMAT px_spm5_fanova_model(pathout,group,flag,cov)
%        This function is used for 2(between-subject)x2(within-subject) or 
%        3(between-subject)x2(with-subject) anova in 2nd-level analysis.
%        pathout output path of data, string
%
%        data   Input datapath of Group1,cell, n by 2 matrix with rows
%               corresponding to obervations and columns to 2 factorial
%               levels:{Group1Condition1,Group1Condition2}
%        flag   'g' main effect of group
%               'c' main effect of condition and interaction between group
%               and condition
%        cov    Covariates, n by m matrix with rows corresponding to
%               obervations and columns to Covariables
%
%        Pengfei Xu, 2012/06/05, @BNU
%        Revised by PX 2013/0429 for the problem of covariates number,@BNU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% job %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  \-jobs{1}
%    \-stats
%      |-stats{1}
%      | \-factorial_design
%      |   |-des
%      |   | \-fblock
%      |   |   |-fac
%      |   |   | |-fac(1)
%      |   |   | | |-name .............. subject
%      |   |   | | |-dept .............. 1-x-1 double
%      |   |   | | |-variance .......... 1-x-1 double
%      |   |   | | |-gmsca ............. 1-x-1 double
%      |   |   | | \-ancova ............ 1-x-1 double
%      |   |   | |-fac(2)
%      |   |   | | |-name .............. group
%      |   |   | | |-dept .............. 1-x-1 double
%      |   |   | | |-variance .......... 1-x-1 double
%      |   |   | | |-gmsca ............. 1-x-1 double
%      |   |   | | \-ancova ............ 1-x-1 double
%      |   |   | \-fac(3)
%      |   |   |   |-name .............. condition
%      |   |   |   |-dept .............. 1-x-1 double
%      |   |   |   |-variance .......... 1-x-1 double
%      |   |   |   |-gmsca ............. 1-x-1 double
%      |   |   |   \-ancova ............ 1-x-1 double
%      |   |   |-fsuball
%      |   |   | \-fsubject
%      |   |   |   |-fsubject(1)
%      |   |   |   | |-scans ............. <UNDEFINED>
%      |   |   |   | \-conds ............. 2-x-2 double
%      |   |   |   \-fsubject(2)
%      |   |   |     |-scans ............. <UNDEFINED>
%      |   |   |     \-conds ............. 2-x-2 double
%      |   |   \-maininters
%      |   |     |-maininters{1}
%      |   |     | \-fmain
%      |   |     |   \-fnum .............. 1-x-1 double
%      |   |     |-maininters{2}
%      |   |     | \-fmain
%      |   |     |   \-fnum .............. 1-x-1 double
%      |   |     \-maininters{3}
%      |   |       \-fmain
%      |   |         \-fnum .............. 2-x-1 double
%      |   |-cov
%      |   | |-c ................. <UNDEFINED>
%      |   | |-cname ............. <UNDEFINED>
%      |   | |-iCFI .............. 1-x-1 double
%      |   | \-iCC ............... 1-x-1 double
%      |   |-masking
%      |   | |-tm
%      |   | | \-tm_none ........... []
%      |   | |-im ................ 1-x-1 double
%      |   | \-em
%      |   |   \-em{1} ............. []
%      |   |-globalc
%      |   | \-g_omit ............ []
%      |   |-globalm
%      |   | |-gmsca
%      |   | | \-gmsca_no .......... []
%      |   | \-glonorm ........... 1-x-1 double
%      |   \-dir
%      |     \-dir{1} ............ D:\
%      |-stats{2}
%      | \-fmri_est
%      |   |-spmmat ............ <UNDEFINED>
%      |   \-method
%      |     \-Classical ......... 1-x-1 double
%      \-stats{3}
%        \-con
%          |-spmmat ............ <UNDEFINED>
%          |-consess
%          | |-consess{1}
%          | | \-tcon
%          | |   |-name .............. <UNDEFINED>
%          | |   |-convec ............ <UNDEFINED>
%          | |   \-sessrep ........... none
%          | |-consess{2}
%          | | \-tcon
%          | |   |-name .............. <UNDEFINED>
%          | |   |-convec ............ <UNDEFINED>
%          | |   \-sessrep ........... none
%          | \-consess{3}
%          |   \-tcon
%          |     |-name .............. <UNDEFINED>
%          |     |-convec ............ <UNDEFINED>
%          |     \-sessrep ........... none
%          \-delete ............ 1-x-1 double
% -jobs
%    \-stats
%      |   |   |-fac
%==============================================================
% jobs{1}.stats{1}.factorial_design.des.fblock.fac
%==============================================================
ngroup = size(data,1);
ncon = size(data,2);
if nargin == 3
    cov = [];
    jobs{1}.stats{1}.factorial_design.cov = struct(cov);
else
%   Copy the covariates cross the conditions to make sure the  dimension 
%   is consistent with the image files.
%   The structure should be as following: 
%   -subject001 cov001
%   -subject001 cov002
%                    .
%                    .
%                    .
%   -subject001 covNcon
%   -subject002 cov001
%   -subject002 cov002
%                    .
%                    .
%                    .
%   -subject002 covNcon
    covcorr = zeros(2*size(cov,1),size(cov,2));
    for k = 1: size(cov ,1)
        for c = 1:ncon
            nimage = k*2+c-2;% each subject has n conditions, therefore the cov should have the same copies.
            covcorr(nimage,:) = cov(k,:);
        end
    end
    for k = 1: size (cov,2)
        jobs{1}.stats{1}.factorial_design.cov(k).c = covcorr(:,k); %%covcorr
        jobs{1}.stats{1}.factorial_design.cov(k).cname = ['cov',...
            num2str(k,'%03.0f')];
        jobs{1}.stats{1}.factorial_design.cov(k).iCFI = 1;% Interacton: none
        jobs{1}.stats{1}.factorial_design.cov(k).iCC = 1; % Center: over all mean mean
    end
end
if ~exist(pathout,'dir'); mkdir(pathout);end
jobs{1}.stats{1}.factorial_design.dir{1} = char(pathout);%{pathout};
subs = 0;
for g = 1: ngroup
    nsub = size(data{g,1},1);
    for s= 1:nsub
        subs = subs+1;
        cond = [];
        for c = 1: ncon
            jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(subs).scans{c,1} = char([data{g,c}{s}]);
            cond = [cond;g c];
        end
        jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(subs).conds = cond;
    end
end
if strcmp(flag,'g')
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).name = char('group');
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).dept = 0;
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).variance = 1;
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).gmsca = 0;
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).ancova = 0;
    
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
elseif strcmp(flag,'c')
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).name = char('subject');
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).dept = reshape(double(0),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).variance = reshape(double(1),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).gmsca = reshape(double(0),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).ancova = reshape(double(0),[1,1]);
    %--------------------------------------------------------------
    % jobs{1}.stats{1}.factorial_design.des.fblock.fac(2)
    %--------------------------------------------------------------
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).name = char('group');
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).dept = reshape(double(0),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).variance = reshape(double(1),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).gmsca = reshape(double(0),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).ancova = reshape(double(0),[1,1]);
    %--------------------------------------------------------------
    % jobs{1}.stats{1}.factorial_design.des.fblock.fac(3)
    %--------------------------------------------------------------
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).name = char('condition');
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).dept = reshape(double(1),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).variance = reshape(double(1),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).gmsca = reshape(double(0),[1,1]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).ancova = reshape(double(0),[1,1]);
    
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{2}.inter.fnums = [2;3];
end
jobs{1}.stats{1}.factorial_design.masking.tm.tm_none = 1;
jobs{1}.stats{1}.factorial_design.masking.im = 1;
% jobs{1}.stats{1}.factorial_design.masking.em = {''};
jobs{1}.stats{1}.factorial_design.masking.em{1} = char(['']);
jobs{1}.stats{1}.factorial_design.globalc.g_omit = 1;
jobs{1}.stats{1}.factorial_design.globalm.gmsca.gmsca_no = 1;
jobs{1}.stats{1}.factorial_design.globalm.glonorm = 1;
% jobs{1}.stats{2}.fmri_estmat = {fullfile(pathout,'SPM.mat')};
jobs{1}.stats{2}.fmri_est.spmmat{1} = char([fullfile(pathout,'SPM.mat')]);
jobs{1}.stats{2}.fmri_est.method.Classical = 1;
%%%------------------------ contrast -------------------------------------
% jobs{1}.stats{3}.conmat = {fullfile(pathout,'SPM.mat')};
jobs{1}.stats{3}.con.spmmat{1} = char(fullfile(pathout,'SPM.mat'));
if strcmp(flag,'g')
    if ngroup == 2
        cnames = {'Main effect of group'};
        MEg = [1 -1];
        cvecs = [MEg zeros(1,size(cov,2))];
    end
    if ngroup == 3
        cnames  = {'Group: 1-2';'Group: 1-3';'Group: 2-3'};
        cvecs = [[1 -1 0 zeros(1,size(cov,2))];...
            [1 0 -1 zeros(1,size(cov,2))];[0 1 -1 zeros(1,size(cov,2))]];
    end
elseif strcmp(flag,'c')
    if ncon == 2;
        MEc = [1 -1];%MEc = [1:ncon]-mean(1:ncon);
        if ngroup == 2
            cnames = {'Main effect of condition'; 'Interaction group x condition'};
            cvecs = [[zeros(1,subs) MEc MEc];[zeros(1,subs) MEc -MEc]];
        end
        if ngroup == 3;
            cnames = {'Main effect of condition';...
                'Interaction group(1,2) x condition';...
                'Interaction group(1,3) x condition';...
                'Interaction group(2,3) x condition'};
            cvecs =[[zeros(1,subs) repmat(MEc,1,ngroup)];...
                [zeros(1,subs) MEc -MEc zeros(1,ncon)];...
                [zeros(1,subs) MEc zeros(1,ncon) -MEc];...
                [zeros(1,subs) zeros(1,ncon) MEc -MEc]];
        end
    end
else error('Check the input of flag,please');
end
n = 0;
for c = 1:length(cnames)
    for f = 1:2 %flip
        cname = cnames{c};
        cvec = cvecs(c,:);
        if f == 2;cname = ['flip ' cnames{c}];cvec = -cvec;end
        n = n + 1;
        jobs{1}.stats{3}.con.consess{n}.tcon.name = cname;
        jobs{1}.stats{3}.con.consess{n}.tcon.convec = cvec;
        jobs{1}.stats{3}.con.consess{n}.tcon.sessrep = 'none';
    end
end
jobs{1}.stats{3}.con.delete = 0;
save(fullfile(pathout,'model_jobs'),'jobs');
%%%------------------------ run jobs  -------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', jobs);