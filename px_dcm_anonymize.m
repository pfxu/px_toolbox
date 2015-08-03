function px_dcm_anonymize(fdp,para)
% FORMAT px_dcm_anonymize(ip,para.op,para.subid,para.dcmtype)
%   Input:
%     fdp.dcm      - input path of DICOM files;
%     para.op      - output path to store the processed dir;
%     para.NIDs    - the New ID of the DICOM files;
%     para.dcmtype - The File name surfix of the DICOM files. e.g. IMA, dcm or none.
%   Output:
%     *.IMA/*.dcm  - DICOM images without private information
%   Note:*****
%      A lot of information of DICOM file after anonymized (by dicominfo and 
%      dicomwrite) were lost, when use the spm_dicom_headers to read it for  
%      subsequently spm_dicom_convert. e.g., 'CSAImageHeaderInfo',
%      'Private...'. I don't do this when I use spm to convert dicom data.
%      Try to fix it by checking the dicominfo, dicomwrite ....
%__________________________________________________________________________
%  Pengfei Xu, 09042013, @QCCUNY, Revised from rest_ChangeDicomInfo.
%==========================================================================
if ~exist(para.op,'dir');mkdir(para.op);end
for p = 1:numel(fdp.dcm)
    info = dicominfo(fdp.dcm{p});
    I = dicomread(info);
    Indexp = ['0000000',num2str(p)];
    Indexp = Indexp(end-6:end);
    info.Filename = [Indexp,'.',para.dcmtype];
    info.PatientName.FamilyName = para.NIDs;
    info.PatientID = para.sname;
    info.PatientBirthDate = '';
    dicomwrite(I,[para.op,filesep,info.Filename],info, 'createmode', 'copy');
    fprintf(1,'.');
end
fprintf(1,'.\n Dicom Information have been anonymized.\n')