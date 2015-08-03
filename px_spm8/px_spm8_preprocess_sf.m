function px_spm8_preprocess_sf (Output,PathFun,Para,PathT1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_preprocess_sf (Output,PathFun,Para,PathT1) %prefer
% This function is used for data preprocess after cicom convert to nifiti,
%      with segmentation and default bounding box and FWHM(8),Voxle(2).
% For the coregister: Using t1 structure coregister to MEAN function image.
%      I prefer this one (than px_spm8_preprocess_fs), because this one is faster.
% Output = 'Path output';
% PathFun = 'Path of functional images';% One run in one row.
% Para.nslices = 33;
% Para.TR = 2;
% Para.SliceOrder = [1:2:33,2:2:32];
% Para.RefSlice = 1;
% PathT1 = 'Path of structual images';%'^s....image'
%
% Pengfei Xu, 2012/09/03,BNU
% Revised By PX 2013/07/15, check the input func and t1 data.
%==========================================================================
n = 0;
NRun = size(PathFun,1);
DataFun = cell(NRun,1);
for run = 1:NRun
    n = n+1;
    %     DataRun = cellstr(spm_select('ExtFPList',PathFun{run},'.*\.img$'));% Revised By PX 2013/07/15
    DataRun = spm_select('ExtFPList',PathFun{run},'.*\.img$');
    if isempty(DataRun);error('Please check the No.%d run Functional data, which is empty',run);end
    DataFun{n,1} = cellstr(DataRun);
end
%     DataT1 = cellstr(spm_select('ExtFPList',PathT1,'.*\.img$'));% Revised By PX 2013/07/15
DataT1 = spm_select('ExtFPList',PathT1,'^s.*\.img$');
if isempty(DataT1);error('Please check the T1 data, which is empty');end
DataT1 = cellstr(DataT1);
%%%-----------------------------template-----------------------------------
matlabbatch{1}.cfg_basicio.cfg_named_dir.name = 'Subject';
matlabbatch{1}.cfg_basicio.cfg_named_dir.dirs = {{Output}};
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1) = cfg_dep;
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tname = 'Directory';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).sname = 'Named Directory Selector: Subject(1)';
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.cfg_basicio.cfg_cd.dir(1).src_output = substruct('.','dirs', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1) = cfg_dep;
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tname = 'Parent Directory';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(1).value = 'dir';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).sname = 'Named Directory Selector: Subject(1)';
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.parent(1).src_output = substruct('.','dirs', '{}',{1});
matlabbatch{3}.cfg_basicio.cfg_mkdir.name = 'Analysis';
matlabbatch{4}.spm.temporal.st.scans = DataFun;
matlabbatch{4}.spm.temporal.st.nslices = Para.nslices ;
matlabbatch{4}.spm.temporal.st.tr = Para.TR;
matlabbatch{4}.spm.temporal.st.ta = Para.TR-(Para.TR/Para.nslices) ;
matlabbatch{4}.spm.temporal.st.so = Para.SliceOrder;
matlabbatch{4}.spm.temporal.st.refslice = Para.RefSlice;
matlabbatch{4}.spm.temporal.st.prefix = 'a';
for run = 1:NRun
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1) = cfg_dep;
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).tname = 'Session';
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).tgt_spec{1}(1).value = 'image';
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).sname = ['Slice Timing: Slice Timing Corr. Images (Sess ',num2str(run),')'];
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{5}.spm.spatial.realign.estwrite.data{run}(1).src_output = substruct('()',{run}, '.','files');
end
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{5}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{5}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{5}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{5}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{5}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1) = cfg_dep;
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).tname = 'Reference Image';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).value = 'image';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).value = 'e';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1).src_output = substruct('.','rmean');
matlabbatch{6}.spm.spatial.coreg.estimate.source = DataT1;
matlabbatch{6}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{7}.spm.spatial.preproc.data(1) = cfg_dep;
matlabbatch{7}.spm.spatial.preproc.data(1).tname = 'Data';
matlabbatch{7}.spm.spatial.preproc.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{7}.spm.spatial.preproc.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{7}.spm.spatial.preproc.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{7}.spm.spatial.preproc.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{7}.spm.spatial.preproc.data(1).sname = 'Coregister: Estimate: Coregistered Images';
matlabbatch{7}.spm.spatial.preproc.data(1).src_exbranch = substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.spatial.preproc.data(1).src_output = substruct('.','cfiles');
matlabbatch{7}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{7}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{7}.spm.spatial.preproc.output.CSF = [0 0 0];
matlabbatch{7}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{7}.spm.spatial.preproc.output.cleanup = 1;
%%%%%%%%%%%%%%%%%%%%%%%%
g = fullfile (spm('dir'),'tpm','grey.nii');
w = fullfile (spm('dir'),'tpm','white.nii');
c = fullfile (spm('dir'),'tpm','csf.nii');
%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{7}.spm.spatial.preproc.opts.tpm = {g;w;c};
matlabbatch{7}.spm.spatial.preproc.opts.ngaus = [2; 2;2;4];
matlabbatch{7}.spm.spatial.preproc.opts.regtype = 'eastern';
matlabbatch{7}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{7}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{7}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{7}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{7}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{7}.spm.spatial.preproc.opts.msk = {''};
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1) = cfg_dep;
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).tname = 'Parameter File';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).value = 'e';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).sname = 'Segment: Norm Params Subj->MNI';
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).src_exbranch = substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{8}.spm.spatial.normalise.write.subj.matname(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
for run = 1:NRun
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run) = cfg_dep;
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).tname = 'Images to Write';
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).tgt_spec{1}(1).name = 'filter';
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).tgt_spec{1}(1).value = 'image';
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).tgt_spec{1}(2).value = 'e';
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).sname = ['Realign: Estimate & Reslice: Resliced Images (Sess',num2str(run),')'];
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(run).src_output = substruct('.','sess', '()',{run}, '.','rfiles');
end
matlabbatch{8}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{8}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -50
    78 76 85];
matlabbatch{8}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
matlabbatch{8}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{8}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{8}.spm.spatial.normalise.write.roptions.prefix = 'w';
matlabbatch{9}.spm.spatial.smooth.data(1) = cfg_dep;
matlabbatch{9}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
matlabbatch{9}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{9}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{9}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{9}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{9}.spm.spatial.smooth.data(1).sname = 'Normalise: Write: Normalised Images (Subj 1)';
matlabbatch{9}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{9}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{9}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{9}.spm.spatial.smooth.dtype = 0;
matlabbatch{9}.spm.spatial.smooth.im = 0;
matlabbatch{9}.spm.spatial.smooth.prefix = 's';
save (fullfile(Output,'matlabbatch_preprocess'), 'matlabbatch')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spm_figure('Create','Graphics','Graphics','on');
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);