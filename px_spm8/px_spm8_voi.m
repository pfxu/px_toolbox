function [VOITC] = px_spm8_voi(fdp, para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format [VOITC] = px_spm8_voi(fdp,para)
%  Usage  This function was used to extract time course from a specific
%         sphere or mask template.
%  Input
%     fdp.P        - The fullpath of the images, which was in the same space with same dimension.
%                    e.g., P = spm_select('ExtFPList','/Volumes/Data/', '^w.*\.img$');
%     para.vt      - VOI type
%                    - 'r', ROI-wised
%                    - 'v', Voxel-wised
%     para.mt      - Mask type
%                    - 'm', mask image
%                    - 's', sphere
%     % sphere
%     para.op      - The fullpath of output. 
%     para.XYZmm   - The coordinates of each ROI in the template (MNI space).
%     para.R       - The radius of each ROI in the template.In mm, e.g. 6.
%     para.mn      - mask name for output, e.g. 'ROI.nii' OR 'ROI.img'.
%     % mask
%     fdp.T        - The fullpath the mask template.
%     para.ROIInd  - The index of ROIs in the brain template or atlas (e.g.,
%                    [1:40 60:90]). Note that the order of extracted time
%                    course is the same as the order entered in para.ROIInd.
%     para.dm (optional)
%                  - This argument is added for conditions where
%                    the data FOV is not enough to coverage the whole brain.
%                    That is, the data does not cover some of the ROIs.
%  Output
%       VOITC      -
%                    L (# of subjects)*1 cell array with each cell containing
%                    a N (# of time points) * M (# of ROIs) matrix.
%
% Pengfei Xu, 05/01/2013, @BNU, Revised based on gretna_mean_tc.m
%==========================================================================
if isempty(fdp.P);error('No image be selected,check the fdp.P!');end
if ~iscell(fdp.P)
    fdp.P = cellstr(fdp.P);
end
mt = para.mt;
if strcmpi(mt,'s');
    fdp_b2m.T      = fdp.P{1};% only use the 1st one to generate the mask.
    para_b2m.XYZmm = para.XYZmm;
    para_b2m.R     = para.R;
    para_b2m.op    = para.op;
    para_b2m.mn    = para.mn;
    V              = px_spm8_ball2mask(fdp_b2m,para_b2m);
    para.ROIInd    = V.ind;
    %     MNI_coord      = V.XYZmm;
    fdp.T = fullfile(para.op,para.mn);
end

Vtem              = spm_vol(fdp.T);
[Ytem, xxx]         = spm_read_vols(Vtem);
Ytem(isnan(Ytem)) = 0; %% set the value of nan in the mask to 0 =  exclude NaN in the image (rather than set the NaN of image to 0).
Ytem              = round(Ytem);
if isfield('para','dm')
    Vmask = spm_vol(para.dm);
    [Ymask, xxx] = spm_read_vols(Vmask);
    Ymask(logical(Ymask)) = 1;
    Ytem = Ytem.*Ymask;
end

MNI_coord = cell(length(para.ROIInd),1);
for j = 1:length(para.ROIInd)
    Region = para.ROIInd(j);
    ind = find(Region == Ytem(:));
    if ~isempty(ind)
        [I,J,K] = ind2sub(size(Ytem),ind);
        XYZ = [I J K]';
        XYZ(4,:) = 1;
        MNI_coord{j,1} = XYZ;
    else
        error (['There are no voxels in ROI' blanks(1) num2str(para.ROIInd(j)) ', please specify ROIs again']);
    end
end
np    = size(fdp.P,1);
VOITC = cell(np,0);
if cellfun(@isempty,MNI_coord);
    VOITC = 0;
    fprintf('\nContained Voxel count: 0.\n');
else
    for p = 1:np
        scan = fdp.P{p};
        if strcmp(scan(end-1:end),',1');
            scan = scan(1:end-2);
        end
        fprintf('\nExtracting time series for %s: ', scan);
        VP      = spm_vol(scan);
        if strcmpi(para.vt,'r')
            mean_tc = zeros(size(VP,1),length(para.ROIInd));
            for r = 1:length(para.ROIInd)
                VYraw        = spm_get_data(VP,MNI_coord{r,1});
                mean_tc(:,r) = nanmean(VYraw,2); %exclude the NaN especially for sphere (the NaN in mask was exculded in the prevous step)
            end
            VOITC{p,1} = mean_tc;
        elseif strcmpi(para.vt,'v')
            for r = 1:length(para.ROIInd)
                VYraw      = spm_get_data(VP,MNI_coord{r,1});
                VOITC{p,r} = VYraw;
            end
        else
            error('Please specify the para.vt - VOI type.\n');
        end
        % fprintf(' done!\n');
        fprintf('.');
    end
end
return