function px_dcm2nii(in,op,type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FORMAT px_dcm2nii(in,op,type)
% 
%      in    input dcm file name, e.g. in = '/Volume/DataRaw/Sub001/dcm0001.dcm';
%      op    output dcm path, e.g. op = '/Volume/DataImg/Sub001';
%      type 
%            - img hdr/img files
%            - nii .nii file
% 
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2013/03/01 00:00:00
%==========================================================================
if ~exist(op,'dir');mkdir(op);end
tpath = fullfile(px_toolbox_root,'dcm2nii');
% dcm = px_ls('Reg',in,'-F',1);

if strcmpi(type,'img')
    option = ' -o ';
elseif strcmpi(type,'nii')
    option = ' -r N -n Y -g Y -o ';
    % -r Y will generate the 'o...' and 'co..' file. 
end

if ispc
    cmd = [fullfile(tpath,'dcm2nii.exe'),[' -b ' fullfile(tpath,'dcm2nii.ini')],option,op,' ',in];
elseif ismac
    cmd = [fullfile(tpath,'./dcm2nii_mac'),[' -b ' fullfile(tpath,'./dcm2nii_linux.ini')],option,op,' ',in];
else
    cmd = [fullfile(tpath,'./dcm2nii_linux'),[' -b ' fullfile(tpath,'./dcm2nii_linux.ini')],option,op,' ',in];
end
disp(cmd);
system(cmd);