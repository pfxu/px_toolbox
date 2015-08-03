function px_report_aal_fc_edge(opath,oname,row,col,value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT  px_report_aal_fc_edge(opath,oname,row,col)
%     Usage Report the edge of the functional connectivity(paired nodes in 
%           AAL).
%     Input
%           opath - output path
%           oname - output name
%           row   - row number in the fc matrix
%           col   - column number in the fc matrix
%     Output
%            A file named "oname" under "opath" in .txt format.
% 
% Copyright(c) 2012-2012 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2012/9/11 00:00:00
%==========================================================================

if length(row) ~= length(col),error('number of row is not equal to column');end
if strcmp(oname(end-3:end),'.txt'),oname = oname;
else oname = [oname,'.txt'];end
fid = fopen(fullfile(opath,oname),'w');
px_path = px_toolbox_root;
template_path = fullfile(px_path,'templates');
[template_number,template_label,template_x,template_y,template_z,class,lobe,modal]=...
    textread(fullfile(template_path,'AAL90_Info.txt'),'%d%s%s%s%s%s%s%s');
nedges = length(row);
fprintf(fid, 'Edges =%d \n', nedges);
fprintf(fid, [repmat('-',1,60) '\n']);
for n = 1: nedges
    r = row(n); c = col(n);
    if nargin == 5
        fprintf(fid,'%s\t  %s\t %s\t %s\t %s\t %s\t %f\t \n',template_label{r},lobe{r},class{r},template_label{c},lobe{c},class{c},value(n));
    elseif nargin ==4
        fprintf(fid,'%s\t  %s\t %s\t %s\t %s\t %s\t \n',template_label{r},lobe{r},class{r},template_label{c},lobe{c},class{c});
    end
end
fclose(fid);