function px_hm_plot(ip,op,sn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FORMAT px_hm_plot(ip,op)
%     Usage Plot the head motion (rp.txt file) and saveas .ps file.
%     Input
%         ip  - input path
%         op  - output path
%         sn  - (optional) subject name
%     Output
%         .ps file will be generated under the output path.
%
% Copyright 2013-2013 Pengfei Xu, Beijing Normal University
% Mail to author: pennfeixu@gmai.com
% Revision: 2.0 Date: 2013/03/10 00:00:00.
% Revised by Pengfei Xu, 2015/03/04,NIC,UMCG, append .ps file
%==========================================================================
rpname = dir(fullfile(ip,'rp*'));
if isempty(rpname);error(['There is no rp* file under' ip]);end
for i = 1:size(rpname,1)
    data = load(fullfile(ip,rpname(i).name));
    data(:,4:6) = data(:,4:6).*180/pi; %from radian to degree
    % spm figure is degree but the rp dara were radians
    v = {1:3,4:6};
    ts = {'Translation';'Rotation'};
    ys = {'mm';'degree'};
    ls = {'x translation','z translation','roll';...
        'y translation','pitch','yaw'};
    fig = figure('Color',[1 1 1]);
    for f = 1:length(ts);
        subplot(2,1,f,'Parent',fig);
        plot(data(:,v{f}));
        legend(ls{v{f}});
        xlabel({'Image'});
        ylabel(ys{f});
        if nargin == 3
            title([sn ' ' ts{f}]);
        else
            title(ts{f});
        end
    end
    %     if nargin == 3
    %         saveas(gcf,fullfile(op,[sn '.ps']),'ps')
    %     else
    %         saveas(gcf,fullfile(op,[num2str(i,'%03.0f') '.ps']),'ps')
    %     end
    print(gcf,'-append','-dpsc',fullfile(op,'HeadMotion.ps'));
    pause(3);
    close(fig);
end