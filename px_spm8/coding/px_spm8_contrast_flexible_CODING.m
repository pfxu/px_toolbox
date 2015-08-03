function px_spm8_contrast_flexible(path,foption,bname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Usage This function is used to set the contrast.

%  FORMAT px_spm8_contrast(path,foption) 
%  path = '/data/px/...'; % The path of SPM.mat file, which was estimated.
%  foption.fname{1}  =  {'a1','b1','c1'} ; 
%  foption.cname{1}  =  {'first'} ; 
%  foption.handel{1} = {-1 -1 -1};
%  foption.fname{2}  =  {'a2','b2','c2'} ;
%  foption.cname{2}  =  {'second'} ; 
%  foption.handel{2} = {1 1 1};
%  bname - output batch name, .mat file
%
%  Pengfei Xu, 10/04/2012,@BNU
%  Mail to author: pennfeixu@gmail.com
%  Copyright 2012-2012 Pengfei Xu, Beijing Normal University
%  Revision: 0.0 Date: 10/04/2012
%==========================================================================
%% check input
if ~exist(op,'dir');mkdir(op);end
cwd = pwd;
cd(cp);
copyfile(fullfile(path,'SPM.mat'),op);
SPMMATpath = 
    if numel(foption.fname) ~= numel(foption.handel)
        error ('numbers of foption.name ~= foption.order or foption.handel');
    end
    for i = 1: numel(foption.fname)
        if size(foption.fname{i}) ~= size(foption.handel{i})
            error (['numbers of foption.name ~= foption.order or foption.handel in column ' num2str(i)]);
        end
    end
%% load SPM.mat file
matfile = cellstr(spm_select('FPList',path,'SPM.mat'));
matlabbatch{1}.spm.stats.con.spmmat = matfile;
S = load(cell2mat(matfile));
%% %contrast------------------------------------------------------
ncon = length(S.SPM.xX.iC);
n = 1;
%% %flexible paired option
% if nargin == 4,
%     for f = 1: size(foption.name,1)
%         i = foption.order{f}(1);
%         j = foption.order{f}(2);
%         fivector = ivector(i,:);
%         fjvector = ivector(j,:);
%         if foption.handel{f} == 1; fvector = fivector + fjvector;end
%         if foption.handel{f} == 2; fvector = fivector - fjvector;end
%         matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = [foption.name{f} ': ' namepair.p{i} '-' namepair.p{j}];
%         matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = fvector;
%         matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
%         n = n+1;
%     end
% end
    for f = 1: numel(foption.fname)
        %         fvector = zeros(1,numel(foption.fname{f}));
        fvector = zeros(1,ncon);
        for c = 1: numel(foption.fname{f})
            i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,foption.fname{f}{c})) == 1);
            if isempty(i);error(['please check the name for paired t,e.g.' foption.fname{f}{c}]);end
            fvector(i) = foption.handel{f}{c}; %% There should be no overlap among the vectors of foption.names
        end
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = foption.cname{f};
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = fvector;
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
        n = n+1;
    end
    %% merge contrast
if nargin == 5,
    for f = 1: numel(moption.mname)
        i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,moption.mname{m})) == 1);
        if isempty(i);
            error(['please check the name for paired t,e.g.' moption.mname{m}]);
        end
        mvector = ones(1,length(i)); %% There should be no overlap among the vectors of foption.names
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = moption.cname{m};
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = mvector;
        matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
        n = n+1;
    end
end
%% %Ending contrast, save & clear SPM.mat
matlabbatch{1}.spm.stats.con.delete = 0;
save (fullfile(path,bname), 'matlabbatch')
clear S;
%% %run spm-------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%