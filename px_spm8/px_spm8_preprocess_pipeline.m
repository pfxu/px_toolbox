function px_spm8_preprocess_pipeline(dp,para,mode)
% FORMAT px_spm8_preprocess_pipeline(dp,para,mode)
%  Usage Call the spm8 for preprocess.
%   Input
%    %Datapath
%     dp.op  - datapth for output data(dcm2nii) or batchlog.
%     dp.fun - datapath for functional image;
%     dp.ana - datapath for structural iamge;
%     dp.les - datapath for lesion mask;
%     dp.tmp - full datapath of the template used for normalization (only
%              for the normalization with user defined template). e.g.,('../templates/b2k.nii').
%    %Parameters
%     para.vsub         - vector of subjects; e.g., use px_ls_number.m to
%                         check the number of the subject under the
%                         directory of the datapath.
%     para.nrun         - number of functional runs;
%     para.flag         - 0, according to the vsub;                              <                                                                                    -
%                       - 1, list all the tables with px_ls;
%     para.predirsub    - prefix of the direcotry of subjects; <default,''>
%     para.predirfundcm - prefix of the direcotry of functional dicom runs; <default,'func'>
%     para.prediranadcm - prefix of the direcotry of structural dicom runs; <default,'t1_mprage'>
%     para.predirfun    - prefix of the direcotry of functional runs. e.g.,'run';
%     para.predirana    - prefix of the direcotry of structural runs. e.g.,'t1';
%     para.prefun       - prefix of the functional image files; <default,''>
%     para.preana       - prefix of the structural image files; <default,''>
%     para.preles       - prefix of the lesion image files; <default,''>
%     para.ndt          - type of the NIfTI data; <default,'.nii'>
%     % dcm2nii
%     para.ddt          - type of the dicom data, e.g. 'IMA','dcm',no suffix ''; <default,''>
%     % slicetiming
%     para.ns - number of slices;
%     para.tr - TR;
%     para.so - slice order, e.g.,[1:2:33,2:2:32];
%     para.rs - reference slice. <default = 1>
%     % realign
%     para.hm - 1, head motion calculation only; 0, realign with head
%               motion calculation.
%     % coregisterest
%     para.core_fwhm  - FWHM Gaussian filter for coregistration. <default,
%                      [7 7]>. e.g., [13 13] for Baboon.
%     para.pre_source - Prefix of source image; Default - 'mean'.
%     % lesion
%     % segment
%       para.clean   - Clean up any partitions
%                      - 0, Dont do cleanup;
%                      - 1, Light Clean; <default>
%                      - 2, Thorough Clean;
%       para.seg_regtype - Affine regularisation
%                      - '', No affine registration;
%                      - 'mni', ICBM space template - European brains;
%                      - 'eastern', ICBM space template - East Asian brains;
%                      - 'subj', Average sized template;
%                      - 'none', No regularisation.
%     % normalize
%       para.norm_regtype   - Affine regularisation
%                        - 'mni'
%                        - 'subj'
%                        - 'none'
%       para.bb        - boulding box. e.g.,[-90 -126 -72;90 90 108].<default,[-78 -112 -50;78 76 85]>
%       para.vox       - voxel size. <default, [2 2 2]>
%       para.norm_type - normalizatoin type (only for normalize_write option)
%                        -0, normalize by using EPI tmeplate;
%                        -1, normalize by using T1 tmeplate without segmentation;
%                        -2, normalize by using T2 tmeplate;
%                        -3, normalize by using other user defined tmeplate;
%     % smooth
%       para.fwhm - the full-width at half maximun(FWHM) of the Gaussian
%                   smoothing kernel in mm.<default, [8 8 8]>
%     % matlabpool
%     % para.psize - how many workers to connect parallel.
%    %Modes
%      - {'dcm2nii','slicetiming','realign','coregister_est'/'coregister_estwrite',
%         'lesion'/'segment','normalise_write'/'normalise_estwrite','smooth'};
%     % 1. After dcm2nii convertion, reorient the origin of the t1 image to
%          the  anterior commissure;
%     % 2. After the preprocess, check the normalize and the
%          coregistration.
%  Output:
%   HeadMotion  - dircetory of all the headmotoin calculations.
% Pengfei Xu, 2013/08/08, QC,CUNY.
% Revised by PX, 08/23/2014, Normalise: write to source img (structure) as well.
%==========================================================================

% close all
% check input parameters;
if isfield(dp,'les'); dl = dp.les;end
if isfield(dp,'fun'); df = dp.fun;end
if isfield(dp,'ana'); ds = dp.ana;end
if ~isfield(para,'flag'); para.flag = 0;end
if ~isfield(para,'hm'); hm = 0;else hm = para.hm;end
if ~isfield(para.psize); psize = 1;else psize = para.psize;end
if ~isfield(para,'vsub'); error('None defined para.vsub.');end
if isfield(para,'prefun'); prefun = para.prefun;else prefun = [];end
if isfield(para,'preana'); preana = para.preana;else preana = [];end %'s'
if isfield(para,'preles'); preles = para.preles;else preles = [];end
if isfield(para,'predirsub'); predirsub = para.predirsub;else predirsub = [];end
if isfield(para,'predirfundcm'); predirfundcm = para.predirfundcm;else predirfundcm = [];end
if isfield(para,'prediranadcm'); prediranadcm = para.prediranadcm;else prediranadcm = [];end
if isfield(para,'predirfun'); predirfun = para.predirfun;else predirfun = [];end %'run'
if isfield(para,'predirana'); predirana = para.predirana;else predirana = [];end %'t1'
if isfield(para,'predirles'); predirles = para.predirles;else predirles = [];end
if isfield(para,'ndt'); ndt = para.ndt; else ndt = 'nii';end
% check output
if isfield(dp,'op'); 
    op = dp.op;
    if ~exist(op,'dir');
        mkdir(op);
    end;
end
if ~isfield(dp,'op') && isfield(dp,'fun'); 
    op = dp.fun;
end
if ~isfield(dp,'op') && ~isfield(dp,'fun') && isfield(dp,'ana');
    op = dp.ana;
end
if ~isfield(dp,'fun') && ~isfield(dp,'ana') && ~isfield(dp,'les')
    error('No input data path.');
end
% Check parameters of each steps;
fprintf('\n%s',repmat('=',10));
fprintf('\nModes include:');
for nf = 1:length(mode)
    flag = lower(mode{nf});
    switch(flag)
        case 'dcm2nii'
            if ~isfield(para,'ddt'); error('Check the input dicom data type - para.ddt!'); end
            para_dcm.pre  = predirsub;
            para_dcm.ddt  = para.ddt;
            para_dcm.ndt  = ndt;
            para_dcm.flag = para.flag;
            para_dcm.in    = predirfundcm;
            para_dcm.on    = predirfun;
            fprintf('\n%d. dcm2nii', nf);
        case 'slicetiming'
            if ~isfield(para,'rs'); para.rs = 1;end
            para_st.ns           = para.ns;
            para_st.tr           = para.tr;
            para_st.so           = para.so;
            para_st.rs           = para.rs;
            fprintf('\n%d. slicetiming', nf);
        case 'realign'
            fprintf('\n%d. realign', nf);
        case {'coregister_est','coregister_estwrite'}
            if ~isfield(para,'core_fwhm');para.core_fwhm = [7 7];end
            
            if isfield(para,'pre_source')
                pre_source = para.pre_source;
            else
                pre_source = 'mean';%%
            end
            nrun_source = 1;% only firt run has mean image file.
            fprintf('\n%d. %s', nf,flag);
        case 'lesion'
            tbx_cfg_clinical;
            fprintf('\n%d. lesion segmentation', nf);
        case 'segment'
            if ~isfield(para,'clean'); para.clean = 1;end
            para_seg.clean   = para.clean;
            para_seg.regtype = para.seg_regtype;
            if ~isfield(para,'seg_regtype'); error('Check para.seg_regtype, which template is going to be used for Affine regularisation');end
            fprintf('\n%d. segment', nf);
        case 'normalise_write'
            if ~isfield (para,'bb'); para.bb   = [-78 -112 -50;78 76 85];end
            if ~isfield (para,'vox'); para.vox = [2 2 2];end
            
            para_norm.bb  = para.bb;
            para_norm.vox = para.vox;
            fprintf('\n%d. normalise_write', nf);
        case 'normalise_estwrite'
            if ~isfield (para,'bb'); para.bb   = [-78 -112 -50;78 76 85];end
            if ~isfield (para,'vox'); para.vox = [2 2 2];end
            if ~isfield (para,'norm_type');error('Check the para.norm_type,to select a template for normalizaion.');end
            if para.norm_type == 3 && ~isfield (dp,'tmp');
                error('Check the para.tp, select the fullpath of the template for normalization');
            end
            fprintf('\n%d. normalise_estwrite', nf);
        case 'smooth'
            if ~isfield (para,'fwhm'); para.fwhm = [8 8 8];end
            para_smooth.fwhm = para.fwhm;
            fprintf('\n%d. smooth', nf);
    end
end
fprintf('\n%s',repmat('=',10));
% save para
save(fullfile(op,['preprocess_parameters_',date]),'dp','para','mode');
%%
if para.flag == 1;
    if isfield(dp,'fun')
        subj_list = px_ls('Reg',dp.fun,'-D',1);
    end
    if ~isfield(dp,'fun') && isfield(dp,'ana')
        subj_list = px_ls('Reg',dp.ana,'-D',1);
    end
    if ~isfield(dp,'fun') && ~isfield(dp,'ana') && isfield(dp,'les')
        subj_list = px_ls('Reg',dp.les,'-D',1);
    end
    %     subj_num      = length(subj_list);
    %     para.vsub     = 1: subj_num;
end
vsub = para.vsub;
if isfield(para,'nrun');
    nrun = para.nrun;
    fdp_rp.rp = cell(length(vsub),nrun);% datapath of rp*.txt files.
end
matlabpool(psize);
parfor vs = vsub    
    %   cd to subjdir for print figures of realignment and normlization
    if para.flag == 0;
        sn = [predirsub,num2str(vs,'%.3d')];% subject name
        sd = fullfile(df,sn);
        cd(sd);
        fprintf('\nStarting: Changing directory to: %s\n', sd);
    else
        sd = subj_list{vs};
        cd(sd);
        fprintf('\nStarting: Changing directory to: %s\n', subj_list{vs});
    end
    % 
    for nf = 1:length(mode)
        flag = lower(mode{nf});
        switch(flag)
            case 'dcm2nii'
                %para_dcm.vsub = vs;
                if exist('df','var');
                    [~,condir]     = fileparts(df);
                    para_dcm.op    = fullfile(op,condir);
                    para_dcm.ip    = df;
                    [para_dcm_out] = px_spm8_convert_batch(para_dcm);
                    df             = para_dcm_out.op;%% fd
                    predirfun      = para_dcm_out.on;
                    if para.flag == 1;
                        sn         = [predirsub,num2str(vs,'%.3d')];% subject name
                    end
                    sd             = fullfile(df,sn);
                end
                if exist('ds','var');
                    [~,condir]     = fileparts(ds);
                    para_dcm.op    = fullfile(op,condir);
                    para_dcm.ip    = ds;
                    [para_dcm_out] = px_spm8_convert_batch(para_dcm);
                    ds             = para_dcm_out.op;
                    predirana      = para_dcm_out.on;
                end
            case 'slicetiming'
                [scan_st,para_st.op] = px_select(df,vs,nrun,predirsub,predirfun,prefun,ndt,para.flag);
                [para_realign]       = px_spm8_preprocess_slicetiming(scan_st,para_st);
                prefun = para_realign.pf; % prefun after slice timing <default, '^a'>
            case 'realign'
                cd(sd);
                fprintf('   Realing: Changing directory to: %s\n', sd);
                if isempty(prefun); 
                    prefun = 'a';
                end
                [scan_realign.scan,para_reliagn.op] = px_select(df,vs,nrun,predirsub,predirfun,prefun,ndt,para.flag);
                if hm == 0
                    [para_coreg]                    = px_spm8_preprocess_realign(scan_realign,para_reliagn);
                    prefun                          = para_coreg.pf;% prefun after realign <default, '^r'>
                end
            case {'coregister_est','coregister_estwrite'}
                cd(sd);
                fprintf('   Coregistration: Changing directory to: %s\n', sd);
                scan_coreg.ref = px_select(ds,vs,1,predirsub,predirana,preana,ndt,para.flag);%structural image
                scan_coreg.ref = scan_coreg.ref{1};
                if isempty(prefun); 
                    prefun = 'r';
                end
                [scan_coreg.source,para_corg.op] = px_select(df,vs,nrun_source,predirsub,predirfun,pre_source,ndt,para.flag);% functional image
                scan_coreg.source                = scan_coreg.source{1};%^mean* image
                coreg_other                      = px_select(df,vs,nrun,predirsub,predirfun,prefun,ndt,para.flag);
                scan_coreg.other                 = [];
                for i = 1:length(coreg_other)%%% each scan in each run
                    scan_coreg.other = [scan_coreg.other;coreg_other{i}];
                end
                para_corg.core_fwhm = para.core_fwhm;
                if istrcmp(flag,'coregister_est')
                    px_spm8_preprocess_coregister_est(scan_coreg,para_corg);
                else
                    [para_corg] = px_spm8_preprocess_coregister_estwrite(scan_coreg,para_corg);              
                    prefun = para_corg.pf;
                end  
            case 'lesion'% normalize and segment for t1 with lesion
                [scan_les.ana,para_les.op]= px_select(ds,vs,1,predirsub,predirana,preana,ndt,para.flag);
                scan_les.ana = scan_les.ana{1};
                scan_les.les = px_select(dl,vs,1,predirsub,predirles,preles,ndt,para.flag);
                scan_les.les = scan_les.les{1};
                
                % Check the dimensions of lesion mask image and T1 image,
                %       if not match, reslice the lesion to t1.
                scan_les.ana = char(scan_les.ana);
                scan_les.les = char(scan_les.les);
                v_ana        = spm_vol(scan_les.ana);
                v_les        = spm_vol(scan_les.les);
                if any(v_ana.dim ~= v_les.dim) | any(v_ana.mat ~= v_les.mat)
                    [pathstr, name, ext] = fileparts(scan_les.les);
                    les_original    = scan_les.les;
                    scan_les.les    = fullfile(pathstr,['r' name ext]);
                    px_spm8_reslice(les_original,scan_les.les,'',0,v_ana)                    ;
                end   
                % ---------------------------------------------------------
                scan_les.ana = cellstr(scan_les.ana);
                scan_les.les = cellstr(scan_les.les);
                px_spm8_preprocess_normseg_clinical(scan_les,para_les);
            case 'segment'% regular segment
                para_seg.op                 = ds;
                [scan_seg.scan,para_seg.op] = px_select(ds,vs,1,predirsub,predirana,preana,ndt,para.flag);
                scan_seg.scan               = scan_seg.scan{1};
                px_spm8_preprocess_segment(scan_seg,para_seg);
            case {'normalise_write','normalise_estwrite'}
                cd(sd);
                if isempty(prefun); prefun = 'r'; end
                data_norm.src = px_select(ds,vs,1,predirsub,predirana,preana,ndt,para.flag);
                data_norm.src = data_norm.src{1};
                [norm_res,para_norm.op] = px_select(df,vs,nrun,predirsub,predirfun,prefun,ndt,para.flag);
                data_norm.res = [];
                for i = 1:length(norm_res)%%% each scan in each run
                    data_norm.res = [data_norm.res;norm_res{i}];
                end
                data_norm.res = [data_norm.res;data_norm.src]; % Revised by PX, 08/23/2014, write to source img (structure) as well.
                if isfield(para,'norm_type');
                    fprintf('   Normalise estimate & write: Changing directory to: %s\n', sd);
                    % data_norm.src = px_select(ds,vs,1,predirsub,predirana,preana,ndt,para.flag);
                    % data_norm.src = data_norm.src{1};
                    if para.norm_type == 0; data_norm.tmp = {fullfile(spm('dir'),'templates','EPI.nii')}; end
                    if para.norm_type == 1; data_norm.tmp = {fullfile(spm('dir'),'templates','T1.nii')}; end
                    if para.norm_type == 2; data_norm.tmp = {fullfile(spm('dir'),'templates','T2.nii')}; end
                    if para.norm_type == 3; data_norm.tmp = {dp.tmp}; end
                    para_norm.regtype = para.norm_regtype;
                    [para_norm] = px_spm8_preprocess_normalise_estwrite(data_norm,para_norm);
                else
                    fprintf('   Normalise write: Changing directory to: %s\n', sd);
                    data_norm.mat = px_select(ds,vs,1,predirsub,predirana,preana,'_seg_sn.mat',flag);
                    data_norm.mat = data_norm.mat{1};
                    [para_norm]   = px_spm8_preprocess_normalise_write(data_norm,para_norm);
                end
                prefun = para_norm.pf;
            case 'smooth'
                if isempty(prefun); prefun = 'w'; end
                [smooth_data,para.smooth.op]= px_select(df,vs,nrun,predirsub,predirfun,prefun,ndt,para.flag);
                fdp.smooth = [];
                for i = 1:length(smooth_data)%%% each scan in each run
                    fdp.smooth = [fdp.smooth;smooth_data{i}];
                end
                px_spm8_preprocess_smooth(fdp.smooth,para.smooth.op);
        end
        if exist('cwd','var');cd(cwd);fprintf('Changing back to directory: %s\n', cwd);end
    end
end
matlabpool close;
% Calculate head motion ---------------------------------------------------
if ~isempty(cell2mat(strfind(lower(mode),'realign')));
    para_rp.op       = fullfile(df,'HeadMotion');
    para_rp.vsub      = vsub;
    para_rp.nrun      = nrun;
    para_rp.presub = predirsub;
    para_rp.prerun = predirfun;
    ns = 0;
    for vs = vsub
        ns = ns + 1;
        rp = px_select(df,vs,nrun,predirsub,predirfun,'rp','.txt',para.flag);
        for i = 1:length(rp)%%% each scan in each run
            fdp_rp.rp(ns,i) = rp{i};
        end
    end
    px_hm_calc_batch(fdp_rp,para_rp);
end
%--------------------------------------------------------------------------
%
function [files,ps] = px_select(dp,vs,nrun,presub,prerun,predata,ndt,flag)
if flag == 1;
    subj_list = px_ls('Reg',dp,'-D',1);
    sd = subj_list{vs};
    run_list = px_ls('Reg',sd,'-D',1);
    
    files = cell(nrun,1);
    for nr = 1: nrun
        rd = char(run_list{nr});
        data = spm_select('FPList',rd,['^',predata,'.*\.*',ndt,'$']); %scans, '^f.*\.nii$'
        if isempty(data); error('There is no ^%s*%s file under %s',predata,ndt,rd);end
        files{nr} = cellstr(data);% cell format
        %     px_text(sd,'file_processed.txt',files{nr});
    end
else
    sn = [presub,num2str(vs,'%.3d')];% subject name
    sd = fullfile(dp,sn);% subject directory
    files = cell(nrun,1);
    for nr = 1: nrun
        rd = fullfile(sd,[prerun,num2str(nr,'%.3d')]);% run directory
        if ~exist(rd,'dir');
            rd = fullfile(sd,prerun); % run directory
        end
        data = spm_select('FPList',rd,['^',predata,'.*\.*',ndt,'$']); %scans, '^f.*\.nii$'
        if isempty(data); error('There is no ^%s*%s file under %s',predata,ndt,rd);end
        files{nr} = cellstr(data);% cell format
        %     px_text(sd,'file_processed.txt',files{nr});
    end
end
% if nrun == 1; files = files{1};end
% [~,diru] = fileparts(df);% folder of up one level
ps = sd;% path of subject
return