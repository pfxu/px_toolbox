clear
clc
dp = 'I:\DataAnalysis\EOEC\';
con = {'BO','BC'};
for c = 1: length(con)
    ip = fullfile(dp,con{c},'\ROI264NoGMC\GretnaMetrics');
    op = fullfile(dp,'Results');
    if ~exist(op,'dir');mkdir(op);end
    % datapath = '/data/Data/EOEC/BC/ROI90NoGMC/GretnaNetworkMetrics';
    % datapath = '/data/Data/EOEC/BO/ROI90NoGMC/GretnaNetworkMetrics';
    metrics = {'Assortativity','Efficiency','Hierarchy','Modularity',...
        'NodeBetweenness','NodeDegree','NodeEfficiency','SmallWorld','Synchronization'};
    metrics = lower(metrics);
    subnum = 2:24;
    prefix = 'sub_';
    for m = 6: length(metrics)
        s = 0;
        for sn = subnum
            s = s + 1;
            subfolder = fullfile(ip,metrics{m},[prefix,num2str(subnum(s),'%.3d')]);
            %     if strcmp(metrics{m},);end
            % switch metrics
            %     case {'Assortativity','Hierarchy','Synchronization'}
            %         filename = '.txt';
            %     case 'Modularity'
            %     case 'Efficiency'
            %     case 'SmallWorld'
            %     case 'NodeBetweenness'
            %     case 'NodeDegree'
            %     case 'NodeEfficiency'
            % end
            filelist = px_ls('Reg',subfolder,'-F',1);
            for f = 1: length(filelist)
                [pathstr,name,ext] = fileparts(filelist{f}) ;
                load(filelist{f});
                data = eval(name);
                if size(data,1) == 1;
                    cmd = [con{c} '.' metrics{m} '_' name '(' num2str(s) ',:) = data;'];
                else
                    cmd = [con{c} '.' metrics{m} '_' name '{' num2str(s) ',1} = data;'];
                end
                eval(cmd);
                save(fullfile(op,con{c}), con{c});
            end
        end
    end
end