function px_gretna_network_constrcut(datalist,para,modes)



if ~(exist(para.op , 'dir')==7)
    mkdir(para.op);
end
if ~isfield(para,'subjname')
    error('No para.subjname, please check your input.');
end
fprintf('\n%s',repmat('=',10));
fprintf('\nModes include:');
for m = 1:length(modes)
    mode = lower(modes{m});
    switch(mode)
        case 'detrend'
            fprintf('\nDetred');
            if ~isfield(para,'order')
                para.order  = 1;
            end
            if ~isfield(para,'remain')
                para.remain = 'TRUE';
            end
            if ~isfield(para,'prefix')
                para.prefix = 'd';
            end
        case 'filter'
            fprintf('\nFilter'); 
            if ~isfield(para,'band')
                para.band   = [.01 .08];
            end
            if ~isfield(para,'TR')
                para.TR     = 2;
            end
            if ~isfield(para,'prefix')
                para.prefix = 'b';
            end
        case 'covariates regression'
            fprintf('\nCovariates regression');
%             if ~isfield(para,'BrainMask')
%                 error('No para.BrainMask, please check your input.');
%             end
            if ~isfield(para,'HMBool')
                error('No para.HMBool, please check your input.');
            end
            if ~isfield(para,'HMPath')
                error('No para.HMPath, please check your input.');
            end
            if ~isfield(para,'HMPrefix')
                error('No para.HMPrefix, please check your input.');
            end
            if ~isfield(para,'HMDerivBool')
                error('No para.HMDerivBool, please check your input.');
            end
            if ~isfield(para,'CovCell')
                error('No para.CovCell, please check your input.');
            end
            if ~isfield(para,'prefix')
                para.prefix = 'c';
            end
        case 'voxel-based degree'
            fprintf('\nVvoxel-based degree');
            if ~isfield(para,'BrainMask')
                error('No para.BrainMask, please check your input.');
            end
            if ~isfield(para,'r_thr')
                error('No para.r_thr, please check your input.');
            end
            if ~isfield(para,'Dis')
                error('No para.Dis, please check your input.');
            end
        case 'functional connectivity matrix'
            fprintf('\nFunctional connectivity matrix');
            if ~isfield(para,'labmask')
                error('No para.labmask, please check your input.');
            end
    end
end
fprintf('\n%s',repmat('=',10));
save(fullfile(para.op,['network_constrcut_parameters_',date]),'datalist','para','modes');
fprintf('\n\nRuning:');
for m = 1:length(modes)
    mode = lower(modes{m});
    switch(mode)
        case 'detrend'
            fprintf('\nDetreding...');
            order  = 1;
            remain = 'TRUE';
            prefix = 'd';
            gretna_detrend(datalist , prefix , order , remain);
            ip = fileparts(datalist{1});
            op = fullfile(para.op,'Detrended',para.subjname);
            datalist = px_movefile(ip,op,prefix);
        case 'filter'
            fprintf('\nFiltering...');
            band   = [.01 .08];
            TR     = 2;
            prefix = 'b';
            gretna_bandpass(datalist , prefix , band , TR);
            ip = fileparts(datalist{1});
            op = fullfile(para.op,'Filtered',para.subjname);
            datalist = px_movefile(ip,op,prefix);
        case 'covariates regression'
            fprintf('\nRegressing out the covariates...');
            Config.BrainMask = para.BrainMask;
            Config.HMBool    = para.HMBool;
            Config.HMPath    = para.HMPath;
            Config.HMPrefix  = para.HMPrefix;
            Config.HMDeriv   = para.HMDerivBool;
            Config.Name      = para.subjname;
            Config.CovCell   = para.CovCell;
            prefix = 'c';
            px_gretna_regressout(datalist , prefix , Config);            
            ip = fileparts(datalist{1});
            op = fullfile(para.op,'Regressed',para.subjname);
            datalist = px_movefile(ip,op,prefix);
        case 'voxel-based degree'
            fprintf('\nCalculating the voxel-based degree ...');
            BrainMask   = para.BrainMask;
            R_thr       = para.r_thr;
            Dis         = para.Dis;
            name        = para.subjname;
            op_vbd = fullfile(para.op,'VBDegree',name);
            if ~(exist(op_vbd, 'dir')==7)
                mkdir(op_vbd);
            end
            px_gretna_voxel_based_degree_pipeuse(datalist, op_vbd, BrainMask, R_thr, Dis, name);
        case 'functional connectivity matrix'
            fprintf('\nCalculating the functional connectivity matrix ...');
            op_fc = fullfile(para.op,'FCMatrix');
            if ~(exist(op_fc , 'dir')==7)
                mkdir(op_fc);
            end
            LabMask = para.labmask;
            on_fc   = [op_fc , filesep ,  para.subjname , '.txt'];
            px_gretna_fc(datalist ,  LabMask , on_fc);
    end
end
function datalist = px_movefile(ip,op,prefix)
if ~(exist(op , 'dir')==7)
    mkdir(op);
end
dl = px_ls('Reg',ip,'-F',1,['^' prefix]);
for d = 1:length(dl)
    movefile(dl{d},op)
end
datalist = px_ls('Reg',op,'-F',1,['^' prefix]);