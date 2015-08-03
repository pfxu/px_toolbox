function px_spm8_vbm_batch(fdp,para,mode)
%FORMAT px_spm8_vbm_batch(fdp,para)
% Usage Batch for VBM, including estimate&write, check data quality (check
%       slices of segment and normalization, and check sample homogeneity
%       using covariance), and smothing.
% Input
%   fdp.scan     - full path of input t1 NIfTI data
%   fdp.cov      - full path of input nuisance file, cell format. The input
%                  nuisance file should be '.mat' or '.text', which contains
%                  a m-by-n matrix, with m observers (in rows) and n nuisance
%                  (in columns).
%   para.type    - To calculate gray matter or white matter?
%                  - 1. gray matter <DEFAULT>
%                  - 2, white matter
%                  - 3, gray matter & white matter
%   para.clean   - Clean up any partitions
%                  - 0, Dont do cleanup;
%                  - 1, Light Clean; <DEFAULT>
%                  - 2, Thorough Clean;
%   para.regtype - Affine regularisation
%                  - '', No affine registration;
%                  - 'mni', ICBM space template - European brains;
%                  - 'eastern', ICBM space template - East Asian brains; <DEFAULT>
%                  - 'subj', Average sized template;
%                  - 'none', No regularisation.%
%   para.scale   - proportional scaling.
%                  - 0, 'No'
%                  - 1, 'Yes'. e.g., when you dispaly t1 volumes.<DEFAULT>
%   para.slice   - the horizontal slice in mm. <DEFAULT,0>.%
%   para.gap     - Gap to skip slices. To speed up calculations you can
%                  define that only every x slice the covariance is estimated.
%                  <DEFAULT,5>
%   para.fwhm    - the full-width at half maximun(FWHM) of the Gaussian
%                  smoothing kernel in mm.
%   para.pf      - prefix for output files. <default = 's'>
%   mode         - steps to prcossed.{'est&write','checkwm','checkcov','smooth'}
%                  - 'est&write'
%                  - 'checkwm'
%                  - 'checkcov'
%                  - 'smooth'
% Oputput
%     The files after smoothing with the specific prefix <default = 's'>.
% Note: The prefix of structure 's' and the prefix of smoothed data 's'.
%  Pengfei Xu, 2013/08/26, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'type'); para.type = 1;end
if para.type == 1; prefix = 'm0wrp1';end
if para.type == 2; prefix = 'm0wrp2';end
if para.type == 3; prefix = 'm0wrp';end
for nf = 1:length(mode)
    flag = lower(mode{nf});
    switch(flag)
        case 'ext&write'
            if ~isfield(para,'clean'); para.clean = 1;end
            if ~isfield(para,'regtype'); para.regtype = 'eastern';end
            cwd = pwd;
            for ns = 1:length(fdp.scan)
                ps = fileparts(fdp.scan{ns});
                cd(ps);
                fprintf('\nVBM Est&write: Changing directory to: %s\n', ps);
                px_spm8_vbm_estwr(fdp,para);
            end
            cd(cwd);
            fprintf('\n Changing directory back to: %s\n', cwd);
        case 'checkwm'
            if ~isfield(para,'scale'); para.scale = 1;end
            if ~isfield(para,'sclice'); para.sclice = 0;end
            cwd = pwd;
            sfdp.scan = cell(length(fdp.scan),1);
            for ns = 1:length(fdp.scan)
                % [ps,~,ext] = fileparts(fdp.scan{ns});
                % sfdp.scan = spm_select('ExtFPList',ps,['^wm.*\.' ext]);
                ps = fileparts(fdp.scan{ns});
                scan = spm_select('ExtFPList',ps,'^wm.*\.');
                sfdp.scan(ns) = cellstr(scan);
            end
            ps = fileparts(fdp.scan{1});
            cd(ps);
            fprintf('\nVBM Showslices: Changing directory to: %s\n', ps);
            px_spm8_vbm_showslice(sfdp,para);
            pause(10);
            cd(cwd);
            fprintf('\n Changing directory back to: %s\n', cwd);
        case 'checkcov'
            if ~isfield(para,'scale'); para.scale = 1;end
            if ~isfield(para,'sclice'); para.sclice = 0;end
            if ~isfield(para,'gap'); para.gap = 5;end
            cwd = pwd;
            sfdp.scan = cell(length(fdp.scan),1);
            n = 0;
            for ns = 1:length(fdp.scan)
                ps = fileparts(fdp.scan{ns});
                scan = cellstr(spm_select('ExtFPList',ps,['^' prefix '.*\.']));%'^m0wrp1.*\.'
                for nscan = 1:length(scan)
                    n = n + 1;
                    sfdp.scan(n) = scan(nscan);
                end
            end
            px_spm8_vbm_check_cov(sfdp,para);
            pause(10); 
            cd(fileparts(fdp.scan{1}));
            spm_figure('Print');
            cd(cwd);
        case 'smooth'
            if ~isfield (para,'fwhm'); para.fwhm = [8 8 8];end
            if ~isfield (para,'pf'); para.pf = 's';end
            sfdp.scan = cell(length(fdp.scan),1);
            n = 0;
            for ns = 1:length(fdp.scan)
                ps = fileparts(fdp.scan{ns});
                scan = cellstr(spm_select('ExtFPList',ps,['^' prefix '.*\.']));%'^m0wrp1.*\.'
                for nscan = 1:length(scan)
                    n = n + 1;
                    sfdp.scan(n) = scan(nscan);
                end
            end
            px_spm8_preprocess_smooth(sfdp,para);
    end
end