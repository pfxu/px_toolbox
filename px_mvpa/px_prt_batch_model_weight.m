function px_prt_batch_model_weight(para,fdp)
%=========================================================================
% FORMAT px_prt_batch_model_weight(para,fdp)
% 
%  Input
%   para.name_group - group name, cell format.
%   para.subj_vec   - vectors of subjecs in each group, cell format. e.eg.,{1:30} for one group, {1:30,1:30} for two group.
%   para.name_feat  - feature name;
%   para.name_model -';  
%   para.name_class -;
%   para.name_cond  -;
%   para.cv_type    - 'losgo';
%   para.data_op    - 0
%   fdp.prt         - ;
%  Output
%  
% Pengfei Xu, 03/10/2014,@UMCG
%=========================================================================
if ~isfield(para,'op');[para.op] = fileparts(fdp.prt);end
ng = length(para.name_group);
nc = length(para.cn);
if ng ~= numel(para.subj_vec);
    error('There are %d numbers for subjects, which do not match number of group (d%)',(para.subj_vec),ng);
end
matlabbatch{1}.prt.model.infile = {fdp.prt};
matlabbatch{1}.prt.model.name_model = para.name_model;
matlabbatch{1}.prt.model.use_kernel = 1;
matlabbatch{1}.prt.model.fsets = para.name_feat;
for c = 1:nc
    matlabbatch{1}.prt.model.model_type.classification.class(c).name_class = para.name_class{c};
    for g = 1:ng
        matlabbatch{1}.prt.model.model_type.classification.class(c).group(g).gr_name = para.name_group{g};
        matlabbatch{1}.prt.model.model_type.classification.class(c).group(g).subj_nums = para.subj_vec{g};
        for ic = 1:nc
            matlabbatch{1}.prt.model.model_type.classification.class(c).group(g).conditions.conds(ic).name_cond = para.name_cond{ic};
        end
    end
end
matlabbatch{1}.prt.model.model_type.classification.machine_cl.svm.svm_args = '-s 0 -t 4 -c 1';
% matlabbatch{1}.prt.model.model_type.regression.machine_rg.krr.krr_args = 1;
% matlabbatch{1}.prt.model.model_type.regression.machine_rg.rvr = struct([]);
switch lower(para.cv_type)
    case 'loso'
        if para.cv_k == 1
            matlabbatch{1}.prt.model.cv_type.cv_loso = 1;
        else
            matlabbatch{1}.prt.model.cv_type.cv_lkso.k_args = para.cv_k;
        end
    case 'losgo'
        if para.cv_k == 1
            matlabbatch{1}.prt.model.cv_type.cv_losgo = 1;
        else
            matlabbatch{1}.prt.model.cv_type.cv_lksgo.k_args = para.cv_k;
        end
    case 'lobo'
        if para.cv_k == 1
            matlabbatch{1}.prt.model.cv_type.cv_lobo = 1;
        else
            matlabbatch{1}.prt.model.cv_type.cv_lkbo.k_args = para.cv_k;
        end
    case 'loro'
        matlabbatch{1}.prt.model.cv_type.cv_loro = 1;
    case 'custom'
        matlabbatch{1}.prt.model.cv_type.cv_custom = para.cv_c;
end
matlabbatch{1}.prt.model.include_allscans = 0; % para.allscans  - 0/1
matlabbatch{1}.prt.model.sel_ops.data_op_mc = 0;% para.op_mc - 0/1
if para.data_op == 0
    matlabbatch{1}.prt.model.sel_ops.use_other_ops.no_op = 1;
else
    matlabbatch{1}.prt.model.sel_ops.use_other_ops.data_op = {para.data_op};
end

matlabbatch{2}.prt.cv_model.infile(1) = cfg_dep;
matlabbatch{2}.prt.cv_model.infile(1).tname = 'Load PRT.mat';
matlabbatch{2}.prt.cv_model.infile(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.prt.cv_model.infile(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.prt.cv_model.infile(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.prt.cv_model.infile(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.prt.cv_model.infile(1).sname = 'Specify model: PRT.mat file';
matlabbatch{2}.prt.cv_model.infile(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.prt.cv_model.infile(1).src_output = substruct('.','files');
matlabbatch{2}.prt.cv_model.name_model(1) = cfg_dep;
matlabbatch{2}.prt.cv_model.name_model(1).tname = 'Model name';
matlabbatch{2}.prt.cv_model.name_model(1).tgt_spec{1}.name = 'strtype';
matlabbatch{2}.prt.cv_model.name_model(1).tgt_spec{1}.value = 's';
matlabbatch{2}.prt.cv_model.name_model(1).sname = 'Specify model: Model name';
matlabbatch{2}.prt.cv_model.name_model(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.prt.cv_model.name_model(1).src_output = substruct('.','mname');
matlabbatch{2}.prt.cv_model.perm_test.no_perm = 1;
% matlabbatch{1}.prt.cv_model.perm_test.perm_t.N_perm = pra.nperm;%1000;
% matlabbatch{1}.prt.cv_model.perm_test.perm_t.flag_sw = para.sw; % 0/1;

matlabbatch{3}.prt.weights.infile(1) = cfg_dep;
matlabbatch{3}.prt.weights.infile(1).tname = 'Load PRT.mat';
matlabbatch{3}.prt.weights.infile(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.prt.weights.infile(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.prt.weights.infile(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.prt.weights.infile(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.prt.weights.infile(1).sname = 'Run model: PRT.mat file';
matlabbatch{3}.prt.weights.infile(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1});
matlabbatch{3}.prt.weights.infile(1).src_output = substruct('.','files');
matlabbatch{3}.prt.weights.name_model(1) = cfg_dep;
matlabbatch{3}.prt.weights.name_model(1).tname = 'Model name';
matlabbatch{3}.prt.weights.name_model(1).tgt_spec{1}.name = 'strtype';
matlabbatch{3}.prt.weights.name_model(1).tgt_spec{1}.value = 's';
matlabbatch{3}.prt.weights.name_model(1).sname = 'Specify model: Model name';
matlabbatch{3}.prt.weights.name_model(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.prt.weights.name_model(1).src_output = substruct('.','mname');
matlabbatch{3}.prt.weights.img_name = ''; % para.imgn
matlabbatch{3}.prt.weights.flag_cwi = 0;% para.cwi = 0/1
% save
save(fullfile(para.op,'matlabbatch_model_weight'),'matlabbatch');
% run
% px_prt_batch_initialize;
prt_gui = prt_cfg_batch;
cfg_util('addapp', prt_gui)
cfg_util('run', matlabbatch);