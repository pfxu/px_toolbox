function px_report_aal_fc_nodes(opath,oname,row,col)
% px_report_aal_fc_nodes(opath,oname,row,col)

if length(row) ~= length(col),error('number of row is not equal to column');end
if strcmp(oname(end-3:end),'.txt'),oname = oname;
else oname = [oname,'.txt'];end
fid = fopen(fullfile(opath,oname),'w');
px_path = which('px_toolbox');
[pathstr, name, ext] = fileparts(px_path);
template_path = fullfile(pathstr,'Template');
[template_number,template_label,template_x,template_y,template_z]=...
    textread(fullfile(template_path,'AAL90.txt'),'%d%s%s%s%s');
nedges = length(row);
fprintf(fid, 'Edges =%d \n', nedges);
fprintf(fid, [repmat('-',1,60) '\n']);
for n = 1: nedges
    r = row(n); c = col(n);
     fprintf(fid,'%s\t  %s\t \n',template_label{r},template_label{c});
end
fclose(fid);