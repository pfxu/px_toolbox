function px_report_aal_fc_node(opath,oname,index,value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT  px_report_aal_fc_node(opath,oname,index,value)
%     Usage Report the AAL coordinates of the nodes in the functional 
%           connectivity for BrainNet Viewer.
%     Input
%           opath - output path
%           oname - output name
%           index   - row or column numberin the fc matrix or AAL number .
%           value   - (optional) user-specific value(tvalue or pvalue in 
%                     the fc matrix). An array with same dimension with 
%                     index. If without this option, the node will be
%                     weighted by edges.
%     Output
%            A file named "oname" under "opath" in .txt format. It includes
%            6 columns: [x, y, z, color, size, label]. 
%            Note: The size of the node will be weighted by how many edges 
%                  it has; color = 4|-4.
% Copyright(c) 2012-2012 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 2012/9/11 00:00:00
%==========================================================================
if ~strcmp(oname(end-4:end),'.node');oname = [oname,'.node'];end
fid = fopen(fullfile(opath,oname),'w');
template_path = fullfile(px_toolbox_root,'templates');
[template_number,template_label,template_x,template_y,template_z]=...
    textread(fullfile(template_path,'AAL90.txt'),'%d%s%s%s%s');
m = 0;
for n = 1: length(template_number)
%     if ismember(n,index)
%         id = find(ismember(index,n) == 1);
%         [tf id] = ismember(n,index);
%         if tf == 1
%             if tvalue(id) > 0
%                 color = 1;
%             elseif tvalue(id) < 0
%                 color = -1;
%             end
    if ismember(n,index)
        id = find(ismember(index,n) == 1);
        if nargin == 3
        size = length(id); % weight the node by how many edges it has.
        elseif nargin == 4
            m = m + 1;
            size = value(m);
        end
        color = 4; % arbitrary setting
        fprintf(fid, '%s\t%s\t%s\t%d\t%d\t%s',...
            template_x{n},template_y{n},...
            template_z{n},color,size,template_label{n});
    else
        size  = 0; % disgard the nodes with no edges.
%       color = -4;% arbitrary setting
        color = 0;% arbitrary setting, Revised by PX 11/19/2013
        fprintf(fid, '%s\t%s\t%s\t%d\t%d\t%s',...
            template_x{n},template_y{n},...
            template_z{n},color,size,template_label{n});
    end
    fprintf(fid,'\n');
end
fclose(fid);