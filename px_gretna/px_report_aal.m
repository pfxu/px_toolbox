function px_report_aal(opath,oname,index,tvalue,pvalue)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT   px_report_aal(opath,oname,index,tvalue,pvalue)
%     Usage This function is used to report the results of the region of 
%           AAL template, e.g.,t and p value.
%     Input 
%          opath  - output path. e.g.,'/Data/Pengfei/'; 
%          oname  - output file name. e.g., 'report.txt';
%          index  - index of AAL. e.g.,[1:10];
%          para   - optional parameters INCODING...
%            para.tvalue - optional, e.g., 1.645;
%            para.pvalue - optional, e.g.,  0.05;
%            para.color  -
%            para.size   -
%     Output 
%          A file named "oname" under "opath" in .txt format.
%
% Copyright(c) 2012-2012 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2012/9/11 00:00:00
%==========================================================================
if nargin == 3, tvalue = []; pvalue = [];end
if nargin == 4, pvalue = []; 
    if length(index) ~= length(tvalue),
        dispaly('Number of t is nor equal to the number of region');
    end
end
if nargin == 5, length(index) ~= length(tvalue)|...
        length(index) ~= length(pvalue),
    display('Number of t/p is nor equal to the number of region');
end

node = unique(index);
degree = hist(index,b);
% v = unique(value);
% if length(node) ~= length(v);
%     error('There is actually %d index but %d value',length(node),length(v));
% end

if strcmp(oname(end-3:end),'.txt'),oname = oname;
else oname = [oname,'.txt'];end
fid = fopen(fullfile(opath,oname),'w');
template_path = fullfile(px_toolbox_root,'templates');
[template_number,template_label,template_x,template_y,template_z]=...
    textread(fullfile(template_path,'AAL90.txt'),'%d%s%s%s%s');
if isempty(tvalue);
    fprintf(fid,'AAL_NUM\t\tx\ty\tz\tlabel\tdegree\n');
elseif isempty(pvalue);
    fprintf(fid,'AAL_NUM\t\tx\ty\tz\tlabel\ttvalue\tdegree\n');
else
    fprintf(fid,'AAL_NUM\t\tx\ty\tz\tlabel\ttvalue\tpvalue\tdegree\n');
end
for i = 1:length(node)
    if isempty(tvalue);
        fprintf(fid, '%d\t%s\t%s\t%s\t%s\t%d',...
            template_number(index(i)),template_x{index(i)},template_y{index(i)},...
            template_z{index(i)},template_label{index(i)},degree(i));
    elseif isempty(pvalue);
        fprintf(fid, '%d\t%s\t%s\t%s\t%.3f\t%s\t%d',...
            template_number(index(i)),template_x{index(i)},template_y{index(i)},...
            template_z{index(i)},tvalue(i),template_label{index(i)},degree(i));
    else
        fprintf(fid, '%d\t%s\t%s\t%s\t%f\t%f\t%s\t%d',...
            template_number(index(i)),template_x{index(i)},template_y{index(i)},...
            template_z{index(i)},tvalue(i),pvalue(i),template_label{index(i)}),degree(i);
    end
    fprintf(fid,'\n');
end

fclose(fid)
