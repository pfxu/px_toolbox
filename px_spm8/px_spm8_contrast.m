function px_spm8_contrast(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage This function is used to set the contrast.
% FORMAT px_spm8_contrast(fdp,para)
%  Input
%   fdp.SPM    - fullpath of the input SPM.mat file for contrast.
%   para.op    - (optional), output directory for the matlabbatch file. <default, the directory of SPM.mat>
%   para.on    - (optional), output name for the matlabbatch file. <default, 'matlabbatch_contrast.mat'>
%   para.modes - {'ttest','ttestp','flexible'};
%   para.tcn   - contrast name for the one sample ttest, string;
%   para.pcn   - contrast name for the paired ttest;
%   para.pon   - output name of the paired tcontrast, string;
%   para.fcn   - contrast name for the flexible tcontrast; e.g., para.fcn{1} = {'a1','b1','c1'};
%   para.fon   - output name of the flexible tcontrast, string; e.g., para.fon{1} = {'abc1'};
%   para.fcc   - contrast coefficient each comapred constrast; e.g.,fcc{1} = {-1 -1 -1};
%  Output
%   '^con_'  image file
%   '.mat' matlabbatch file
%__________________________________________________________________________
%  Pengfei Xu, 10/04/2012,@BNU
%  Mail to author: pengfeixu.px@gmail.com
%  Copyright 2012-2012, Pengfei Xu, Beijing Normal University
%  Revision: 0.0 Date: 10/04/2012
%  Revised by Pengfei Xu, 10/01/2013
%  Revised by Pengfei Xu, 12/16/2014, replace REGEXP by STRFIND
%==========================================================================
%% check input
if ischar(fdp.SPM); fdp.SPM = cellstr(fdp.SPM);end
if ~isfield(para,'op');para.op = fileparts(char(fdp.SPM));end
if ~isfield(para,'on');para.on = 'set_contrast.mat';end
if ~exist(para.op,'dir');mkdir(para.op);end
%% load SPM.mat file
% matfile = cellstr(spm_select('FPList',path,'SPM.mat'));
matlabbatch{1}.spm.stats.con.spmmat = fdp.SPM;
S = load(char(fdp.SPM));
ncon = length(S.SPM.xX.iC);
n = 1;
for m = 1: length(para.modes)
    flag = lower(para.modes{m});
    switch flag
        case 'ttest'
            % one sample t test-----------------------------------------------
            nt = length(para.tcn);
            for o = 1: nt
                vector = zeros(1,ncon);
                % i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.tcn{o})) == 1); regexp does not work for parentheses and numberic strings, e.g.'(1)'
                i = find(cellfun('prodofsize',strfind(S.SPM.xX.name,para.tcn{o})) == 1);
                if isempty(i);
                    error(['please check the name for one sample t,e.g. %s.' para.tcn{o}]);
                end
                vector(1,i) = 1;
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = para.tcn{o};
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = vector(1,:);
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
                n = n+1;
            end
        case 'ttestp'
            %% %paired ttest
            if size(para.pcn,1) ~= size(para.pon,1)
                error ('numbers of para.pcn ~= para.pon');
            end
            np = size(para.pcn,1);
            ivector = zeros(np,ncon);
            jvector = zeros(np,ncon);
            for p = 1: np
                %i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.pcn{p,1})) == 1);
                i = find(cellfun('prodofsize',strfind(S.SPM.xX.name,para.pcn{p,1})) == 1);
                if isempty(i);
                    error(['please check the name for paired t,e.g. %s.' para.tcn{p,1}]);
                end
                ivector(p,i) = 1;
                %j = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.pcn{p,2})) == 1);
                j = find(cellfun('prodofsize',strfind(S.SPM.xX.name,para.pcn{p,2})) == 1);
                if isempty(j);
                    error(['please check the name for paired t,e.g. %s.' para.tcn{p,2}]);
                end
                jvector(p,j) = 1;
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = [para.pon{p} ': ' para.pcn{p,1} '-' para.pcn{p,2}];
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = ivector(p,:)-jvector(p,:);
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.sessrep = 'none';
                n = n+1;
            end
        case 'flexible' %% flexible contrast
            %  check input
            if numel(para.fon) ~= numel(para.fcn) ||numel(para.fcn) ~= numel(para.fcc)
                error ('numbers of para.fon) ~= numel(para.fcn) OR numbers of para.fcn ~= para.fcc');
            end
            for i = 1: numel(para.fcn)
                if size(para.fcn{i}) ~= size(para.fcc{i})
                    error (['numbers of para.fcn ~= para.fcc in column ' num2str(i)]);
                end
            end
            for f = 1: numel(para.fon)
                fvector = zeros(1,ncon);
                for c = 1: numel(para.fcn{f})
                    %i = find(cellfun('prodofsize',regexp(S.SPM.xX.name,para.fcn{f}{c})) == 1);
                    i = find(cellfun('prodofsize',strfind(S.SPM.xX.name,para.fcn{f}{c})) == 1);
                    if isempty(i);
                        error(['please check the name for flexible t,e.g.%s.' para.fcn{f}{c}]);
                    end
                    fvector(i) = para.fcc{f}{c}; %% There should be no overlap among the vectors of para.fcn
                end
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.name = para.fon{f};
                matlabbatch{1}.spm.stats.con.consess{n}.tcon.convec = fvector;
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