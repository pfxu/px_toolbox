function px_gen_path(ip,in,op,on,flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Format px_gen_path(ip,in,op,on,flag)
% Usegae generate the path of the file or the directories with the 
% user-specified name.
% Input
% ip - input path
% in - input user-specified
% op - output path for the generated path in txt format.
% on - output name for the generated path in txt format.
% flag
%      RegF/RegD - generate the path of the files/directories under the 
% input path.
%      RecF/RecD - generate the path of all the files/directories in the 
% folders and subfolders under the input path.
%
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2013/1/23 00:00:00
%==========================================================================
if nargin == 4; flag = 'RegF'; end
switch lower(flag)
    case 'regf'
        celllist = px_ls('Reg',ip,'-F',1,in);
    case 'regd'
        celllist = px_ls('Reg',ip,'-D',1,in);
    case 'recf'
        celllist = px_ls('Rec',ip,'-F',in);
    case 'recd'
        celllist = px_ls('Rec',ip,'-D',in);
end
px_text(op,on,celllist,'cell')