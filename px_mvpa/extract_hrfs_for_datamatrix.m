function[hrfs] = extract_hrfs_for_datamatrix(group, cond1, roi)
%% group = all / hc / bd / sz
%% condition 1-5
%% roi 1-5

hc_flag = 0;
bd_flag = 0;
sz_flag = 0;

if (strcmp(group, 'all'))
    hc_flag = 1;
    bd_flag = 1;
    sz_flag = 1;
end

if (strcmp(group, 'hc'))
    hc_flag = 1;
end

if (strcmp(group, 'bd'))
    bd_flag = 1;
end

if (strcmp(group, 'sz'))
    sz_flag = 1;
end


path = '/data/local_share/huiai/Documents/EmotionRegulation/MRI_data/'
hc_tmp = cellstr(spm_select('FPListRec', [path 'HC'] , 'SPM.mat'));
bd_tmp = cellstr(spm_select('FPListRec', [path 'BD'] , 'SPM.mat'));
sz_tmp = cellstr(spm_select('FPListRec', [path 'SZ'] , 'SPM.mat'));

roipath = '/data/local_share/huiai/Documents/EmotionRegulation/masks_ROI'
rois = cellstr(spm_select('FPList', roipath, '^*.img'));
nrois = length(rois);

nsess=2;

j=1;
for i = 1:length(hc_tmp)    
    if regexp(hc_tmp{i}, 'results_w16o4')
        hc{j} = hc_tmp{i};
        j=j+1;
    end
end

j=1;
for i = 1:length(bd_tmp)    
    if regexp(bd_tmp{i}, 'results_w16o4')
        bd{j} = bd_tmp{i};
        j=j+1;
    end
end

j=1;
for i = 1:length(sz_tmp)    
    if regexp(sz_tmp{i}, 'results_w16o4')
        sz{j} = sz_tmp{i};
        j=j+1;
    end
end

load(hc{1});
basis =SPM.xBF.bf;
nbf = size(basis,2);

conditions = {SPM.Sess(1).U.name};
ncond = length(conditions);

cond_ind1 = [nbf*(cond1-1)+1:nbf*(cond1-1)+nbf];
%cond_ind2 = [nbf*(cond2-1)+1:nbf*(cond2-1)+nbf];



    for r = 1:length(rois)
        R = spm_read_vols(spm_vol(rois{r}));
        roi_ind{r} = find(R);
        betas{1} = [];%zeros(ncond, nbf);
    end

if (hc_flag)
    display('Calculating group HC');
    g=1;
    for s = 1:length(hc)
        subject_folder = fileparts(hc{s});
        %% read betas for subject s
        
        display(sprintf('\t *) Subject %d', s))
        for sess = 1:nsess
            for c = 1:length(cond_ind1)
                cond = cond_ind1(c);
                V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
                betas{1}(g,s,sess,c) = nanmean(V(roi_ind{roi}));
              
            end
%             for c = 1:length(cond_ind2)
%                 cond = cond_ind2(c);
%                 V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
%                 betas{1}(g,s,sess,c) =  betas{1}(g,s,sess,c) - nanmean(V(roi_ind{roi}));              
%             end
            
        end
    end
    
end

if (sz_flag)
    display('Calculating group SZ')
    g=2;
    for s =  [1:13 15:length(sz)]
        subject_folder = fileparts(sz{s});
        %% read betas for subject s
        
        display(sprintf('\t *) Subject %d', s))
        for sess = 1:nsess
            for c = 1:length(cond_ind1)
                cond = cond_ind1(c);
                
                V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
                
                betas{1}(g,s,sess,c) = nanmean(V(roi_ind{roi}),1);
            end
            
%             for c = 1:length(cond_ind2)
%                 cond = cond_ind2(c);
%                 V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
%                 betas{1}(g,s,sess,c) =  betas{1}(g,s,sess,c) - nanmean(V(roi_ind{roi}));              
%             end
%             
            
        end
    end
end

if (bd_flag)
    display('Calculating group BD')
    g=3;
    for s = 1:length(bd)
        subject_folder = fileparts(bd{s});
        %% read betas for subject s
      
        display(sprintf('\t *) Subject %d', s))
        for sess = 1:nsess
            for c = 1:length(cond_ind1)
                cond = cond_ind1(c);
                V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
                betas{1}(g,s,sess,c) = nanmean(V(roi_ind{roi}),1);
            end
%             
%             for c = 1:length(cond_ind2)
%                 cond = cond_ind2(c);
%                 V = spm_read_vols(spm_vol(sprintf('%s/beta_%04d.nii', subject_folder, cond)));
%                 betas{1}(g,s,sess,c) =  betas{1}(g,s,sess,c) - nanmean(V(roi_ind{roi}));              
%             end    
        end
    end
end

g_use=[];
if hc_flag 
    g_use = 1;
    sub{1} = 1:14;
end

if sz_flag
    g_use= [g_use 2];
    sub{2} = 1:16;
end

if bd_flag
    g_use = [g_use 3];
    sub{3} = 1:17;
end

ind=1;
for gi = 1:length(g_use)
    g = g_use(gi);
    display(sprintf('group : %d', g));
    [folder roiname  ext ] = fileparts(rois{roi});
    
    for s = 1:length(sub{g})
       
        for sess = 1:2
            hrf_per_session{1}(s,:,sess) = squeeze(betas{1}(g,s,sess,:))' * basis';
        end
        subject_hrf{1}(ind,:) =nanmean(hrf_per_session{1}(s,:,:),3);
        display(sprintf('- subject : %d (%d)', s, ind));
        
        ind = ind+1;
    end
    
    
end


hrfs = subject_hrf{1};
