function px_spm8_contrast_flexible(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Usage This function is used to set the contrast.

%  FORMAT px_spm8_contrast(fdp,para)
%   fdp.SPM
%   para.op
%   para.on   - optional <default, 'matlabbatch_contrast.mat'>
%   para.modes - {'flexible','merge'};
%   % flexible
%   para.fon  - output name of the flexible contrast;
%   para.fcn  - contrast name;
%   para.fcc  - contrast coefficient;
%   % merge
%   para.mon
%   para.mcn
%
%
%
%  path = '/data/px/...'; % The path of SPM.mat file, which was estimated.
%  para.foption.fname{1}  =  {'a1','b1','c1'} ;
%  para.foption.cname{1}  =  {'first'} ;
%  para.foption.handel{1} = {-1 -1 -1};
%  para.foption.fname{2}  =  {'a2','b2','c2'} ;
%  para.foption.cname{2}  =  {'second'} ;
%  para.foption.handel{2} = {1 1 1};
%  bname - output batch name, .mat file
%
%  Pengfei Xu, 10/04/2012,@BNU
%  Mail to author: pengfeixu.px@gmail.com
%  Copyright 2012-2012 Pengfei Xu, Beijing Normal University
%  Revision: 0.0 Date: 10/04/2012
%==========================================================================
%% check input
if ~isfield(para,'op');para.op = fileparts(char(fdp.SPM));end
if ~isfield(para,'on');para.on = 'matlabbatch_contrast.mat';end
if ~exist(para.op,'dir');mkdir(para.op);end
%% load SPM.mat file
% matfile = cellstr(spm_select('FPList',path,'SPM.mat'));
matlabbatch{1}.spm.stats.con.spmmat = fdp.SPM;
S = load(char(fdp.SPM));
n = 1;
for m = 1: length(para.modes)
    flag = lower(para.modes{m});
    switch flag
        case 'flexible' %% flexible contrast
            %  check input
            if numel(para.fon) ~= numel(para.fcc)
                error ('numbers of para.fon ~= para.foption.fcc');
            end
            for i = 1: numel(para.fon)
                if size(para.fon{i}) ~= size(para.fcc{i})
                    error (['numbers of para.fon ~= para.fcc in column ' num2str(i)]);
                end
            end
            ncon = length(S.SPM.xX.iC);
            for f = 1: numel(para.foption.fname)
                %         fvector = zeros(1,numel(para.foption.fname{f}));
                fvector = zeros(1,ncon);
                for c = 1: numel(para.foption.fname{f})
                    i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.foption.fname{f}{c})) == 1);
                    if isempty(i);error(['please check the name for paired t,e.g.' para.foption.fname{f}{c}]);end
                    fvector(i) = para.foption.handel{f}{c}; %% There should be no overlap among the vectors of para.foption.names
                end
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = para.foption.cname{f};
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = fvector;
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
                n = n+1;
            end
        case 'merge' %% merge contrast
            for nm = 1: numel(para.mon)
                mvector = zeros(1,ncon);
                i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.mon{nm})) == 1);
                if isempty(i);
                    error(['please check the name for merged t,e.g.' para.mon{nm}]);
                end
                mvector(1,i) = 1;%% There should be no overlap among the vectors of para.foption.names
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.name    = para.mcn{nm};
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec  = mvector;
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
                n = n+1;
            end
    end
end
%% %Ending contrast, save & clear SPM.mat
matlabbatch{1}.spm.stats.con.delete = 0;
save (fullfile(para.op,para.on), 'matlabbatch')
clear S;
%% %run spm-------------------------------------------------------
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%