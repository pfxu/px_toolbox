function [path] = px_toolbox_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FORMAT function [path] = px_toolbox_root
%   Root directory of px_toolbox installation.
%   p = px_toolbox_root returns a string that is the name of the directory
%   where the px_toolbox is installed.
%
%   px_toolbox_root is used to produce platform dependent paths
%   to the various px_toolbox_root directories.
% 
%   Copyright 2012-2012  Pengfei Xu @BNU.
%   $Revision: 1.0 $  $Date: 2012/07/26 00:00:00 $
% =========================================================================
path = which('px_toolbox_root.m');% path = fileparts(path);
i    = find(path == filesep);
path = path(1:i(end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%