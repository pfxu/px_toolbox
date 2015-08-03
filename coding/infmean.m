function m = infmean(x,dim)
%infMEAN Mean value, ignoring infs.
%   M = infMEAN(X) returns the sample mean of X, treating infs as missing
%   values.  For vector input, M is the mean value of the non-inf elements
%   in X.  For matrix input, M is a row vector containing the mean value of
%   non-inf elements in each column.  For N-D arrays, infMEAN operates
%   along the first non-singleton dimension.
%
%   infMEAN(X,DIM) takes the mean along dimension DIM of X.
%
%   See also MEAN, infMEDIAN, infSTD, infVAR, infMIN, infMAX, infSUM.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:15:50 $

% Find infs and set them to zero
infs = isinf(x);
x(infs) = 0;

if nargin == 1 % let sum deal with figuring out which dimension to use
    % Count up non-infs.
    n = sum(~infs);
    n(n==0) = inf; % prevent divideByZero warnings
    % Sum up non-infs, and divide by the number of non-infs.
    m = sum(x) ./ n;
else
    % Count up non-infs.
    n = sum(~infs,dim);
    n(n==0) = inf; % prevent divideByZero warnings
    % Sum up non-infs, and divide by the number of non-NaNs.
    m = sum(x,dim) ./ n;
end

