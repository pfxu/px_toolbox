function px_spm8_report_aalba(xSPM, hReg,Num,Dis)
% FORMAT px_spm8_report_aalba(xSPM, hReg,Num,Dis)
% Usage  After results have been estimated and the glass brains are displayed in
% the Graphics window.
% Input  Defulat Num = 20, Dis = 16;
% NOTE: This has been written for spm5.
%       Updated to spm8 revised by pengfei xu,11/18/2011;
%      
% Extract all voxels from the SPM table of results and find the AAL and
% Brodmann Labels for them. Then write out most of the SPM results table
% and the AAL and BA labels to a tab-delimited text file.
%
% Note you will need to change the locations for MRICro which are hardcoded
% below.
%
% filename: FindAALandBAForSPMResults.m
% written by: Jason Steffener
% Date: 4/17/08
% Revised by Xun Liu, PhD
% Revised by Pengfei Xu for SPM8 at Queens College
%
% Once SPM results are run this program will work
% The table of results is extracted
% TabDat = spm_list('List', xSPM, hReg);
%==========================================================================
if nargin == 2; Num = 20;Dis = 16;end %Num = inf 
TabDat = spm_list('List',xSPM,hReg,Num,Dis); %%%revised by pengfei xu,11/29/2011, for extended clusters;
% TabDat = spm_list('ListCluster',xSPM,hReg,inf,Dis)
% The tabular data is broken into different arrays
NClust = size(TabDat.dat,1);
XYZmm = zeros(NClust,3);
TList = zeros(NClust,1);
ZList = zeros(NClust,1);
pList = zeros(NClust,1);
ClList = zeros(NClust,1);
for i = 1:NClust
    XYZmm(i,:) = TabDat.dat{i,end}(:)';
    %     TList(i,1) = TabDat.dat{i,8};
    %     ZList(i,1) = TabDat.dat{i,9};
    %     pList(i,1) = TabDat.dat{i,10};
    %     tempCl = TabDat.dat{i,4};
    TList(i,1) = TabDat.dat{i,9};  %%%revised by pengfei xu,11/18/2011, for spm8;
    ZList(i,1) = TabDat.dat{i,10}; %%%revised by pengfei xu,11/18/2011, for spm8;
    pList(i,1) = TabDat.dat{i,11}; %%%revised by pengfei xu,11/18/2011, for spm8;
    tempCl = TabDat.dat{i,5};      %%%revised by pengfei xu,11/18/2011, for spm8;
    
    if ~isempty(tempCl)
        ClList(i,1) = tempCl;
    end
end
% This program finds the AAL and Brodmann Area labels for all XYZ mm
% coordinates it is passed.
[AALList BAList] = subfnFindAALandBA(XYZmm);
% Create an informative output file name
OutPutFileName = [xSPM.title '_Teq' num2str(xSPM.u)];
OutPutFileName(findstr(OutPutFileName, ' ')) = '';
OutPutFileName(findstr(OutPutFileName, ':')) = '';
OutPutFileName(findstr(OutPutFileName, '.')) = 'p';
OutPutFileName(findstr(OutPutFileName, '(')) = '';
OutPutFileName(findstr(OutPutFileName, ')')) = '';
OutPutFileName(findstr(OutPutFileName, '<')) = 'l';
OutPutFileName(findstr(OutPutFileName, '>')) = 'g';
OutPutFileName = [OutPutFileName '_AALandBA.txt'];
OutPutFile = fullfile(xSPM.swd,[OutPutFileName]);
fid = fopen(OutPutFile, 'w');
% Write all data to file
fprintf(fid,'Region\tLat\tBrodmann Area\tx\ty\tz\tT\tZ\tp\tk\n');
for i = 1:NClust
    fprintf(fid,'%s\t%s\t%d\t',AALList{i}(1:end-2), AALList{i}(end),BAList(i));
    fprintf(fid,'%d\t%d\t%d\t',XYZmm(i,:));
    fprintf(fid,'%0.2f\t%0.2f\t%0.3f\t%d\n',TList(i,1),ZList(i,1),pList(i,1),ClList(i,1));
end
fclose(fid);
fprintf('Data saved to:\n\t%s\n',OutPutFile);

%% export setup                                %%%Added by pengfei xu,12/8/2011
% c = 1;
ExportSetupFile = fullfile(xSPM.swd,[OutPutFileName '_Setup.txt']);
fid = fopen(ExportSetupFile, 'w');
fprintf(fid,'\n\nSTATISTICS: %s\n',TabDat.tit);
fprintf(fid,'%c',repmat('=',1,80)); fprintf(fid,'\n');
%Revised the following print by Pengfei Xu,12/29/2012
% 
% %-Table header
% %------------------------------------------------------------------
% fprintf(fid,'%s\t',TabDat.hdr{1,c:end-1}); fprintf(fid,'%s\n',TabDat.hdr{1,end});
% fprintf(fid,'%s\t',TabDat.hdr{2,c:end-1}); fprintf(fid,'%s\n',TabDat.hdr{2,end});
% fprintf(fid,'%c',repmat('-',1,80)); fprintf(fid,'\n');
% 
% %-Table data
% %------------------------------------------------------------------
% for i = 1:size(TabDat.dat,1)
%     for j=c:size(TabDat.dat,2)
%         fprintf(fid,TabDat.fmt{j},TabDat.dat{i,j});
%         fprintf(fid,'\t');
%     end
%     fprintf(fid,'\n');
% end
% for i=1:max(1,12-size(TabDat.dat,1)), fprintf(fid,'\n'); end
fprintf(fid,'%s\n',TabDat.str);
fprintf(fid,'%c',repmat('-',1,80)); fprintf(fid,'\n');

%-Table footer
%------------------------------------------------------------------
% fprintf(fid,'%s\n',TabDat.ftr{:});
for l = 1: size(TabDat.ftr,1)
    fprintf(fid,[TabDat.ftr{l,1},'\n'],TabDat.ftr{l,2});%Revised print by Pengfei Xu,12/29/2012
end
fprintf(fid,'%c',repmat('=',1,80)); fprintf(fid,'\n\n');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AALList BAList] = subfnFindAALandBA(XYZmm)
% This takes an array of XYZ coordinates in millimeters and finds the AAL
% and BA labels for them. Using mm coordinates they are converted to the
% voxel space of teh AAL and BA maps regardless of differing image sizes.
%
% filename: FindAALandBAForSPMResults.m
% written by: Jason Steffener
% Date: 4/17/08
%
%%%%% Load Template %%%%%%%%%%%%%%%%%%%%%%%%
pathtemplate = fullfile(px_toolbox_root,'templates','aal_ba');
imgaal = fullfile(pathtemplate,'px_aal.img');
txtaal = fullfile(pathtemplate,'px_aal.txt');
[aalCol1 aalCol2 aalCol3] = textread(txtaal','%d%s%d');
imgba = fullfile(pathtemplate,'px_brodmann.img');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Vba = spm_vol(imgba);
Vaal = spm_vol(imgaal);
Iaal = spm_read_vols(Vaal);
Iaal = round(Iaal); %Added by pengfei xu,for the decimals coordinate,08/04/2012;
Iba = spm_read_vols(Vba);
Iba = round(Iba); %Added by pengfei xu,for the decimals coordinate,08/04/2012;
% Account for differing image sizes and flip the images
VMat = Vaal.mat;
VMat(1,1) = -VMat(1,1);
VMat(1,4) = -VMat(1,4);
% NVoxels = length(XYZmm);
NVoxels = size(XYZmm,1);% Revised length with size by Pengfei Xu,10/04/2012
AALList = {};
BAList = zeros(NVoxels,1);
for i = 1:NVoxels
    CurrentMMLoc = XYZmm(i,:)';
    CurrentAALLoc = inv(VMat)*[CurrentMMLoc; 1];
    CurrentAALLoc = round(CurrentAALLoc);%Revised by PX 01/04/2014 for index must be a positive integer or logical.
    CurrentValue = Iaal(CurrentAALLoc(1), CurrentAALLoc(2), CurrentAALLoc(3));
    BAList(i,1) = Iba(CurrentAALLoc(1), CurrentAALLoc(2), CurrentAALLoc(3));
    if CurrentValue
        AALList{i} = aalCol2{CurrentValue};
    else
        AALList{i} = '**empty**';
    end
end
%(null)