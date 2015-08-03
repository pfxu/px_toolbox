function px_SPM5_FlexANOVA (Output,Group1,Group2,Flag,Cov)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        px_SPM5_FlexANOVA (Output,Input)
%
%        Output Output datapath, string
%
%        Group1 Input datapath of Group1,cell, n by 2 matrix with rows
%               corresponding to obervations and columns to 2 factorial
%               levels:{Group1Condition1,Group1Condition2}
%        Flag   'g' main effect of group
%               'c' main effect of condition and interaction between group
%               and condition
%        Cov    Covariates, n by m matrix with rows corresponding to
%               obervations and columns to Covariables
%
%        Pengfei Xu, 2012/06/05, @BNU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -jobs 
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
%--------------------------------------------------------------
% jobs{1}.stats{1}.factorial_design.des.fblock.fac(1)
%--------------------------------------------------------------
if nargin == 4
    Cov = [];
jobs{1}.stats{1}.factorial_design.cov = struct(Cov);
else
    CovCorr = zeros(2*size(Cov ,1),size(Cov ,2));
    n = 0;
    for k = 1: size(Cov ,1)
        CovCorr(k+n,:) = Cov(k,:);
        CovCorr(k+n+1,:) = Cov(k,:);
        n = n+1;
    end
    for k = 1: size (Cov,2)
        jobs{1}.stats{1}.factorial_design.cov(k).c = CovCorr(:,k); %%CovCorr
        jobs{1}.stats{1}.factorial_design.cov(k).cname = ['Cov',...
            num2str(k,'%03.0f')];
        jobs{1}.stats{1}.factorial_design.cov(k).iCFI = 1;
        jobs{1}.stats{1}.factorial_design.cov(k).iCC = 1; %%% only
        %%%for BFC
    end
end
    if ~exist(Output,'dir'); mkdir(Output);end
num1 = size(Group1,1);num2 = size(Group2,1);
% jobs{1}.stats{1}.factorial_design.dir{1} = {Output};
jobs{1}.stats{1}.factorial_design.dir{1} = char(Output);
m = 0;
for i = 1: num1
    m = m+1;
%     jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(m).scans = ...
%         {Group1{i,1};Group1{i,2}};
    jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(m).scans = ...
        char([Group1{i,1};Group1{i,2}]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(m).conds = [1 1;1 2];
end
n = m;
for j = 1: num2
    n = n+1;
%     jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(n).scans = ...
%         {Group2{j,1};Group2{j,2}};
    jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(n).scans = ...
        char([Group2{j,1};Group2{j,2}]);
    jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(n).conds = [2 1;2 2];
end
n1 = m;n2 = n-m;nc = 2;ng = 2;MEc = [1:nc]-mean(1:nc);MEg = [1 -1];
% jobs{1}.stats{1}.factorial_design.cov.c = char([
%                                                  '<UNDEFINED>'
%                                                  ]);
% jobs{1}.stats{1}.factorial_design.cov.cname = char([
%                                                      '<UNDEFINED>'
%                                                      ]);
% jobs{1}.stats{1}.factorial_design.cov.iCFI = reshape(double([
%                                                               1
%                                                               ]),[1,1]);
% jobs{1}.stats{1}.factorial_design.cov.iCC = reshape(double([
%                                                              1
%                                                              ]),[1,1]);                                                      
                                                         
jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).name = char([
                                                                  'subject'
                                                                  ]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).dept = reshape(double([
                                                                            0
                                                                            ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).variance = reshape(double([
                                                                                1
                                                                                ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).gmsca = reshape(double([
                                                                             0
                                                                             ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(1).ancova = reshape(double([
                                                                              0
                                                                              ]),[1,1]);
%--------------------------------------------------------------
% jobs{1}.stats{1}.factorial_design.des.fblock.fac(2)
%--------------------------------------------------------------
jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).name = char([
                                                                  'group'
                                                                  ]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).dept = reshape(double([
                                                                            0
                                                                            ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).variance = reshape(double([
                                                                                1
                                                                                ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).gmsca = reshape(double([
                                                                             0
                                                                             ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(2).ancova = reshape(double([
                                                                              0
                                                                              ]),[1,1]);
%--------------------------------------------------------------
% jobs{1}.stats{1}.factorial_design.des.fblock.fac(3)
%--------------------------------------------------------------
jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).name = char([
                                                                  'condition'
                                                                  ]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).dept = reshape(double([
                                                                            1
                                                                            ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).variance = reshape(double([
                                                                                1
                                                                                ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).gmsca = reshape(double([
                                                                             0
                                                                             ]),[1,1]);
jobs{1}.stats{1}.factorial_design.des.fblock.fac(3).ancova = reshape(double([
                                                                              0
                                                                              ]),[1,1]);
% %      |   |   | \-fsubject 
% %==============================================================
% % jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject
% %==============================================================
% %--------------------------------------------------------------
% % jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(1)
% %--------------------------------------------------------------
% jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(1).scans = char([
%                                                                                 '<UNDEFINED>'
%                                                                                 ]);
% jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(1).conds = reshape(double([
%                                                                                           1
%                                                                                           1
%                                                                                           1
%                                                                                           2
%                                                                                           ]),[2,2]);
% %--------------------------------------------------------------
% % jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(2)
% %--------------------------------------------------------------
% jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(2).scans = char([
%                                                                                 '<UNDEFINED>'
%                                                                                 ]);
% jobs{1}.stats{1}.factorial_design.des.fblock.fsuball.fsubject(2).conds = reshape(double([
%                                                                                           2
%                                                                                           2
%                                                                                           1
%                                                                                           2
%                                                                                           ]),[2,2]);

if strcmp(Flag,'g')
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
    jobs{1}.stats{3}.con.consess{1}.tcon.name = 'Main Effect of Group';
    jobs{1}.stats{3}.con.consess{1}.tcon.convec = [MEg zeros(1,size(Cov,2))];
    jobs{1}.stats{3}.con.consess{1}.tcon.sessrep = 'none';
elseif strcmp(Flag,'c')
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
    jobs{1}.stats{1}.factorial_design.des.fblock.maininters{2}.inter.fnums = [2;3];
    jobs{1}.stats{3}.con.consess{1}.tcon.name = 'Main Effect of condition';
    jobs{1}.stats{3}.con.consess{1}.tcon.convec = [zeros(1,n1+n2) MEc MEc];
    jobs{1}.stats{3}.con.consess{1}.tcon.sessrep = 'none';
    jobs{1}.stats{3}.con.consess{2}.tcon.name = 'Interaction group x condition';
    jobs{1}.stats{3}.con.consess{2}.tcon.convec = [zeros(1,n1+n2) MEc -MEc];
    jobs{1}.stats{3}.con.consess{2}.tcon.sessrep = 'none';
    jobs{1}.stats{3}.con.consess{3}.tcon.name = 'flip Interaction group x condition';
    jobs{1}.stats{3}.con.consess{3}.tcon.convec = [zeros(1,n1+n2) -MEc MEc];
    jobs{1}.stats{3}.con.consess{3}.tcon.sessrep = 'none';
end

jobs{1}.stats{1}.factorial_design.masking.tm.tm_none = 1;
jobs{1}.stats{1}.factorial_design.masking.im = 1;
% jobs{1}.stats{1}.factorial_design.masking.em = {''};
jobs{1}.stats{1}.factorial_design.masking.em = char(['']);
jobs{1}.stats{1}.factorial_design.globalc.g_omit = 1;
jobs{1}.stats{1}.factorial_design.globalm.gmsca.gmsca_no = 1;
jobs{1}.stats{1}.factorial_design.globalm.glonorm = 1;
% jobs{1}.stats{2}.fmri_estmat = {fullfile(Output,'SPM.mat')};
jobs{1}.stats{2}.fmri_estmat = char([fullfile(Output,'SPM.mat')]);
jobs{1}.stats{2}.fmri_est.method.Classical = 1;
% jobs{1}.stats{3}.conmat = {fullfile(Output,'SPM.mat')};
jobs{1}.stats{3}.conmat = char([fullfile(Output,'SPM.mat')]);
jobs{1}.stats{3}.con.delete = 0;
save jobs jobs
% %      |   |   \-maininters 
% jobs{1}.stats{1}.factorial_design.des.fblock.maininters{1}.fmain.fnum = reshape(double([
%                                                                                          1
%                                                                                          ]),[1,1]);
% jobs{1}.stats{1}.factorial_design.des.fblock.maininters{2}.fmain.fnum = reshape(double([
%                                                                                          2
%                                                                                          ]),[1,1]);
% jobs{1}.stats{1}.factorial_design.des.fblock.maininters{3}.fmain.fnum = reshape(double([
%                                                                                          2
%                                                                                          3
%                                                                                          ]),[2,1]);
% jobs{1}.stats{1}.factorial_design.masking.tm.tm_none = reshape(double([
%                                                                         
%                                                                         ]),[0,0]);
% jobs{1}.stats{1}.factorial_design.masking.im = reshape(double([
%                                                                 1
%                                                                 ]),[1,1]);
% %      |   | \-em 
% jobs{1}.stats{1}.factorial_design.masking.em{1} = char([
%                                                          ''
%                                                          ]);
% jobs{1}.stats{1}.factorial_design.globalc.g_omit = reshape(double([
%                                                                     
%                                                                     ]),[0,0]);
% jobs{1}.stats{1}.factorial_design.globalm.gmsca.gmsca_no = reshape(double([
%                                                                             
%                                                                             ]),[0,0]);
% jobs{1}.stats{1}.factorial_design.globalm.glonorm = reshape(double([
%                                                                      1
%                                                                      ]),[1,1]);
%                                                                  
%                                                                  
% % %      |   \-dir 
% % jobs{1}.stats{1}.factorial_design.dir{1} = char([
% %                                                   'D:\'
% %                                                   ]);
% jobs{1}.stats{2}.fmri_est.spmmat = char([
%                                           '<UNDEFINED>'
%                                           ]);
% jobs{1}.stats{2}.fmri_est.method.Classical = reshape(double([
%                                                               1
%                                                               ]),[1,1]);
% jobs{1}.stats{3}.con.spmmat = char([
%                                      '<UNDEFINED>'
%                                      ]);
% %          |-consess 
% jobs{1}.stats{3}.con.consess{1}.tcon.name = char([
%                                                    '<UNDEFINED>'
%                                                    ]);
% jobs{1}.stats{3}.con.consess{1}.tcon.convec = char([
%                                                      '<UNDEFINED>'
%                                                      ]);
% jobs{1}.stats{3}.con.consess{1}.tcon.sessrep = char([
%                                                       'none'
%                                                       ]);
% jobs{1}.stats{3}.con.consess{2}.tcon.name = char([
%                                                    '<UNDEFINED>'
%                                                    ]);
% jobs{1}.stats{3}.con.consess{2}.tcon.convec = char([
%                                                      '<UNDEFINED>'
%                                                      ]);
% jobs{1}.stats{3}.con.consess{2}.tcon.sessrep = char([
%                                                       'none'
%                                                       ]);
% jobs{1}.stats{3}.con.consess{3}.tcon.name = char([
%                                                    '<UNDEFINED>'
%                                                    ]);
% jobs{1}.stats{3}.con.consess{3}.tcon.convec = char([
%                                                      '<UNDEFINED>'
%                                                      ]);
% jobs{1}.stats{3}.con.consess{3}.tcon.sessrep = char([
%                                                       'none'
%                                                       ]);
% jobs{1}.stats{3}.con.delete = reshape(double([
%                                                0
%                                                ]),[1,1]);
%%%------------------------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', jobs);