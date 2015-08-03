function y = px_sem(varargin)
% SEM Standard error of the mean.
%   For vectors, Y = px_sem(X) returns the sem of the values in X.  For
%   matrices, Y is a row vector containing the variance of each column of
%   X.  For N-D arrays, px_sem operates along the first non-singleton
%   dimension of X.
% y = sqrt(var(varargin{:}))/sqrt(length(varargin));
% y = sqrt(var(varargin{:}))/sqrt(length(varargin{:}));
% 
% For vectors, y = px_sem(x) returns the standard error of the mean.
% 
% See also std.

if size(varargin{:},1) == 1;
    warning('Sample size == 1, sem == std.\n');
end
y=sqrt(var(varargin{:}))/sqrt(size(varargin{:},1));