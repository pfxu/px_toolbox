function [ y ] = px_errorwithinsub(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to normalize the standard error in within-subject
% design,just for the error bar plot.
% FORAMT:
%        [ y ] = px_errorwithinsub(x)
% Input: 
%        x - is a [m x n] dimensional matrix for multidimensional observed
%        values. One variable in one column.
% Output:
%        y - is a [m x n] dimensional matrix whose dimensions match those 
%        of x.
% Reference:
%        1. http://www.cogsci.nl/blog/tutorials/156-an-easy-way-to-create-g
%        raphs-with-within-subject-error-bars
%        2. Cousineau,D.(2005)Tutorial in Quantitative Methods for
%        Psychology
%        3. Morey,R.D.(2008)Tutorial in Quantitative Methods for Psychology
% 
% Pengfei Xu, 10/09/2012, @BNU
% ========================================================================
ns = size(x,1); % number of subject
nv = size(x,2); % number of variable
ms = mean(x,2); % mean value of each subject
mg = mean(ms);  % grand mean
y = zeros(ns,nv);
for s = 1:ns
    for v = 1: nv
        y(s,v) = x(s,v) - ms(s) + mg;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%