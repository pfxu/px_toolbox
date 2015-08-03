function px_rename(ip,expr,repstr,kind,id)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT  px_rename(ip,expr,repstr,kind,id)
%  Usage re-name the file or directory
%  Input 
%    ip     - input path
%    expr   - expression, see regexp for details. e.g., '^s.*\.img$'
%    repstr - str to replace the original one
%    kind   - kind of the file to rename
%              - '-F', rename the name of files
%              - '-D', rename the name of directories/folders
%    id     - index of the file to be renamed in the folder, which can get
%             from px_ls_num <defualt, all files met expression>
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2013/12/11 00:00:00
%==========================================================================

cwd = pwd;
cd(ip);
fprintf('     \nChanging directory to: %s\n', ip);
strlist = px_ls('Reg',ip,kind,0);
if nargin == 4; id = 1: length(strlist);end
for s = id 
    if regexp(strlist{s}, expr);
    dirname = regexprep(strlist{s}, expr, repstr);
    movefile(strlist{s},dirname);
    fprintf('     \nRename file %s to %s.', strlist{s},dirname);
    end
end
cd(cwd);
fprintf('     \n\nChanging back to directory: %s\n', cwd);