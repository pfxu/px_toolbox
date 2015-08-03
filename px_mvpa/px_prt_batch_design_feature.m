function px_prt_batch_design_feature(para,fdp)
%=========================================================================
% FORMAT px_prt_batch_design_feature(para,fdp)
%
% Input
%  para.op      - outpur path
%  para.tr      - TR
%  para.unit    - 1;% seconds
%  para.hrfover - 6;
%  para.hrfdel  - 6
%  para.gn      - group name, cell format
%  para.ns      - number of subjecs in each group, 1xN Array.
%  para,mod      - modality, cell format;
%  para.review  - 1;
%  para.fn      - feature name;
%  fdp.design   -
%  fdp.scan     -
%  fdp.mask     -
%
% Output
%  PRT.mat
%  FetureName.mat
%  Feature_model.dat
%  matlabbatch_design_feture
%
%  Pengfei Xu, 02/10/2014, @UMCG
%=========================================================================
matlabbatch{1}.prt.data.dir_name = {para.op};
ng = length(para.gn);
nm = length(para.mod);
if ng ~= numel(para.ns);
    error('There are %d numbers for subjects, which do not match number of group (d%)',(para.ns),ng);
end
for g = 1: ng
    matlabbatch{1}.prt.data.group(g).gr_name = para.gn{g};
    for s = 1: para.ns(g)
        for m = 1: nm
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).mod_name = para.mod{m};
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).TR = para.tr;
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).scans = fdp.scan{g}{s,m};
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).design.new_design.unit = para.unit;
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).design.new_design.conds = struct('cond_name', {}, 'onsets', {}, 'durations', {});
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).design.new_design.multi_conds = {fdp.design{g}{s,m}};
            matlabbatch{1}.prt.data.group(g).select.subject{s}(m).design.new_design.covar = {''};
        end
    end
end
%
for m = 1: nm
    matlabbatch{1}.prt.data.mask(m).mod_name = para.mod{m};
    matlabbatch{1}.prt.data.mask(m).fmask = {fdp.mask};
end
%
matlabbatch{1}.prt.data.hrfover = para.hrfover;
matlabbatch{1}.prt.data.hrfdel  = para.hrfdel;
%
matlabbatch{1}.prt.data.review = para.review;
%
matlabbatch{2}.prt.fs.infile(1) = cfg_dep;
matlabbatch{2}.prt.fs.infile(1).tname = 'Load PRT.mat';
matlabbatch{2}.prt.fs.infile(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.prt.fs.infile(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.prt.fs.infile(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.prt.fs.infile(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.prt.fs.infile(1).sname = 'Data & Design: PRT.mat file';
matlabbatch{2}.prt.fs.infile(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.prt.fs.infile(1).src_output = substruct('.','files');
matlabbatch{2}.prt.fs.k_file = para.fn;%'LATFeatures';
for m = 1:nm
    matlabbatch{2}.prt.fs.modality(m).mod_name(1) = cfg_dep;
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).tname = 'Modality name';
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).tgt_spec{1}.name = 'strtype';
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).tgt_spec{1}.value = 's';
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).sname = ['Data & Design: Mod#' num2str(m) ' name'];
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.prt.fs.modality(m).mod_name(1).src_output = substruct('.',['mod_name' num2str(m)]);
    matlabbatch{2}.prt.fs.modality(m).conditions.all_scans = 1;
    %matlabbatch{2}.prt.fs.modality.conditions.all_cond = 1;
    matlabbatch{2}.prt.fs.modality(m).voxels.all_voxels = 1;
    %matlabbatch{2}.prt.fs.modality.voxels.fmask = para.roi;
    matlabbatch{2}.prt.fs.modality(m).detrend.linear_dt.paramPoly_dt = 1;
    %matlabbatch{2}.prt.fs.modality.detrend.dct_dt.param_dt = 128;
    %matlabbatch{2}.prt.fs.modality.detrend.no_dt = 1;
    matlabbatch{2}.prt.fs.modality(m).normalise.no_gms = 1;
end
% save
save(fullfile(para.op,'matlabbatch_design_feture'),'matlabbatch');
% run
px_prt_batch_initialize;
cfg_util('run', matlabbatch);