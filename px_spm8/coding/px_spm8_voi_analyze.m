function varargout = px_spm8_voi_analyze(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function is used to extract VOI time course from normalized EPI image
%   The output is the mean/voxel values of the VOI in a text file.
%
%   FORMAT  px_spm8_voi_analyze
%
%   FORMAT  VOITC = px_spm8_voi_analyze
%
%   FORMAT  VOITC = px_spm8_voi_analyze(fdp,para);
%     Input
%       fdp.P           - fullpath of the images.e.g., P = spm_select('ExtFPList','/Volumes/Data/', '^w.*\.img$');
%       para.op         - output path of the time series .txt file.
%       para.VOIname    - output name of the text file, e.g.,'VOI001'.
%       para.vt         - voi type
%                         - 'r', ROI-wised
%                         - 'v', Voxel-wised
%       para.mt         - mask type
%                         - 'm', mask image
%                         - 's', sphere
%       para.XYZmm      - <Only for sphere> coordinated in MNI space, e.g., [6, 40, 30] for x, y, and z. 
%       para.R          - <only for sphere> radius,in mm, e.g. 6. 
%       para.T          - <Only for mask image> The mask file or template file.                             
%       para.ROIIndex   -  <Only for mask image> The index of ROI in the mask file or template file.
%     Output
%       VOITC           - time course of the VOI.
%__________________________________________________________________________
%   Pengfei Xu, QCCUNY, 12/18/2011
%   Revised by PX 07/15/2013 added voxel-wised from px_VOITC to px_mean_tc_voi.
%   Revised by PX 09/19/2013 added mask-based voi from px_mean_tc_voi to px_spm8_voi.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load image filess
if nargin == 0,
    [Finter,~,CmdLine] = spm('FnUIsetup','SimpleROIBuilder',0);
    Fig = spm('FigName','Extract VOI time course from Input Image',Finter,CmdLine);
    
    para.vt = spm_input('Type','+1','b','ROI wise|Voxel wise',['r';'v']);
    para.mt = spm_input('Type','+1.2','b','Sphere|Mask',['s';'m']);
    if strcmpi(para.mt,'s')
        para.XYZmm = spm_input('Coordinates[x y z]:','+1.4','i');
        % check coordinate
        if size(para.XYZmm,2) ~= 3, error('Please check your input coordinates');end
        para.R = spm_input('Radius:','+1.6','n');
        %para.VOIname = spm_input('Name of the output text file:','+1.6','s');
        para.VOIname = spm_input('Name of the output text file:','+1.8','s');
        if spm('Ver') == 'SPM5'|'SPM8'
            %fdp.P = spm_select(Inf,'.*.img','Select Images');
            fdp.P = spm_select(Inf,'image','Select Images');
        else
            %fdp.P = spm_get(Inf,'.*.img','Select Images');
            fdp.P = spm_get(Inf,'image','Select Images');
        end;
    elseif strcmpi(para.mt,'m')
        %fdp.P  = spm_select(Inf,'.*.img','Select Images to Be Extracted');
        fdp.P  = spm_select(Inf,'image','Select Images to Be Extracted');
        %para.T = spm_select(Inf,'.*.img','Select Mask File');
        para.T = spm_select(Inf,'image','Select Mask File');
        para.ROIIndex = spm_input('Index of mask in the mask file:','+1','e','1');
        para.VOIname = spm_input('Name of the output text file:','+1.2','s');
    end
    para.op = spm_select(1,'dir','Select Output Directory');
    set(Fig, 'Visible', 'off');
    px_spm8_voi(fdp,para);
    return
end
% check image file
if isempty(fdp.P);
    error('There is no file to load, Please check your data path');
end
%%
switch lower(para.mt)
    case 's'
        % check coordinate
        if size(para.XYZmm,2) ~= 3, error('Please check your input coordinates');end
        % check input num of VOIname and coordinates
        if strcmpi(para.vt,'v') && numel(para.VOIname) ~= size(para.XYZmm,1);
            error('Number of VOIname is %d ~= number of cood(%d)',numel(para.VOIname),size(para.XYZmm,2));
        end
        BeginingTime = cputime;
        V = spm_vol(fdp.P);
        nscan = length(V); nVOI = size(para.XYZmm,1);
        %% read time series -----------------------------------------------
        SCALE  = cell(nscan,1); DIM  = cell(nscan,1);
        VoxDim = cell(nscan,1); TYPE = cell(nscan,1);
        %  read hdr -------------------------------------------------------
        for i = 1:nscan
            fprintf('Read scan number: %d\n', i);
            filename = V(i).fname(1:end-4);
            fid = fopen([filename,'.hdr'],'r','native');%%.hdr/.nii
            if fid >0
                fseek(fid,40,'bof'); dim = fread(fid,8,'int16'); byteswap = 'native';
                if dim(1)<0 | dim(1)>15,
                    fclose(fid);
                    if spm_platform('bigend')
                        fid = fopen(fname,'r','ieee-le');byteswap = 'ieee-le';
                    else
                        fid = fopen(fname,'r','ieee-be');byteswap = 'ieee-be';
                    end;
                end;
            else
                error(['Problem opening header file (' fopen(fid) ').']);
            end;
            fseek(fid,112,'bof');    funused1	    = fread(fid,1,'float');
            fseek(fid,40+72+32,'bof'); glmin		= fread(fid,1,'int32');
            if isempty(glmin), error(['Problem reading header file (' fopen(fid) ').']); end;
            fseek(fid,40+30,'bof');    DataType     = fread(fid,1,'int16');
            SCALE{i}      	= funused1;
            SCALE{i}    	= ~SCALE{i}  + SCALE{i};
            DIM{i} = V(i).dim;
            VoxDim{i} = abs([V(i).mat(1,1),V(i).mat(2,2),V(i).mat(3,3)]);
            fclose(fid);
            %  read image -------------------------------------------------
            fid = fopen([filename,'.img'],'r',byteswap);
            if fid < 0
                error(sprintf('Error opening data file. Please check whether the %s.img file exist',filename));
            end
            switch DataType
                case 2
                    TYPE{i} = 'uint8';
                case 4
                    TYPE{i} = 'int16';
                case 8
                    TYPE{i} = 'float32';
                case 16
                    TYPE{i} = 'float';
                case 32
                    TYPE{i} = 'float32';
                case 64
                    TYPE{i} = 'double';
                otherwise
                    error('Invalid data type!');
            end
            %   extract time series ---------------------------------------
            xresol = DIM{i}(1); yresol = DIM{i}(2); nslice = DIM{i}(3);
            %EPIImageTimeSeries = zeros(nscan, xresol, yresol, nslice); %%this line will clear the genarated from the before loop.
            EPIImage = fread(fid, TYPE{i});
            if SCALE{i} ~= 1 & SCALE{i} ~= 0; EPIImage = SCALE{i}*EPIImage; end
            fclose(fid);
            EPIImageTimeSeries(i, :,:,:) = reshape(EPIImage, xresol, yresol,nslice);
        end
        %%  calculate mean value of the VOI -------------------------------
        VOImean = zeros(nscan,nVOI);
        VOIall = [];
        for j = 1:nVOI
            fprintf('VOI number: %d\n', j);
            for k = 1:nscan
                % radius in voxel space. Assume all dimension has the same voxel size
                if (VoxDim{i}(1) ~= VoxDim{i}(2)) || (VoxDim{i}(1) ~= VoxDim{i}(3));
                    error(['The voxel is not dometric, check the',num2str(i,'%03.0f'), 'scan.'])
                end
                Rvox = para.R/VoxDim{i}(1);
                % VOI Origin
                VOIO = para.XYZmm(j,:); VOIO=round(inv(V(i).mat)*[VOIO,1]');
                VOIO=VOIO(1:3); VOIO=reshape(VOIO,1,length(VOIO));
                X0vox = VOIO(1); Y0vox = VOIO(2); Z0vox = VOIO(3);
                nvox = 0; meanv = 0;
                for x=1:xresol,
                    for y=1:yresol,
                        for z=1:nslice,
                            distance = sqrt((x-X0vox)^2 + (y-Y0vox)^2 + (z-Z0vox)^2);
                            if distance <= Rvox,
                                if strcmp(flag,'r') && isnan(EPIImageTimeSeries(k, x, y, z))
                                    
                                    %EPIImageTimeSeries(k, x, y, z) = 0; %%%if the
                                    %time course is nan, set it to zero.
                                    
                                    continue % if the time course is nan, it will not be counted.
                                end
                                nvox = nvox + 1;
                                meanv = meanv + EPIImageTimeSeries(k, x, y, z);
                                % if the two ROIs are overlap, set the overlap part of the later one to zero.
                                %EPIImageTimeSeries(k, x, y, z) = 0;
                                % if the two ROIs are overlap, set the overlap part of the later one to nan
                                %EPIImageTimeSeries(k, x, y, z) = nan;
                                if strcmp(flag,'v')
                                    VOIall(k,nvox) = meanv;
                                end
                            end;
                        end;
                    end;
                end;
                VOImean(k,j) = meanv/nvox;
            end
            if strcmp(flag,'v');
                VOITC = VOIall;
                if nargout ~= 0; varargout{1} = VOITC; end
                fname = [para.VOIname{j} '.txt'];
                save(fullfile(para.op,fname), 'VOIall', '-ASCII', '-DOUBLE','-TABS');
                ElapsedTime =cputime - BeginingTime;
                fprintf('\n\t Extracting VOI time courses done, elapsed time: %g seconds.\n', ElapsedTime);
            end
            if strcmp(flag,'r') && numel(para.VOIname) > 1
                
            end
        end
        VOITC = VOImean;
        if strcmp(flag,'r') && numel(para.VOIname) == 1
            %  save VOITC;
            if nargout ~= 0; varargout{1} = VOITC; end
            fname = [para.VOIname{v} '.txt'];
            save(fullfile(para.op,fname), 'VOImean', '-ASCII', '-DOUBLE','-TABS');
            ElapsedTime =cputime - BeginingTime;
            fprintf('\n\t Extracting VOI time courses done, elapsed time: %g seconds.\n', ElapsedTime);
        end
    case 'm'
        VOITC = px_voi_mask(fdp,para)
        varargout{1} = VOITC;
end


function [mean_tc] = px_voi_mask(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is only used to calculate the original mean time course in
% each of ROI defined by mask file.
% Input
%   fdp.P        - An array of image files, char format.
%   para.VOIname
%   para.T       - The mask file or template file.
%   para.RoiIndx - The index of ROI in the mask file or template file.
%   para.vt
% Revised by PX 07/15/2013 from px_VOITC_mask to px_mean_tc_mask.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Mask = para.T;
Info_mask = spm_vol(Mask);
[Ymask, ~] = spm_read_vols(Info_mask);
Ymask = round(Ymask);
mean_tc = [];
for j = 1:length(para.ROIIndex)
    Region = para.ROIIndex(j);
    ind = find(Region==Ymask(:));
    [I,J,K] = ind2sub(size(Ymask),ind);
    XYZ = [I J K]';
    XYZ(4,:) = 1;
    VY = spm_get_data(fdp.P,XYZ);
    
    % mean_tc(:,j) = mean(VY,2);
    % Revised By PX 07/12/2013 for NaN value.
    for x = 1: size(VY,1) % row
        n = 0;
        for y = 1: size(VY,2) % col
            if strcmpi(para.vt,'r')
                if isnan(VY(x,y));continue;end
            end
            n = n + 1;
            tvy(n) = VY(x,y); % non-NaN VY
        end
        if strcmpi(para.vt,'r')
            mean_tc(x,j) = mean(tvy);
        elseif strcmpi(para.vt,'v')
            mean_tc(x,n) = VY(x,y);
        end
    end
    %  save VOITC;
    if strcmp(flag,'r') && numel(para.VOIname) == 1
        fname = [para.VOIname{v} '.txt'];
        save(fullfile(para.op,fname), 'VOImean', '-ASCII', '-DOUBLE','-TABS');
        ElapsedTime = cputime - BeginingTime;
        fprintf('\n\t Extracting VOI time courses done, elapsed time: %g seconds.\n', ElapsedTime);
    end
end
return