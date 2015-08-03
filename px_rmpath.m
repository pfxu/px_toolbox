function varargout = px_rmpath(d)  
% see spm_rmpath

varargout = {};
if ~nargin
    % Get the actual SPM directory
    try d = px_toolbox_root;
    catch, return; end
end

% Recursively remove directories in the MATLAB path
p = textscan(path,'%s','delimiter',pathsep); p = p{1};
i = strncmp(d,p,length(d)); P = p(i); p(i) = [];
if ~nargin && ~isempty(P)
    fprintf('Removed px_toolbox paths starting from base path: "%s"\n',d);
elseif ~isempty(P)
    fprintf('Removed paths starting from base path: "%s" from:\n',d);
else
    fprintf('No matching path strings found to remove\n')
end
if numel(P), fprintf('\t%s\n',P{:}); end

% Set the new MATLAB path
p = strcat(p,pathsep);
path(strcat(p{:}));

% Return the cleaned path if requested
if nargout
    varargout{1} = p;
end
