function [Ys] = px_spm8_regions(fdp,para)
%  FORMAT px_spm8_regions(fdp,para)
%  Usage This function is used to extract the VOI time-series
%   Input
%     fdp.SPM
%     fdp.mask
%     para.op
%     para.ic
%     para.thresDesc
%     para.p
%     para.k
%     para.vsess - vector of sessions/runs of the task. e.g.,[1:4] OR [2].
%     para.ad    - contrast used to adjust data (0 - no adjustment); %xY.IC
%     para.def   - VOI definition
%                  Including {'sphere', 'box', 'mask', 'cluster', 'all'}.
%
%     para.xyz  - centre of VOI {mm}, only for {'sphere', 'box', 'cluster'}
%     para.spec - VOI definition parameters, only for {'sphere', 'box',
%                 'mask'}
%                 If 'sphere', input sphere radius
%                 If 'box', input box dimensions
%                 If 'mask', input full path of mask file, cell format
%  Pengfei Xu, 2013/1/26, @BNU
%  Revised by Pengfei Xu, 10/01/2013
%==========================================================================

%% check input
data_input = {'SPM','mask'};
para_input = {'ic','thresDesc','p','k','ad','def'};
for d = 1:length(data_input)
    if ~isfield(fdp,data_input{d});
        error(['No input ''fdp.' data_input{d} '''!']);
    end
end
for p = 1: length(para_input)
    if ~isfield(para,para_input{p});
        error(['No input ''para.' para_input{p} '''!']);
    end
end
if isfield (para,'op')
    if ~exist(para.op,'dir')
        mkdir(para.op);
    end
end
%% Load SPM Results
[hReg,xSPM,SPM] = px_spm8_results(fdp,para.ic,para.thresDesc,para.p,para.k) %% No semicolon here.
%% Extract 1st eigenvariate from the ROI
% check sessions (which for 1st-level rather than 2nd-level)
if isfield(SPM,'Sess')
    nS = length(SPM.Sess);
    if length(para.vsess)>nS;
        error('Input sessions(para.vsess) is too much.');
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
    [~,xY.name]   = fileparts(fdp.mask);
    xY.Sess       = s;
    xY.Ic         = para.ad;
    xY.def        = para.def;
    xY.spec.fname = fdp.mask;
    xY.spec       = spm_vol(xY.spec.fname);
    Y             = spm_regions(xSPM,SPM,hReg,xY);
    Ys            = [Y,Ys];
    
    if nS > 1
        fn = ['VOI_' xY.name '_' num2str(s) '.mat'];
    else
        fn = ['VOI_' xY.name '.mat'];
    end
    
    fp = fileparts(fdp.SPM);
    fdp_VOI = fullfile(fp,fn);
    if isfield(para,'op')
        movefile(fdp_mat,para.op);
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
