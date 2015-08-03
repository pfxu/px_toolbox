function px_gretna_network(Matrix , ModeList , Para , OutputDir , SubjNum)

% Pengfei Xu 03/28/2013, based on gretna_ForkProcess of gretna-1.0-beta.
if isnumeric(SubjNum)
    SubjNum = sprintf('sub_%.3d' , SubjNum);
end
if ischar(Matrix)
    Matrix=load(Matrix);
end

Thres=str2num(Para.ThresRegion);
if size(Thres,2)~=1
    deltas=Thres(2)-Thres(1);
end

NumRandNet=Para.NumRandNet;
if strcmp(Para.ThresType , 'r')
    ThresType='r';%correlation coefficient
else
    ThresType='s';%sparsity
end

if strcmp(Para.NetType , 'w')
    NetType=1;%weighted
else
    NetType=0;
end

if strcmp(Para.ModulAlorithm , 'g')
    Algorithm='1';%greedy optimization
else
    Algorithm='2';
end

sw.nodalCp    =[];
sw.Cp         =[];
sw.nodalLp    =[];
sw.Lp         =[];
if NumRandNet~=0
    sw.Cprand=[];
    sw.Cp_zscore=[];
    sw.Lprand=[];
    sw.Lp_zscore=[];
    sw.Lambda=[];
    sw.Gamma=[];
    sw.Sigma=[];
end

eff.nodallocE =[];
eff.locE      =[];
eff.nodalgE   =[];
eff.gE        =[];
if NumRandNet~=0
    eff.locErand=zeros(NumRandNet, size(Thres, 2));
    eff.locE_zscore=[];
    eff.gErand=zeros(NumRandNet, size(Thres, 2));
    eff.gE_zscore=[];
    eff.Gamma=[];
    eff.Lambda=[];
    eff.Sigma=[];
end

NodeD.degree        =[];
NodeG.gE            =[];
NodeB.bi            =[];

M.Ci=[];
M.numberofmodule_real   = [];
M.modularity_real       = [];
M.numberofmodule_zscore = [];
M.modularity_zscore     = [];

r.real        =[];
r.rand        =[];
r.zscore      =[];
beta.real     =[];
beta.rand     =[];
beta.zscore   =[];
S.real        =[];
S.rand        =[];
S.zscore      =[];

A=cell(size(Thres , 2) , 1);
for j=1:size(Thres , 2)
    [bin , ~] = gretna_R2b(Matrix , ThresType , Thres(1,j));
    if NetType
        TempMatrix=Matrix.*bin;
    else
        TempMatrix=bin;
    end
    
    A{j}=TempMatrix;
end
for i=1:size(ModeList , 1)
    Mode=lower(ModeList{i});
    switch(Mode)
        case {'small_world'; 'efficiency'; 'modularity'; 'assortativity';...
                'hierarchy'; 'synchronization'};
            TempDir=sprintf('%s%sRandTmp%s', OutputDir, filesep, SubjNum);
            if exist(TempDir, 'dir')==7
                rmdir(TempDir, 's');
            end
            mkdir(TempDir);
            if ~isempty(strcmpi(ModeList , 'SmallWorld')) || ...
                    ~isempty(strcmpi(ModeList , 'Efficiency')) || ...
                    ~isempty(strcmpi(ModeList , 'Modularity')) || ...
                    ~isempty(strcmpi(ModeList , 'Assortativity')) || ...
                    ~isempty(strcmpi(ModeList , 'Hierarchy')) || ...
                    ~isempty(strcmpi(ModeList , 'Synchronization'))
                if NumRandNet~=0
                    for i=1:NumRandNet
                        fprintf(['\n Subject: ' num2str(SubjNum) ,...
                            ' - Generate the RANDOM NETWORK #' num2str(i,'%03.0f') ':']);
                        for j=1:size(Thres , 2)
                            TempA = A{j} - diag(diag(A{j}));
                            TempA = abs(TempA);
                            if NetType
                                RandNet = gretna_gen_random_network1_weight(TempA);
                            else
                                RandNet = gretna_gen_random_network1(TempA);
                            end
                            save(sprintf('%s%s%.4d%.4d.mat',TempDir,filesep,i,j),'RandNet');
                            fprintf('. ');
                        end
                    end
                end
            end
    end
end
for i=1:size(ModeList , 1)
    Mode=lower(ModeList{i});
    switch(Mode)
        case 'small_world'
            for j=1:size(Thres , 2)
                if NetType
                    [~, ~, thres_sw]=...
                        gretna_sw_harmonic_weight(A{j}, '2' , 0 , 1);
                else
                    [~, ~, thres_sw]=...
                        gretna_sw_harmonic(A{j} , 0 , 1);
                end
                if NumRandNet~=0
                    thres_sw.Cprand      = zeros(NumRandNet, 1);
                    thres_sw.Lprand      = zeros(NumRandNet, 1);
                    
                    for n=1:NumRandNet
                        Tmp=load(sprintf('%s%s%.4d%.4d', TempDir, filesep, n, j));
                        RandNet=Tmp.RandNet;
                        if NetType
                            [Cprand, ~] = ...
                                gretna_node_clustcoeff_weight(RandNet , '2');
                            [Lprand, ~] = gretna_node_shortestpathlength_weight(RandNet);
                        else
                            [Cprand, ~] = ...
                                gretna_node_clustcoeff(RandNet);
                            [Lprand, ~] = gretna_node_shortestpathlength(RandNet);
                        end
                        thres_sw.Cprand(n, 1) = Cprand;
                        
                        thres_sw.Lprand(n, 1) = Lprand;
                        fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                            num2str(Thres(1,j),'%3.2f') ' RANDOM NETWORK #',...
                            num2str(n,'%03.0f') ' - SMALL WORLD finished!\n']);
                    end
                    thres_sw.Cp_zscore = (thres_sw.Cp - mean(thres_sw.Cprand))...
                        ./std(thres_sw.Cprand);
                    thres_sw.Lp_zscore = (thres_sw.Lp - mean(thres_sw.Lprand))...
                        ./std(thres_sw.Lprand);
                    thres_sw.Gamma  = thres_sw.Cp/mean(thres_sw.Cprand);
                    thres_sw.Lambda = thres_sw.Lp/mean(thres_sw.Lprand);
                    thres_sw.Sigma  = thres_sw.Gamma/thres_sw.Lambda;
                    %Sum
                    sw.Cprand       = [sw.Cprand    , thres_sw.Cprand];
                    sw.Cp_zscore    = [sw.Cp_zscore , thres_sw.Cp_zscore];
                    sw.Lprand       = [sw.Lprand    , thres_sw.Lprand];
                    sw.Lp_zscore    = [sw.Lp_zscore , thres_sw.Lp_zscore];
                    
                    sw.Lambda       = [sw.Lambda    , thres_sw.Lambda];
                    sw.Gamma        = [sw.Gamma     , thres_sw.Gamma];
                    sw.Sigma        = [sw.Sigma     , thres_sw.Sigma];
                end
                sw.nodalCp=[sw.nodalCp , thres_sw.nodalCp'];
                sw.Cp=[sw.Cp , thres_sw.Cp];
                sw.nodalLp=[sw.nodalLp , thres_sw.nodalCp'];
                sw.Lp=[sw.Lp , thres_sw.Lp];
                
                if j==size(Thres , 2)
                    if j~=1
                        sw.anodalCp=...
                            (sum(sw.nodalCp,2)-sum(sw.nodalCp(:,[1 end]),2)/2)*deltas;
                        sw.aCp= (sum(sw.Cp)-sum(sw.Cp([1 end]))/2)*deltas;
                        sw.anodalLp=(sum(sw.nodalLp,2)-sum(sw.nodalLp(:,[1 end]),2)/2)*deltas;
                        sw.aLp=(sum(sw.Lp)-sum(sw.Lp([1 end]))/2)*deltas;
                        if NumRandNet~=0
                            sw.aCp_zscore = (sum(sw.Cp_zscore) -  sum(sw.Cp_zscore([1 end]))/2)*deltas;
                            sw.aLp_zscore = (sum(sw.Lp_zscore) -  sum(sw.Lp_zscore([1 end]))/2)*deltas;
                            sw.aGamma     = (sum(sw.Gamma)     -  sum(sw.Gamma([1 end]))/2)*deltas;
                            sw.aLambda    = (sum(sw.Lambda)    -  sum(sw.Lambda([1 end]))/2)*deltas;
                            sw.aSigma     = (sum(sw.Sigma)     -  sum(sw.Sigma([1 end]))/2)*deltas;
                        end
                    end
                    output(Mode,OutputDir,SubjNum,sw);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - SMALL WORLD finished!\n']);
            end
        case 'efficiency'
            for j=1:size(Thres , 2)
                if NetType
                    [~, ~ , thres_eff]=gretna_sw_efficiency_weight(A{j}, 0, 1);
                else
                    [~, ~, thres_eff]=gretna_sw_efficiency(A{j}, 0, 1);
                end
                
                if NumRandNet~=0
                    thres_eff.locErand    = zeros(NumRandNet, 1);
                    thres_eff.gErand      = zeros(NumRandNet, 1);
                    
                    for n=1:NumRandNet
                        Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                        RandNet=Tmp.RandNet;
                        if NetType
                            [locErand , ~] = gretna_node_local_efficiency_weight(RandNet);
                            [gErand   , ~] = gretna_node_global_efficiency_weight(RandNet);
                        else
                            [locErand , ~] = gretna_node_local_efficiency(RandNet);
                            [gErand   , ~] = gretna_node_global_efficiency(RandNet);
                        end
                        thres_eff.locErand(n, 1) = locErand;
                        thres_eff.gErand(n, 1)   = gErand;
                    end
                    fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ' ,...
                        num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                        num2str(n,'%03.0f') '- EFFICIENCY finished!\n']);
                    
                    thres_eff.locE_zscore  = (thres_eff.locE-mean(thres_eff.locErand))...
                        ./std(thres_eff.locErand);
                    thres_eff.gE_zscore    = (thres_eff.gE - mean(thres_eff.gErand))...
                        ./std(thres_eff.gErand);
                    thres_eff.Gamma        = thres_eff.locE/mean(thres_eff.locErand);
                    thres_eff.Lambda       = thres_eff.gE/mean(thres_eff.gErand);
                    thres_eff.Sigma        = thres_eff.Gamma/thres_eff.Lambda;
                    
                    eff.locErand(:,j)=thres_eff.locErand;
                    eff.locE_zscore=[eff.locE_zscore , thres_eff.locE_zscore];
                    eff.gErand(:,j)=thres_eff.gErand;
                    eff.gE_zscore=[eff.gE_zscore , thres_eff.gE_zscore];
                    
                    eff.Gamma=[eff.Gamma , thres_eff.Gamma];
                    eff.Lambda=[eff.Lambda , thres_eff.Lambda];
                    eff.Sigma=[eff.Sigma , thres_eff.Sigma];
                end
                eff.nodallocE =[eff.nodallocE , thres_eff.nodallocE'];
                eff.locE      =[eff.locE  , thres_eff.locE];
                eff.nodalgE   =[eff.nodalgE , thres_eff.nodalgE'];
                eff.gE        =[eff.gE , thres_eff.gE];
                
                if j==size(Thres , 2)
                    if j~=1
                        eff.anodallocE=(sum(eff.nodallocE,2)-sum(eff.nodallocE(:,[1 end]),2)/2)*deltas;
                        eff.alocE=(sum(eff.locE)-sum(eff.locE([1 end]))/2)*deltas;
                        eff.anodalgE=(sum(eff.nodalgE,2)-sum(eff.nodalgE(:,[1 end]),2)/2)*deltas;
                        eff.agE=(sum(eff.gE)-sum(eff.gE([1 end]))/2)*deltas;
                        if NumRandNet~=0
                            eff.alocE_zscore = (sum(eff.locE_zscore) -  sum(eff.locE_zscore([1 end]))/2)*deltas;
                            eff.agE_zscore   = (sum(eff.gE_zscore)   -  sum(eff.gE_zscore([1 end]))/2)*deltas;
                            eff.aGamma       = (sum(eff.Gamma)       -  sum(eff.Gamma([1 end]))/2)*deltas;
                            eff.aLambda      = (sum(eff.Lambda)      -  sum(eff.Lambda([1 end]))/2)*deltas;
                            eff.aSigma       = (sum(eff.Sigma)       -  sum(eff.Sigma([1 end]))/2)*deltas;
                        end
                    end
                    output(Mode,OutputDir,SubjNum,eff);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - EFFICIENCY finished!\n']);
            end
        case 'nodedegree'
            for j=1:size(Thres , 2)
                if NetType
                    [~ , thres_ei]=gretna_node_degree_weight(A{j});
                else
                    [~ , thres_ei]=gretna_node_degree(A{j});
                end
                NodeD.degree=[NodeD.degree , thres_ei'];
                if j==size(Thres , 2)
                    if j~=1
                        NodeD.adegree=(sum(NodeD.degree, 2)-sum(NodeD.degree(:,[1 end]), 2)/2)*deltas;
                    end
                    output(Mode,OutputDir,SubjNum,NodeD);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' NODE - DEGREE finished!\n']);
            end
        case 'nodeefficiency'
            for j=1:size(Thres , 2)
                if NetType
                    [~ , thres_GEi]=gretna_node_global_efficiency_weight(A{j});
                else
                    [~ , thres_GEi]=gretna_node_global_efficiency(A{j});
                end
                NodeG.gE=[NodeG.gE , thres_GEi'];
                if j==size(Thres , 2)
                    if j~=1
                        NodeG.agE=(sum(NodeG.gE, 2)-sum(NodeG.gE(:,[1 end]), 2)/2)*deltas;
                    end
                    output(Mode,OutputDir,SubjNum,NodeG);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' NODE - EFFICIENCY finished!\n']);
            end
        case 'nodebetweenness'
            for j=1:size(Thres , 2)
                if NetType
                    [~, thres_bi]=gretna_node_betweenness_weight(A{j});
                else
                    [~, thres_bi]=gretna_node_betweenness(A{j});
                end
                NodeB.bi=[NodeB.bi , thres_bi'];
                if j==size(Thres , 2)
                    if j~=1
                        NodeB.abi=(sum(NodeB.bi, 2)-sum(NodeB.bi(:,[1 end]), 2)/2)*deltas;
                    end
                    output(Mode,OutputDir,SubjNum,NodeB);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' NODE - BETWEENNESS finished!\n']);
            end
        case 'modularity'
            for j=1:size(Thres , 2)
                if NetType
                    thres_M=gretna_modularity_weight(A{j}, Algorithm , 0);
                else
                    thres_M=gretna_modularity(A{j}, Algorithm , 0);
                end
                M.numberofmodule_real=...
                    [M.numberofmodule_real ,thres_M.numberofmodule_real];
                M.modularity_real=[M.modularity_real , thres_M.modularity_real];
                M.Ci=[M.Ci, thres_M.Ci];
                if NumRandNet~=0
                    if Algorithm == '1'
                        thres_M.numberofmodule_rand=[];
                        thres_M.modularity_rand=[];
                        for n=1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            [Ci_rand , Q_rand]=gretna_modularity_Danon(RandNet);
                            thres_M.numberofmodule_rand=...
                                [thres_M.numberofmodule_rand ; max(Ci_rand)];
                            thres_M.modularity_rand=...
                                [thres_M.modularity_rand ; Q_rand];
                            fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                                num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                                num2str(n,'%03.0f') '- MODULARITY finished!\n']);
                        end
                    elseif Algorithm == '2'
                        thres_M.numberofmodule_rand=[];
                        thres_M.modularity_rand=[];
                        for n=1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            [Ci_rand , Q_rand]=gretna_modularity_Newman(RandNet);
                            thres_M.numberofmodule_rand=...
                                [thres_M.numberofmodule_rand ; max(Ci_rand)];
                            thres_M.modularity_rand=...
                                [thres_M.modularity_rand ; Q_rand];
                            fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                                num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                                num2str(n,'%03.0f') ' - MODULARITY finished!\n']);
                        end
                    end
                    thres_M.modularity_zscore =...
                        (thres_M.modularity_real - mean(thres_M.modularity_rand))...
                        /std(thres_M.modularity_rand);
                    thres_M.numberofmodule_zscore =...
                        (thres_M.numberofmodule_real - mean(thres_M.numberofmodule_rand))...
                        /std(thres_M.numberofmodule_rand);
                end
                M.modularity_zscore = [M.modularity_zscore ,...
                    thres_M.modularity_zscore];
                M.numberofmodule_zscore = [M.numberofmodule_zscore ,...
                    thres_M.numberofmodule_zscore];
                if j==size(Thres , 2);
                    output(Mode,OutputDir,SubjNum,M);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - MODULARITY finished!\n']);
            end
        case 'assortativity'
            for j=1:size(Thres , 2)
                if NetType
                    thres_r=gretna_assortativity_weight(A{j}, 0);
                    if NumRandNet~=0
                        thres_r.rand=zeros(NumRandNet, 1);
                        for n = 1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            H_rand     = sum(sum(RandNet))/2;
                            Mat_rand   = RandNet;
                            Mat_rand(Mat_rand~=0) = 1;
                            [deg_rand] = sum(Mat_rand);
                            K_rand     = sum(deg_rand)/2;
                            [i_rand , j_rand , v_rand] = find(triu(RandNet,1));
                            
                            degi_rand=[];
                            degj_rand=[];
                            for k_rand = 1:K_rand
                                degi_rand = [degi_rand ; deg_rand(i_rand(k_rand))];
                                degj_rand = [degj_rand ; deg_rand(j_rand(k_rand))];
                            end
                            thres_r.rand(n, 1)=...
                                ((sum(v_rand.*degi_rand.*degj_rand)/H_rand - (sum(0.5*(v_rand.*(degi_rand+degj_rand)))/H_rand)^2)...
                                /(sum(0.5*(v_rand.*(degi_rand.^2+degj_rand.^2)))/H_rand - (sum(0.5*(v_rand.*(degi_rand+degj_rand)))/H_rand)^2));
                            fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                                num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                                num2str(n,'%03.0f') ' - ASSORTATIVITY finished!\n']);
                        end
                        thres_r.zscore = (thres_r.real - mean(thres_r.rand))...
                            /(std(thres_r.rand));
                    end
                else
                    thres_r=gretna_assortativity(A{j}, 0);
                    if NumRandNet~=0
                        thres_r.rand=zeros(NumRandNet, 1);
                        for n = 1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            [deg_rand] = sum(RandNet);
                            K_rand     = sum(deg_rand)/2;
                            [i_rand , j_rand] = find(triu(RandNet,1));
                            
                            degi_rand=[];
                            degj_rand=[];
                            for k_rand = 1:K_rand
                                degi_rand = [degi_rand ; deg_rand(i_rand(k_rand))];
                                degj_rand = [degj_rand ; deg_rand(j_rand(k_rand))];
                            end
                            thres_r.rand(n, 1)=...
                                ((sum(degi_rand.*degj_rand)/K_rand - (sum(0.5*(degi_rand+degj_rand))/K_rand)^2)...
                                /(sum(0.5*(degi_rand.^2+degj_rand.^2))/K_rand - (sum(0.5*(degi_rand+degj_rand))/K_rand)^2));
                        end
                        thres_r.zscore = (thres_r.real - mean(thres_r.rand))...
                            /(std(thres_r.rand));
                    end
                end
                r.real=[r.real , thres_r.real];
                r.rand=[r.rand , thres_r.rand];
                r.zscore=[r.zscore , thres_r.zscore];
                if j==size(Thres , 2);
                    output(Mode,OutputDir,SubjNum,r);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - ASSORTATIVITY finished!\n']);
            end
        case 'hierarchy'
            for j=1:size(Thres , 2)
                if NetType
                    thres_beta=gretna_hierarchy_weight(A{j}, 0);
                else
                    thres_beta=gretna_hierarchy(A{j}, 0);
                end
                
                if NumRandNet~=0
                    thres_beta.rand=zeros(NumRandNet, 1);
                    if NetType
                        for n=1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            [~,ki_rand]= ...
                                gretna_node_degree_weight(RandNet);
                            [~,cii_rand] = ...
                                gretna_node_clustcoeff_weight(RandNet , '2');
                            if all(cii_rand == 0) || all(ki_rand == 0)
                                thres_beta.rand(n, 1) = ...
                                    nan;
                            else
                                index_rand1 = find(ki_rand == 0);
                                index_rand2 = find(cii_rand == 0);
                                ki_rand([index_rand1 index_rand2]) = [];
                                cii_rand ([index_rand1 index_rand2]) = [];
                                
                                stats_rand = regstats(log(cii_rand),log(ki_rand),'linear','beta');
                                thres_beta.rand(n, 1) =...
                                    -stats_rand.beta(2);                                
                            end
                           fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                               num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                               num2str(n,'%03.0f') ' - HIERARCHY finished!\n']); 
                        end
                    else
                        for n=1:NumRandNet
                            Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                            RandNet=Tmp.RandNet;
                            [~,ki_rand]= ...
                                gretna_node_degree(RandNet);
                            [~,cii_rand] = ...
                                gretna_node_clustcoeff(RandNet);
                            if all(cii_rand == 0) || all(ki_rand == 0)
                                thres_beta.rand(n, 1) = ...
                                    nan;
                            else
                                index_rand1 = find(ki_rand == 0);
                                index_rand2 = find(cii_rand == 0);
                                ki_rand([index_rand1 index_rand2]) = [];
                                cii_rand ([index_rand1 index_rand2]) = [];
                                
                                stats_rand = regstats(log(cii_rand),log(ki_rand),'linear','beta');
                                thres_beta.rand(n, 1) =...
                                    -stats_rand.beta(2);
                            end
                            fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                                num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #',...
                                num2str(n,'%03.0f') '- HIERARCHY finished!\n']);
                        end
                    end
                    thres_beta.zscore = (thres_beta.real - mean(thres_beta.rand(~isnan(thres_beta.rand))))...
                        /std(thres_beta.rand(~isnan(thres_beta.rand)));
                end
                
                beta.real=[beta.real , thres_beta.real];
                beta.rand=[beta.rand , thres_beta.rand];
                beta.zscore=[beta.zscore , thres_beta.zscore];
                if j==size(Thres , 2);
                    output(Mode,OutputDir,SubjNum,beta);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - HIERARCHY finished!\n']);
            end
        case 'synchronization'
            for j=1:size(Thres , 2)
                if NetType
                    thres_S=gretna_synchronization_weight(A{j}, 0);
                else
                    thres_S=gretna_synchronization(A{j}, 0);
                end
                
                if NumRandNet~=0
                    thres_S.rand=zeros(NumRandNet, 1);
                    for n=1:NumRandNet
                        Tmp=load(sprintf('%s%s%.4d%.4d',TempDir,filesep,n,j));
                        RandNet=Tmp.RandNet;
                        Deg_rand = sum(RandNet);
                        
                        D_rand = diag(Deg_rand,0);
                        G_rand = D_rand - RandNet;
                        Eigenvalue_rand = sort(eig(G_rand));
                        
                        thres_S.rand(n, 1) = ...
                            Eigenvalue_rand(2)/Eigenvalue_rand(end);
                        fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                            num2str(Thres(1,j),'%3.2f') ' RAND NETWORK #' num2str(n,'%03.0f') ' - SYNCHRONIZATION finished!\n']);
                    end
                    thres_S.zscore = ...
                        (thres_S.real - mean(thres_S.rand(~isnan(thres_S.rand))))...
                        /std(thres_S.rand(~isnan(thres_S.rand)));
                end
                S.real=[S.real , thres_S.real];
                S.rand=[S.rand , thres_S.rand];
                S.zscore=[S.zscore , thres_S.zscore];
                if j==size(Thres , 2);
                    output(Mode,OutputDir,SubjNum,S);
                end
                fprintf(['Subject: ' num2str(SubjNum) ' Threshold: ',...
                    num2str(Thres(1,j),'%3.2f') ' REAL NETWORK - SYNCHRONIZATION finished!\n']);
            end
    end
end
if exist('TempDir','var');rmdir(TempDir, 's');end

function output(Mode,OutputDir,SubjNum,ModeName)
Mode     = lower(Mode);
ChildDir = fullfile(OutputDir, Mode, SubjNum);
% ChildDir=sprintf(['%s%s' Mode '%s'],OutputDir , filesep , SubjNum);
if exist(ChildDir,'dir')==7
    rmdir(ChildDir,'s');
    mkdir(ChildDir);
else
    mkdir(ChildDir);
end
ResultName = fieldnames(ModeName);
% MN = px_varname(ModeName);
for k=1:size(ResultName , 1)
    save([ChildDir , filesep , ResultName{k} , '.txt'],'-struct' , 'ModeName' , ResultName{k} , '-ASCII', '-DOUBLE','-TABS');
end
return