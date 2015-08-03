function [param,stat,h]=px_fit_sigm(x,y,fixed_params,initial_params,plot_flag)
% Optimization of parameters of the sigmoid function
%
% Syntax:
%       [param]=px_fit_sigm(x,y)       
%
%       that is the same that
%       [param]=px_fit_sigm(x,y,[],[],[])     % no fixed_params, automatic initial_params
%
%       [param]=px_fit_sigm(x,y,fixed_params)        % automatic initial_params
%       [param]=px_fit_sigm(x,y,[],initial_params)   % use it when the estimation is poor
%       [param]=px_fit_sigm(x,y,fixed_params,initial_params,plot_flag)
%
% param = [min, max, x50, slope]
%
% if fixed_params=[NaN, NaN , NaN , NaN]        % or fixed_params=[]
% optimization of "min", "max", "x50" and "slope" (default)
%
% if fixed_params=[0, 1 , NaN , NaN]
% optimization of x50 and slope of a sigmoid of ranging from 0 to 1
%
%
% Additional information in the second output, STAT
% [param,stat]=px_fit_sigm(x,y,fixed_params,initial_params,plot_flag)
%
%
% Example:
% %% generate data vectors (x and y)
% ORIGINIAL: fsigm = @(param,xval) param(1)+(param(2)-param(1))./(1+10.^((param(3)-xval)*param(4)))
% REVISED:  fsigm = @(param,xval) param(1)+(param(2)-param(1))./(1+exp((param(3)-xval)*param(4)))
% param=[0 1 5 1];  % "min", "max", "x50", "slope"
% x=0:0.1:10;
% y=fsigm(param,x) + 0.1*randn(size(x));
%
% %% standard parameter estimation
% [estimated_params]=px_fit_sigm(x,y)
%
% %% parameter estimation with forced 0.5 fixed min
% [estimated_params]=px_fit_sigm(x,y,[0.5 NaN NaN NaN])
%
% %% parameter estimation without plotting
% [estimated_params]=px_fit_sigm(x,y,[],[],0)
%
%
% Doubts, bugs: rpavao@gmail.com
% Downloaded from http://www.mathworks.com/matlabcentral/fileexchange/42641-sigmoid-logistic-curve-fit

% warning off

x=x(:);
y=y(:);

if nargin<=1 %fail
    fprintf('');
    help px_fit_sigm
    return
end

automatic_initial_params=[quantile(y,0.05) quantile(y,0.95) NaN 1];
if sum(y==quantile(y,0.5))==0
    temp=x(y==quantile(y(2:end),0.5));    
else
    temp=x(y==quantile(y,0.5));
end
automatic_initial_params(3)=temp(1);

if nargin==2 %simplest valid input
    fixed_params=NaN(1,4);
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==3
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==4
    plot_flag=1;    
end

if exist('fixed_params','var')
    if isempty(fixed_params)
        fixed_params=NaN(1,4);
    end
end
if exist('initial_params','var')
    if isempty(initial_params)
        initial_params=automatic_initial_params;
    end
end
if exist('plot_flag','var')
    if isempty(plot_flag)
        plot_flag=1;
    end
end

%p(1)=min; p(2)=max-min; p(3)=x50; p(4)=slope como em Y=Bottom + (Top-Bottom)/(1+10^((LogEC50-X)*HillSlope))
%f = @(p,x) p(1) + (p(2)-p(1)) ./ (1 + 10.^((p(3)-x)*p(4)));

f_str='f = @(param,xval)';
free_param_count=0;
bool_vec=NaN(1,4);
for i=1:4;
    if isnan(fixed_params(i))
        free_param_count=free_param_count+1;
        f_str=[f_str ' param(' num2str(free_param_count) ')'];
        bool_vec(i)=1;
    else
        f_str=[f_str ' ' num2str(fixed_params(i))];
        bool_vec(i)=0;
    end
    if i==1; f_str=[f_str ' + (']; end
    if i==2;
        if isnan(fixed_params(1))            
            f_str=[f_str '-param(1) )./ (   1 + exp( (']; 
        else
            f_str=[f_str '-' num2str(fixed_params(1)) ')./ (1 + exp((']; 
        end
    end    
    if i==3; f_str=[f_str ' - xval ) *']; end
    if i==4; f_str=[f_str ' )   );']; end
end

eval(f_str)

% [BETA,RESID,J,COVB,MSE] = nlinfit(x,y,f,initial_params(bool_vec==1));

initials = initial_params(bool_vec==1);
range = -15:15;
n = 0;
while n == 0;
    [BETA,RESID,J,COVB,MSE] = nlinfit(x,y,f,initials);
    if BETA(3) > -15 && BETA(3) < 15 && BETA(4) > 0
        n = 1;
    end
    r = unidrnd(length(range));
    initials(3) = range(r);
    initials(4) = 1.5*abs(initials(4));
end

stat.param=BETA';
stat.R2 = 1-sum(RESID.^2)/sum(y.^2);%% Added by PX @05/06/2014

% confidence interval of the parameters
stat.paramCI = nlparci(BETA,RESID,'Jacobian',J);

% confidence interval of the estimation
[stat.ypred,delta] = nlpredci(f,x,BETA,RESID,'Covar',COVB);
stat.ypredlowerCI = stat.ypred - delta;
stat.ypredupperCI = stat.ypred + delta;

% plot(x,y,'ko') % observed data
% hold on
% plot(x,ypred,'k','LineWidth',2)
% plot(x,[lower,upper],'r--','LineWidth',1.5)

free_param_count=0;
for i=1:4;
    if isnan(fixed_params(i))
        free_param_count=free_param_count+1;
        param(i)=BETA(free_param_count);
    else
        param(i)=fixed_params(i);
    end    
end
    
if plot_flag==1 
    x_vector=min(x):diff(minmax(x'))/100:max(x);
    h = plot(x,y,'k.',x_vector,f(param,x_vector),'r-');
    xlim(minmax(x_vector))
end
