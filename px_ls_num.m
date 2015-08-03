function [nlist,number,filelist] = px_ls_num(varargin)
% FORMAT [nlist,number,filelist] = px_ls_number(varargin)% 
%   Usage This function is used to list the number of each file.
%   Input see px_ls for details. 
%   Output
%     nlist    - number and the filelist
%     number   - number only
%     filelist - filelist only
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2012/5/18 00:00:00
%==========================================================================
filelist = px_ls(varargin{:});
nlist    = cell(length(filelist),1);
number   = zeros(length(filelist),1);
for i = 1: length(filelist)
    num       = num2str(i);
    nlist{i}  = cat(2,num,',', filelist{i});
    number(i) = i;
end

