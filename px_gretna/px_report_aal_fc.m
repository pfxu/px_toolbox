function px_report_aal_fc(opath,oname,index,tvalue)
if strcmp(oname(end-3:end),'.txt'),oname = oname;
else oname = [oname,'.txt'];end
fid = fopen(fullfile(opath,oname),'w');
px_path = which('px_toolbox');
[pathstr, name, ext] = fileparts(px_path);
template_path = fullfile(pathstr,'Template');
[template_number,template_label,template_x,template_y,template_z]=...
    textread(fullfile(template_path,'AAL90.txt'),'%d%s%s%s%s');
for n = 1: length(template_number)
    %     if ismember(n,index)
    %         id = find(ismember(index,n) == 1);
    %    [tf id] = ismember(n,index);
    %     if tf == 1
    %         if tvalue(id) > 0
    %             color = 1;
    %         elseif tvalue(id) < 0
    %             color = -1;
    %         end
    if ismember(n,index)
        id = find(ismember(index,n) == 1);
        size = 1*length(id);color = 4;
        fprintf(fid, '%s\t%s\t%s\t%d\t%d\t%s',...
            template_x{n},template_y{n},...
            template_z{n},color,size,template_label{n});
    else
        size = 0;color = -4;
        fprintf(fid, '%s\t%s\t%s\t%d\t%d\t%s',...
            template_x{n},template_y{n},...
            template_z{n},color,size,template_label{n});
    end
    fprintf(fid,'\n');
end
fclose(fid);