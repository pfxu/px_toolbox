function [cell_list, sts] = px_ls(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT  px_ls % px_ls('Reg',ip,'-F',1,'.img') || px_ls('Rec',ip,'-F','.img')
%  FORMAT  [cell_list sts] = px_ls('Reg',ip,ft,pt,fn)
%     Usage   List the directories or files under the input path.
%     Output
%        cell_list    Output list of the searched directories or files.
%     Input
%        path  - input full path of will-be-searching folder.
%        ft    - file type be serached.
%                '-T', list all the files under the path;
%                '-D', list the directory under the path;
%                '-F', list the non-directory file under the path.<DEFAULT>
%        pt    - path type for output.
%                0, only list the file name;
%                1, list the full path and the file name.         <DEFAULT>
%        fn    - the filt name of the file, e.g., '.img', see reg_exp for details.
%                '    ^     start of string',...
%                '    $     end of string',...
%                '    .     any character',...
%                '    \     quote next character',...
%                '    *     match zero or more',...
%                '    +     match one or more',...
%                '    ?     match zero or one, or match minimally',...
%                '    {}    match a range of occurrances',...
%                '    []    set of characters',...
%                '    [^]   exclude a set of characters',...
%                '    ()    group subexpression',...
%                '    \w    match word [a-z_A-Z0-9]',...
%                '    \W    not a word [^a-z_A-Z0-9]',...
%                '    \d    match digit [0-9]',...
%                '    \D    not a digit [^0-9]',...
%                '    \s    match white space [ \t\r\n\f]',...
%                '    \S    not a white space [^ \t\r\n\f]',...
%                '    \<WORD\>    exact word match',...
%  FORMAT   [cell_list sts] = px_ls('Rec',ip,ft,fn)
%     Usage:   Recurse list the directories or files, that include the
%     sepcial characters under the inuput path.
%     Input:
%       ip  - input full path of will-be-searching folder
%       ft  - file type be serached.
%             '-D' Recurse search the directories (both directories
%                  including nondirectories files and empty directories).
%                  That is:
%                  1.The directory including both sub-directory and non-
%                  directory files will be listed;
%                  2.The empty directory will be list;
%                  3.The directory which including sub-directory only
%                  without non-directory files will NOT be listed.
%             '-F' Recurse search the files.                      <DEFAULT>
%       fn  - user-specified characters of the directories or pathes for
%       search.
%     Output:
%       cell_list - paths of the directories or files named user-specified
%       characters.
%       sts      - state of the cell_list;
%          1     - true;
%          0     - false(empty);
%
% Copyright 2013-2013 Pengfei Xu Beijing Normal University
% Revision: 3.0 Date: 2014/01/31 00:00:00
% 2.0 update: Merge the regular list and the recurse list into one function.
% 3.0 update: add regexp to filt file name
%==========================================================================

%Check input
if nargin > 5;error('Too many input arguments.');end
if nargin == 0;
    ip = pwd; ft = '-F'; pt = 1; fn = '\w*';
    [cell_list, sts] = px_ls('Reg',ip,ft,pt,fn);
    return
end
if ~exist(varargin{2},'dir');error('Directory %s is not exist.',varargin{2});end

sts = true;
switch lower((varargin{1}))
    case 'reg'
        if nargin == 2; varargin{3} = '-F'; varargin{4} = 1; varargin{5} = '\w*';end
        if nargin == 3; varargin{4} = 1; varargin{5} = '\w*';end
        if nargin == 4; varargin{5} = '\w*';end
        if ~isnumeric(varargin{4})
            error('Please check the path type (pt), which should either be 0 or 1.');
        end
        ip = varargin{2};
        ft = upper(varargin{3});
        pt = varargin{4};
        fn = varargin{5};
        cell_list = cell(0,1);
        % Revised by PX, 1/31/2014,filt file by regexp
        file_struct   = dir(ip);
        name_list_all = cellstr(char(file_struct.name));
        ind_cell      = regexp(name_list_all,fn);%% Using fn to filt and exclude the '.' and '..' as well.
        ind           = ~cellfun(@isempty,ind_cell);
        name_list     = name_list_all(ind);
        %
        j = 0;
        for i = 1: numel(name_list)
            if ~strcmpi(name_list(i),'.DS_Store')
                % && ~strcmpi(name_list(i),'.') ...
                % && ~strcmpi(name_list(i),'..') ...
                
                if strcmp(ft, '-T') %%default
                    j = j+1;
                elseif  strcmp(ft, '-D')
                    if isdir(fullfile(ip, char(name_list(i))))
                        j = j+1;
                    else %% exclude the nondir for the following SWITCH
                        continue
                    end
                elseif strcmp(ft, '-F')
                    if ~isdir(fullfile(ip, char(name_list(i))))
                        j = j+1;
                    else %% exclude the dir for the following SWITCH
                        continue
                    end
                end
                switch pt
                    case 0
                        cell_list{j,1} = name_list{i};
                    case 1
                        cell_list{j,1} = fullfile(ip, char(name_list(i)));
                end
            end
        end
        if isempty(cell_list);
            sts = false;
        end
    case 'rec'
        if nargin > 4;error('Too many input arguments.');end
        if nargin == 1; varargin{2} = pwd; varargin{3} = '-F'; end
        if nargin == 2; varargin{3} = '-F'; end
        ip = varargin{2};
        if isnumeric(varargin{3});
            error(['Check the input, there is no option',' '' ',...
                num2str(varargin{3}), ' '' ', 'for Recurse List.']);
        end
        ft = upper(varargin{3});
        if nargin == 4; fn = varargin{4}; end
        % list input directory
        file_list = dir(ip);
        nfiles    = size(struct2cell(file_list),2);
        dir_list  = {};
        path_list = {};
        % If the directory is empty(only '.','..','.DS_Store'), add it to path_liat/cell_list.
        if (nfiles == 2 && strcmpi(file_list(1).name,'.') )...
                || (nfiles == 2 && strcmpi(file_list(3).name,'.DS_Store'));
            path_list = {ip};
        end
        for i = 1:nfiles
            if ~strcmpi(file_list(i).name,'.') ...
                    && ~strcmpi(file_list(i).name,'..') ...
                    && ~strcmpi(file_list(i).name,'.DS_Store')
                sub_file_list = fullfile(ip,char(file_list(i).name));
                if file_list(i).isdir
                    dir_list = [dir_list; sub_file_list];
                else
                    if strcmp(ft,'-D')
                        if nargin < 4 ; %% nargin is 1 or 2 or 3
                            path_list = {ip};
                        elseif nargin == 4 ;
                            % Revised by PX, 1/31/2014,filt file by regexp
                            [pathstr, pathname] = fileparts(ip);
                            if  regexp(pathname,fn);
                                %
                                path_list = {ip};
                            end
                        end
                    elseif strcmp(ft,'-F')
                        if nargin < 4 ;
                            path_list = [path_list;sub_file_list];
                        elseif nargin == 4 ;
                            % Revised by PX, 1/31/2014,filt file by regexp
                            if  regexp(char(file_list(i).name),fn);
                                %
                                path_list = [path_list;sub_file_list];
                            end
                        end
                    end
                end
            end
        end
        cell_list = path_list;
        % recurse into sub directories
        for j = 1:size(dir_list,1)
            if nargin < 4 ; %% nargin is 1 or 2 or 3
                out = px_ls('Rec',dir_list{j},ft);
            elseif nargin == 4 ;
                out = px_ls('Rec',dir_list{j},ft,fn);
            end
            cell_list = [cell_list; out];
        end
        if isempty(cell_list);sts = false;else sts = true;end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%