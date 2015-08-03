function px_gretna_network(RMat,para,id)
%
% cm   correlation matrix
% para parameters
%      - para.
%      - para.threstype
%
if para.threstype == 's'
    if para.thresrange == 0
        NumNode = length(RMat);
        s_min = log(NumNode) * NumNode / (NumNode * (NumNode - 1) /2); 
        % here, we assure that the mean degree will be larger than 2*log(N) according to Watts and Strogatz, 1998
        thres = s_min:0.01:1;
        for i = 1:length(thres)
            Bin = gretna_R2b(RMat,'s',thres(i));
            [N, K, degree, sw] = gretna_sw_harmonic(Bin, 1, 100);
            
                if sw.Sigma < thres_Sigma
                    if i > 1
                        thr_s_max = thres(i-1);
                    else
                        thr_s_max = inf; % indicate that sigma of this subject is less than thres_Sigma at the lowest thres allowed.
                    end
                    break
                end
                
            end
        end
        
        thres_upper = min(thr_s_max);        
        thres = s_min:0.01:thres_upper;
        if thr_s_max == inf
            error('Subject %d'' sigma is less than the given thres, please reset the parameters',id)
        end
    else
        thres = para.thres;
        if size(Thres,2)~=1
            deltas=Thres(2)-Thres(1);
        end
    end
            for sub = 1:SubID
                sub
                [sw_auc{sub,1}] = gretna_sw_auc(RMat, s_min,thres_upper,0.01,100,'s');
                [sw_eff_auc{sub,1}] = gretna_efficiency_auc(RMat, 0.1,thres_upper,0.01,0,'s');
                
                for i = 1:length(thres)
                    Bin = gretna_R2b (RMat, 's', thres(i));
                    [nodal] = gretna_node_centrality(Bin, [1 1 1], 'bin'); % row corresponds to subjects; column thres;
                    node_para.degree(sub,i,:) = nodal.degree;
                    node_para.efficiency(sub,i,:) = nodal.efficiency;
                    node_para.betweenness(sub,i,:) = nodal.betweenness;
                end
                
                % generate the auc of each nodal measurement for every subject
                for reg = 1:NumNode
                    k = node_para.degree(sub,:,reg);
                    e = node_para.efficiency(sub,:,reg);
                    bw = node_para.betweenness(sub,:,reg);
                    node_para.adegree(sub,reg) = (sum(k) -  sum(k([1 end]))/2)*0.01;
                    node_para.aefficiency(sub,reg) = (sum(e) -  sum(e([1 end]))/2)*0.01;
                    node_para.abetweenness(sub,reg) = (sum(bw) -  sum(bw([1 end]))/2)*0.01;
                end
            end
end