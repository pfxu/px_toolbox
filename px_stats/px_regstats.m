function stats = px_regstats(y,x,model,vn)
% USAGE     print the result table of mutiplelinear regression by REGSTATS.
%
% FORMAT
%   stats = px_regstats(y,x)
%   stats = px_regstats(y,x,mode)
%   stats = px_regstats(y,x,model,vn)
%
% INPUT
%   y        - dependet variable, n by 1 array
%   x        - independet variable, n by v matrix. One column corresponds to one variavle.
%  model -  the order of the regression model, can be any of the following strings:
%                'linear', Constant and linear terms (the default)
%                'interaction', Constant, linear, and interaction terms
%                'quadratic', Constant, linear, interaction, and squared terms
%                'purequadratic', Constant, linear, and squared terms
%  vn        - variable names, v by 1 character array or cell array of strings.
%
% OUTPUT
%  stats    - a structure containing the statistics. See REGSTATS for details.
%
%  EXAMPLE
%
%   x = rand(10,1);
%   y = rand(10,1);
%   px_regstats(y,x,'linear') 
% 
%                                             ANOVA
% ---------------------------------------------------------
% 	Model	          df	         SSq	         MSq	           F	         p
% ---------------------------------------------------------
% 	Regression	  2.0000	  2.2774	 1.1387	         0.7187	        0.5201
% 	Residuals	  7.0000	 11.0902	 1.5843
% 	Total   	  9.0000	 13.3677
% ---------------------------------------------------------
% 
%                                      Model Summary
% ---------------------------------------------------------
% 	Root MSE	Dependent Mean	      R2	    Adj R2
% ---------------------------------------------------------
% 	1.2587	       -0.4322	              0.1704	   -0.0667
% ---------------------------------------------------------
% 
%                                       Coefficients
% ---------------------------------------------------------
% 	Variable	Betaֵ	        Beta SE	           t	           p
% ---------------------------------------------------------
% 	(Constant)	-0.4146	         0.5374	        -0.7715	         0.4657
% 	        x1	 0.7845	         0.7602	         1.0320	         0.3364
% 	     x1*x1	 0.1072	         0.9222	         0.1162	         0.9108
% ---------------------------------------------------------
%
% See also REGSTATS
 
if nargin < 2 
   error('At least two arguments are required.'); 
end 
p = size(x,2);    % clomuns of x, i.e., number of variables
if nargin < 3 || isempty(model) 
   model = 'linear';    % Default model
end 
 
% variable names
if nargin < 4 || isempty(vn) 
    varname1 = strcat({'x'},num2str([1:p]')); 
    vn = makevn(varname1,model);    % Default varaible name
else 
    if ischar(vn) 
        varname1 = cellstr(vn); 
    elseif iscell(vn) 
        varname1 = vn(:); 
    else 
        error('vn must be a character array or  a cell array of strings.'); 
    end 
    if size(varname1,1) ~= p 
        error('number of vn must be consistant with number of variables (column of x).'); 
    else 
        vn = makevn(varname1,model);    % ָSpecific variable name
    end 
end 
 
ST = regstats(y,x,model);
f = ST.fstat;
t = ST.tstat; 
% ANOVA
fprintf('\n%50s\n','ANOVA'); 
fprintf('%s\n',repmat('-',100,1)); 
fprintf('\t%s\t%12s\t%12s\t%12s\t%12s\t%10s\n','Model','df','SSq','MSq','F','p'); 
fprintf('%s\n',repmat('-',100,1)); 
fmt = '\t%s\t%8.4f\t%8.4f\t%7.4f\t%15.4f\t%14.4f\n'; 
fprintf(fmt,'Regression',f.dfr,f.ssr,f.ssr/f.dfr,f.f,f.pval); 
fmt = '\t%s\t%8.4f\t%8.4f\t%7.4f\n'; 
fprintf(fmt,'Residuals',f.dfe,f.sse,f.sse/f.dfe); 
fmt = '\t%s\t%8.4f\t%8.4f\n'; 
fprintf(fmt,'Total   ',f.dfe+f.dfr,f.sse+f.ssr); 
fprintf('%s\n',repmat('-',100,1)); 

% Model Summary
fprintf('\n%50s\n','Model Summary'); 
fprintf('%s\n',repmat('-',100,1));
fprintf('\t%s\t%s\t%8s\t%10s\n','Root MSE','Dependent Mean','R2','Adj R2');
fprintf('%s\n',repmat('-',100,1));
fprintf('\t%0.4f\t%14.4f\t%20.4f\t%10.4f\n',sqrt(ST.mse),mean(y),ST.rsquare,ST.adjrsquare);
fprintf('%s\n',repmat('-',100,1)); 

 % Paramter estimation, variables in the equation
fprintf('\n%50s\n','Coefficients'); 
fprintf('%s\n',repmat('-',100,1)); 
fprintf('\t%s\t%s\t%15s\t%12s\t%12s\n','Variable','Betaֵ','Beta SE','t','p'); 
fprintf('%s\n',repmat('-',100,1)); 
for i = 1:size(t.beta,1) 
    if i == 1 
        fmt = '\t%s\t%7.4f\t%15.4f\t%15.4f\t%15.4f\n'; 
        fprintf(fmt,'(Constant)',t.beta(i),t.se(i),t.t(i),t.pval(i)); 
    else 
        fmt = '\t%10s\t%7.4f\t%15.4f\t%15.4f\t%15.4f\n'; 
        fprintf(fmt,vn{i-1},t.beta(i),t.se(i),t.t(i),t.pval(i)); 
    end 
end 
fprintf('%s\n',repmat('-',100,1)); 
 
if nargout == 1 
    stats = ST;
end 
 
function vn = makevn(varname1,model) 
% Label variable name for sepcific model
p = size(varname1,1); 
varname2 = []; 
for i = 1:p-1 
    varname2 = [varname2;strcat(varname1(i),'*',varname1(i+1:end))]; 
end 
varname3 = strcat(varname1,'*',varname1); 
switch model 
    case 'linear' 
        vn = varname1; 
    case 'interaction' 
        vn = [varname1;varname2]; 
    case 'quadratic' 
        vn = [varname1;varname2;varname3]; 
    case 'purequadratic' 
        vn = [varname1;varname3]; 
end