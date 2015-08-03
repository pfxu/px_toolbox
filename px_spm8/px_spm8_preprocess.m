function px_spm8_preprocess(DataFile , CalList , Para , FieldName , pipeline)


GUIPath=fileparts(which('PreprocessInterface.m'));
SPMPath=fileparts(which('spm.m'));

SliOrd=str2num(Para.SliOrd);
VoxelSize=str2num(Para.VoxelSize);
BB=str2num(Para.BB);
FWHM=str2num(Para.FWHM);
FreBand=str2num(Para.FreBand);
T1Image=[];
MatName=[];
DelMsg='';
TimePoint=[];
if ~strcmpi(CalList{1} , 'DICOM TO NIFTI')
    if ischar(DataFile)
        [Path , Name , Ext]=fileparts(DataFile);
       	if strcmp(Ext , '.img')
        	fid=fopen([Path , filesep , Name , '.hdr']);
        else
        	fid=fopen([Path , filesep , Name , Ext]);
        end
        fseek(fid , 48 , 'bof');
        TimePoint=fread(fid , 1 , 'int16');
        fclose(fid);
    end
end
    for j=1:size(CalList , 1)
        Mode=upper(CalList{j});
        switch(Mode)
            case 'DICOM TO NIFTI'
                Output=[Para.NiiDir , filesep , FieldName(6:end)];
                if ~(exist(Output , 'dir')==7)
                    mkdir(Output);
                end
                command='gretna_EPI_dcm2nii(opt.DataFile , opt.Output , opt.SubjName , opt.TimePoint)';
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).command=command;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.DataFile=DataFile;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.Output=Output;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).opt.TimePoint=Para.TimePoint;
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).files_in={DataFile};
                DataFile=[];
                for i=1:Para.TimePoint
                    DataFile=[DataFile ;...
                        {sprintf('%s%s%s_%.4d.nii' , Output , filesep , FieldName(6:end) , i)}];
                end
                pipeline.([FieldName , DelMsg , '_Dcm2Nii']).files_out=DataFile;
                Para.EPIPath=Para.NiiDir;
            case 'DELETE IMAGES'
                if strcmp(Para.DeleteType , 'Delete')
                    ImageNum=Para.ImageNum;
                else
                    if iscell(DataFile)
                        ImageNum=size(DataFile , 1 )-ImageNum;
                    else
                        ImageNum=TimePoint-ImageNum;
                    end
                end
                TimePoint=TimePoint-ImageNum;
                if iscell(DataFile)
                    DataFile(1:ImageNum)=[];
                    DelMsg='_DeleteImage';
                else
                    command='gretna_DeleteImage(opt.DataFile , opt.DeleteNum , opt.Prefix)';
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).command=command;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.DataFile=DataFile;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.DeleteNum=ImageNum;
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).opt.Prefix='n';
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).files_in={DataFile};
                    [Path , File , Ext]=fileparts(DataFile);
                    DataFile=[Path , filesep , 'n' , File , Ext];
                    pipeline.([FieldName , DelMsg , '_DeleteImage']).files_out={DataFile};
                end
            case 'SLICE TIMING'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Slicetiming.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('a' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.scans{1}=FileList;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.nslices=Para.SliceNum;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.so=SliOrd;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.refslice=Para.RefSlice;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.tr=Para.TR;
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.ta=...
                                                Para.TR-(Para.TR/Para.SliceNum);
                SPMJOB.matlabbatch{1,1}.spm.temporal.st.prefix='a';           
                command='spm_jobman(''run'',opt.SliceTimingBatch)';
                pipeline.([FieldName , DelMsg , '_SliceTiming']).command=command;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).opt.SliceTimingBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_SliceTiming']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'REALIGN'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Realignment.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('r' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.spatial.realign.estwrite.data{1}=FileList;
                SPMJOB.matlabbatch{1,1}.spm.spatial.realign.estwrite.roptions.prefix='r';
                HMLogDir=[Para.LogDir , filesep , 'HeadMotion'];
                
                command='gretna_Realign(opt.RealignBatch , opt.HMLogDir , opt.SubjName , opt.EPIPath)';
                pipeline.([FieldName , DelMsg , '_Realign']).command=command;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.RealignBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.HMLogDir=HMLogDir;
                pipeline.([FieldName , DelMsg , '_Realign']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_Realign']).opt.EPIPath=Para.EPIPath;
                pipeline.([FieldName , DelMsg , '_Realign']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Realign']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'NORMALIZE'
                if isempty(Para.RefPath) || ~(exist(Para.RefPath , 'dir')==7)
                    Para.RefPath=Para.EPIPath;
                end
                [FileList , files_in , files_out , DataFile]=...
                	UpdateDataList('w' , DataFile , TimePoint);
                if strcmp(Para.NormType , 'EPI')
                    SPMJOB=load([GUIPath , filesep ,...
                        'Jobsman' , filesep , 'gretna_Normalization_EPI.mat']);
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.eoptions.template=...
                        {[SPMPath , filesep , 'templates' , filesep , 'EPI.nii,1']};
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.subj.resample=FileList;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.bb=BB;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.vox=VoxelSize;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.estwrite.roptions.prefix='w';
                    command='gretna_NormalizeEPI(opt.NormalizeEPIBatch , opt.RefPath , opt.RefPrefix , opt.SubjName)';
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).command=command;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.NormalizeEPIBatch=SPMJOB.matlabbatch;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.RefPath=Para.RefPath;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.RefPrefix=Para.RefPrefix;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).opt.SubjName=FieldName(6:end);
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).files_in=files_in;
                    pipeline.([FieldName , DelMsg , '_NormalizeEPI']).files_out=files_out;
                    if ~isempty(DelMsg)
                        DelMsg=[];
                    end
                else
                    %DICOM TO NII
                    if strcmp(Para.T1D2NBool , 'TRUE')
                        Output=[Para.T1NiiDir , filesep , FieldName(6:end)];
                        if ~(exist(Output,'dir')==7)
                            mkdir(Output);
                        end
                        T1DcmFile=GetNeedDcmFile(Para.T1Path , FieldName(6:end));
                        command='gretna_T1_dcm2nii(opt.T1DcmFile , opt.Output , opt.SubjName)';
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).command=command;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.T1DcmFile=T1DcmFile;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.Output=Output;
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).opt.SubjName=FieldName(6:end);
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).files_in={T1DcmFile};
                        pipeline.([FieldName , DelMsg , '_T1Dcm2Nii']).files_out={[Output , ...
                            filesep , 'coNifti_' , FieldName(6:end) , '.nii']};
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        Para.T1Path=Para.T1NiiDir;
                        T1Image={[Output , filesep , 'coNifti_' , FieldName(6:end) , '.nii']};
                    end
                    
                    %Coregister
                    if strcmp(Para.CorBool , 'TRUE')
                        if isempty(T1Image)
                            T1Image  = gretna_GetNeedFile(Para.T1Path  , Para.T1Prefix  , FieldName(6:end));
                        end
                        SPMJOB=load([GUIPath , filesep ,...
                            'Jobsman' , filesep , 'gretna_Coregister.mat']);
                        SPMJOB.matlabbatch{1,1}.spm.spatial.coreg.estimate.source = T1Image;
                        command='gretna_Coregister(opt.CoregisterBatch , opt.RefPath , opt.RefPrefix , opt.SubjName , opt.T1Image)';
                        pipeline.([FieldName , DelMsg , '_Coregister']).command=command;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.CoregisterBatch=SPMJOB.matlabbatch;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.RefPath=Para.RefPath;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.RefPrefix=Para.RefPrefix;
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.SubjName=FieldName(6:end);
                        pipeline.([FieldName , DelMsg , '_Coregister']).opt.T1Image=T1Image;
                        pipeline.([FieldName , DelMsg , '_Coregister']).files_in=[files_in ; T1Image];
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        [Path , File , Ext]=fileparts(T1Image{1});
                        pipeline.([FieldName , DelMsg , '_Coregister']).files_out=[Path , filesep , 'co' , File , Ext];
                        T1Image={[Path , filesep , 'co' , File , Ext]};
                    end
                    %Segment
                    if strcmp(Para.SegBool , 'TRUE')
                        if isempty(T1Image)
                            T1Image  = gretna_GetNeedFile(Para.T1Path  , Para.T1Prefix  , FieldName(6:end));
                        end
                        SPMJOB=load([GUIPath , filesep ,...
                            'Jobsman' , filesep , 'gretna_Segmentation.mat']);
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.opts.tpm=...
                            {[SPMPath , filesep , 'tpm' , filesep , 'grey.nii'];...
                            [SPMPath , filesep , 'tpm' , filesep , 'white.nii'];...
                            [SPMPath , filesep , 'tpm' , filesep , 'csf.nii']};
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.data=T1Image;
                        SPMJOB.matlabbatch{1,1}.spm.spatial.preproc.opts.regtype=Para.T1Template;
                        command='spm_jobman(''run'' , opt.SegmentBatch)';
                        pipeline.([FieldName , DelMsg , '_Segment']).command=command;
                        pipeline.([FieldName , DelMsg , '_Segment']).opt.SegmentBatch=SPMJOB.matlabbatch;
                        pipeline.([FieldName , DelMsg , '_Segment']).files_in=[files_in ; T1Image];
                        if ~isempty(DelMsg)
                            DelMsg=[];
                        end
                        [Path , File , Ext]=fileparts(T1Image{1});
                        pipeline.([FieldName , DelMsg , '_Segment']).files_out=[Path , filesep , File , '_seg_sn.mat'];
                        MatName={[Path , filesep , File , '_seg_sn.mat']};
                    end
                    %Normalize
                    SPMJOB=load([GUIPath , filesep ,...
                        'Jobsman' , filesep , 'gretna_Normalization_write.mat']);
                    if isempty(MatName)    
                        MatName=GetNeedFile(Para.T1Path , Para.MatSuffix , FieldName(6:end));
                    end    
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.subj.matname=MatName;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.subj.resample=FileList;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.bb=BB;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.vox=VoxelSize;
                    SPMJOB.matlabbatch{1,1}.spm.spatial.normalise.write.roptions.prefix='w';
                    command='spm_jobman(''run'',opt.NormalizeT1Batch)';
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).command=command;
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).opt.NormalizeT1Batch=SPMJOB.matlabbatch;
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).files_in=[files_in ; MatName];
                    pipeline.([FieldName , DelMsg , '_NormalizeT1']).files_out=files_out;
                    if ~isempty(DelMsg)
                        DelMsg=[];
                    end
                end
                %command='gretna_PicForCheck(opt.FileList , opt.PicDir , opt.SubjName)';
                %pipeline([FieldName , '_CheckNormalize']).command=command;
                %pipeline([FieldName , '_CheckNormalize']).opt.FileList=files_out;
                %pipeline([FieldName , '_CheckNormalize']).opt.PicDir=Para.PicDir;
                %pipeline([FieldName , '_CheckNormalize']).opt.SubjName=FieldName(6:end);
                %pipeline([FieldName , '_CheckNormalize']).files_in=files_out;
                %pipeline([FieldName , '_CheckNormalize']).files_out=[Para.PicDir , filesep , FieldName(6:end) , '.tif'];
            case 'SMOOTH'
                SPMJOB=load([GUIPath , filesep ,...
                    'Jobsman' , filesep , 'gretna_Smooth.mat']);
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('s' , DataFile , TimePoint);
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.fwhm=FWHM;
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.data=FileList;
                SPMJOB.matlabbatch{1,1}.spm.spatial.smooth.prefix='s';
                command='spm_jobman(''run'',opt.SmoothBatch)';
                pipeline.([FieldName , DelMsg , '_Smooth']).command=command;
                pipeline.([FieldName , DelMsg , '_Smooth']).opt.SmoothBatch=SPMJOB.matlabbatch;
                pipeline.([FieldName , DelMsg , '_Smooth']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Smooth']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'DETREND'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('d' , DataFile , TimePoint);
                command='gretna_detrend(opt.FileList , opt.Prefix , opt.DetrendOrd , opt.RemainMean)';
                pipeline.([FieldName , DelMsg , '_Detrend']).command=command;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.Prefix='d';
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.DetrendOrd=Para.DetrendOrd;
                pipeline.([FieldName , DelMsg , '_Detrend']).opt.RemainMean=Para.RemainMean;
                pipeline.([FieldName , DelMsg , '_Detrend']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Detrend']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'FILTER'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('b' , DataFile , TimePoint);
                command='gretna_bandpass(opt.FileList , opt.Prefix , opt.Band , opt.TR)';
                pipeline.([FieldName , DelMsg , '_BandPass']).command=command;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.Prefix='b';
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.Band=FreBand;
                pipeline.([FieldName , DelMsg , '_BandPass']).opt.TR=Para.TR;
                pipeline.([FieldName , DelMsg , '_BandPass']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_BandPass']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
            case 'COVARIATES REGRESSION'    
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('c' , DataFile , TimePoint);
                %Cov
                CovCell=[];
                if strcmpi(Para.GSBool , 'TRUE')
                    CovCell=[CovCell ; {Para.GSMask}];
                end
                if strcmpi(Para.WMBool , 'TRUE')
                    CovCell=[CovCell ; {Para.WMMask}];
                end
                if strcmpi(Para.CSFBool, 'TRUE')
                    CovCell=[CovCell ; {Para.CSFMask}];
                end

                if strcmpi(Para.HMBool , 'TRUE')
                    if isempty(Para.HMPath) || ~(exist(Para.HMPath , 'dir')==7)
                        Para.HMPath=Para.EPIPath;
                    end
                end
                Config.BrainMask = Para.GSMask;
                Config.HMBool    = Para.HMBool;
                Config.HMPath    = Para.HMPath;
                Config.HMPrefix  = Para.HMPrefix;
                Config.HMDeriv   = Para.HMDerivBool;
                Config.Name      = FieldName(6:end);
                Config.CovCell   = CovCell;
                command='gretna_regressout(opt.FileList , opt.Prefix , opt.CovConfig)';
                pipeline.([FieldName , DelMsg , '_Regressout']).command=command;
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.Prefix='c';
                pipeline.([FieldName , DelMsg , '_Regressout']).opt.CovConfig=Config;
                pipeline.([FieldName , DelMsg , '_Regressout']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_Regressout']).files_out=files_out;
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
                
            case 'VOXEL-BASED DEGREE'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('' , DataFile , TimePoint);
                %Voxel-based Degree
                DCDir=[Para.ParentDir , 'GretnaVoxelDegree'];
                if ~(exist(DCDir , 'dir')==7)
                    mkdir(DCDir);
                end
                DCOutput=[DCDir , filesep , FieldName(6:end)];
                command='gretna_voxel_based_degree_pipeuse(opt.FileList, opt.DCOutput, opt.DCMask, opt.DCRthr, opt.DCDis, opt.SubjName)';
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).command=command;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCOutput=DCOutput;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCMask=Para.DCMask;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCRthr=Para.DCRthr;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.DCDis=Para.DCDis;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).opt.SubjName=FieldName(6:end);
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_VoxelDegree']).files_out=...
                    {[DCOutput, filesep, 'degree_abs_wei_', FieldName(6:end), '.nii']};
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
                
            case 'FUNCTIONAL CONNECTIVITY MATRIX'
                [FileList , files_in , files_out , DataFile]=...
                    UpdateDataList('' , DataFile , TimePoint);
                %FC
                MatOutput=[Para.ParentDir , 'GretnaMatrixResult'];
                if ~(exist(MatOutput , 'dir')==7)
                    mkdir(MatOutput);
                end
                OutputName=[MatOutput , filesep ,  FieldName(6:end) , '.txt'];
                command='gretna_fc(opt.FileList , opt.LabMask , opt.OutputName)';
                pipeline.([FieldName , DelMsg , '_FC']).command=command;
                pipeline.([FieldName , DelMsg , '_FC']).opt.FileList=FileList;
                pipeline.([FieldName , DelMsg , '_FC']).opt.LabMask=Para.LabMask;
                pipeline.([FieldName , DelMsg , '_FC']).opt.OutputName=OutputName;
                pipeline.([FieldName , DelMsg , '_FC']).files_in=files_in;
                pipeline.([FieldName , DelMsg , '_FC']).files_out={OutputName};
                if ~isempty(DelMsg)
                    DelMsg=[];
                end
        end
    end