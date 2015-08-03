function px_spm8_regions(xSPM,SPM,hReg,xY,nsess)
%  FORMAT px_spm8_regions(xY,nsess)
%  Usage This function is used to extract the VOI time-series  
%       xY.name - name of VOI;
%       xY.def  - VOI definition 
%                 Including {'sphere', 'box', 'mask', 'cluster', 'all'}.
%       xY.xyz  - centre of VOI {mm}, only for {'sphere', 'box', 'cluster'}
%       xY.spec - VOI definition parameters, only for {'sphere', 'box',
%                 'mask'}
%                 If 'sphere', input sphere radius
%                 If 'box', input box dimensions
%                 If 'mask', input full path of mask file, cell format
%       nsess   - number of sessions of the task.
%  Pengfei Xu, 2013/1/26, @BNU
%% Open SPM Results
    %     clear SPM
    %     clear xSPM
    %     [hReg,xSPM,SPM] = px_spm8_results(pathmat,ic,'none',0.99,0) %% No semicolon here.
%% Extract 1st eigenvariate from the ROI
    for s = 1: nsess
%         clear Y
%         clear xY
        spm('defaults', 'FMRI');
        xY.Sess = s;
        xY.Ic = 0;%contrast used to adjust data (0 - no adjustment)
        if strcmp(xY.def,'mask'); xY.spec = spm_vol(xY.spec); end
        [Y xY] = spm_regions(xSPM,SPM,hReg,xY);
    end
