function [Ys] = px_spm8_ppi_voi(fdp,para)
%  FORMAT px_spm8_ppi_voi(fdp,para)
%  Usage This function is used to extract the VOI time-series
%   Input
%     fdp.SPM    - fullpath of SPM.mat
%     fdp.mask   - full path of mask file, cell format
%     para.op    - output path
%     para.ic    - indices of contrasts (in SPM.xCon).
%     para.thresDesc - description of height threshold (string), 
%                      'FWE|FDR|none'.
%     para.p     - pvalue
%     para.k     - number of voxels in each cluster
%     para.vsess - vector of sessions/runs of the task. e.g.,[1:4] OR [2].
%     para.ad    - contrast used to adjust data (0 - no adjustment); %xY.IC
%     para.def   - VOI definition
%                  Including: 'sphere', 'box', 'mask', 'cluster', 'all'.
%
%     para.xyz  - centre of VOI {mm}, only for {'sphere', 'box', 'cluster'}
%                 Note: one VOI in one column!
%     para.spec - VOI definition parameters, only for 'sphere' and 'box':
%                 If 'sphere', input sphere radius
%                 If 'box', input box dimensions
%     para.name - name of the VOI.
%  Pengfei Xu, 2013/1/26, @BNU
%  Revised by Pengfei Xu, 10/01/2013
%  Revised by Pengfei Xu, Dec-9-2014, from px_spm8_regions.
%==========================================================================

%% check input
data_input = {'SPM','mask'};
para_input = {'ic','thresDesc','p','k','ad','def'};
for p = 1: length(para_input)
    if ~isfield(para,para_input{p});
        error(['No input ''para.' para_input{p} '''!']);
    end
end
if strcmpi(para.def,'mask')
    if ~isfield(para,'xyz')
        error('No input ''para.xyz''');
    end
    if ~isfield(para,'spec')
        error('No input ''para.spec''');
    end
    if ~isfield(para,'name')
        error('No input ''para.spec''');
    end
end
if ~isfield(fdp,data_input{1});
    error(['No input ''fdp.' data_input{1} '''!']);
end
if isfield (para,'op')
    if ~exist(para.op,'dir')
        mkdir(para.op);
    end
end
%% Load SPM Results
clear SPM xSPM
[hReg,xSPM,SPM] = px_spm8_results(fdp,para.ic,para.thresDesc,para.p,para.k) %% No semicolon here.
%% Extract 1st eigenvariate from the ROI
% check sessions (which for 1st-level rather than 2nd-level)
if isfield(SPM,'Sess')
    nS = length(SPM.Sess);
    if length(para.vsess) > nS;
        error(['Too many input sessions(para.vsess) > data sessions (' num2str(nS) ').']);
    end
end
if ~isfield(SPM,'Sess') && isfield(para,'vsess')
    nS = 0;
    para.vsess = 1;
    warning('No SPM.Sess, did not use the sessions.');
end

Ys = [];
for s = para.vsess
    spm('defaults', 'FMRI');
    xY.Sess       = s;
    xY.Ic         = para.ad;
    xY.def        = para.def;
    if strcmpi(para.def,'mask')
        [xxx,xY.name]   = fileparts(fdp.mask);
        xY.spec.fname = fdp.mask;
        xY.spec       = spm_vol(xY.spec.fname);
    elseif strcmpi(para.def,'sphere')
        xY.name  = para.name;   
        xY.xyz   = para.xyz;
        xY.spec  = para.spec;
    end
    Y             = spm_regions(xSPM,SPM,hReg,xY);
    Ys            = [Y,Ys];
    
    if nS > 1
        fn = ['VOI_' xY.name '_' num2str(s) '.mat'];
    else
        fn = ['VOI_' xY.name '.mat'];
    end
    
    fp = fileparts(fdp.SPM);
    fdp_VOI = fullfile(fp,fn);
    if isfield(para,'op') && ~strcmp(fp,para.op)
        movefile(fdp_VOI,para.op);
        fprintf( 'Movefile %s  to %s\n',fdp_VOI,para.op);
        fdp_VOI = fullfile(para.op,fn);
    end
    if isfield(para,'on')
        fp = fileparts(fdp_VOI);
        fn = ['VOI_' para.on '_' xY.name '_' num2str(s) '.mat'];
        fdp_VOI_on = fullfile(fp,fn);
        movefile(char(fdp_VOI),char(fdp_VOI_on),'f');
        fprintf( 'Movefile %s  to %s\n',fdp_VOI,fdp_VOI_on);
    end
end
