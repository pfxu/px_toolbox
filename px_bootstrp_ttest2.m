function [P] = px_bootstrp_ttest2(nboot,x,y)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT [P] = px_bootstrp_ttest2(nboot,x,y)
% 
%  Usage This function used to draw NBOOT bootstrap data samples, computes 
%        the difference between two small samples using ttest2 function,
%        and returns the probability of finding the observed difference
%        between two groups.
%  Input
%       nboot - must be a positive integer.
%       x     - dataset of x, must be a vector.
%       y     - dataset of x, must be a vector.
%  Output
%       P - probability of finding the observed difference by randomly
%           selecting a subject and a group from the population.
%
%  Reference: Hasson U, et al. (2003) Face-selective activation in a 
%             congenital prosopagnosic subject.J Cogn Neurosci.
%             15(3):419-31.
% Pengfei Xu, 03/20/2014,@QCCUNY
% =========================================================================
if nboot<=0 || nboot~=round(nboot)
    error('NBOOT must be a positive integer.')
end
if all(size(x)>=2);
    error('X must be a vector.');
end
if all(size(y)>=2);
    error('Y must be a vector.');
end


[~,~,~,stats] = ttest2(x,y,0.05,'both','unequal');
t_real = stats.tstat;
t_rand = px_sample(nboot,x,y);

% % % check NaN and InF value
% % nans   = isnan(t_rand);
% % t_rand = t_rand(~nans);
% % infs   = isinf(t_rand);
% % t_rand = t_rand(~infs);

% cumulative frequency distribution
if t_real < 0
    P = normcdf(t_real,mean(t_rand),std(t_rand));
else
    P = 1-normcdf(t_real,mean(t_rand),std(t_rand));
end

function [data_sample] = px_sample(nboot,x,y)

nx = length(x);
ny = length(y);
nsample = nx + ny;

data_sample = zeros(nboot,1);

xsample = zeros(nx,1);
ysample = zeros(ny,1);

%Randomly select sample with replacement
m = 0;
for n = 1: nboot
    for i = 1: nx
        R = randperm(nsample);
        xsample(i) = R(1);
    end
    
    for i = 1: ny        
        R = randperm(nsample);
        ysample(i) = R(1);
    end    
    [~,~,~,stats]  = ttest2(xsample,ysample,0.05,'both','unequal');
    % Check NaN and InF value
    if isnan(stats.tstat) || isinf(stats.tstat)
        nboot = nboot+ 1;
    else
        m = m + 1;
        data_sample(m) = stats.tstat;
    end
end