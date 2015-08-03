function px_sw_corr(fpath,fname,vname,nname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  px_sw_ttest(fpath,fname,vname,nname)
%  this funtion is for the paired ttest of sw data.
%
%  fname is a cell file which includs the name of sw data for each group
%    Example for data structure of each group:
%     'fname{1}.propertytype.paremetername.data';
%  vname is the whole name for the variable, e.g.'scores.txt'/'scores.mat'.
%    data of the variable shoule be a x-by-y matrix, with rows(x)
%    corresponding to observations and columns(y) to varaibles.
%  Pengfei Xu, QCCUNY, Jan/12/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(fpath(end),filesep);dpath=fpath; else dpath=[fpath,filesep]; end

for i = 1:length(fname)
    flist{i,1} = load([dpath,fname{i}]);
    gname{i,1} = fieldnames(flist{i,1});
    for j = 1:length(gname{i,1})
        iname{i,1}{j,1} = fieldnames(eval(['flist{i,1}.' gname{i,1}{j,1}]));
        if ~isempty(regexp(gname{i,1}{j,1}, 'node_para','match')); m = j;
        else n = j; end
    end
end
variable = load([dpath,vname]);
NumSub = length(eval(['flist{i,1}.' gname{i,1}{n,1}]));
if size(variable,1) ~= NumSub; 
    error('number of variables ~= number of subject of sw');
end
px_log;
flog = fopen([pwd,filesep,nname,'_sw_corr_log',datestr(clock,30), '.txt'],'wt');
for sub = 1: NumSub
    for i = 1:length(fname)
        for j = 1:length(gname{i,1})
            if isempty(regexp(gname{i,1}{j,1}, 'node_para','match'))
                for k = 1:length(iname{i,1}{j,1})
                    if  ~isempty(regexp(iname{i,1}{j,1}{k},'thresh_s','match'))
                        continue
                    elseif ~isempty(regexp(iname{i,1}{j,1}{k}, '^a'))
                        if isempty(regexp(iname{i,1}{j,1}{k}, 'anodalE','match'))
                            cmd = [fname{i} '_' iname{i,1}{j,1}{k} '(' num2str(sub) ')' ...
                                '=' 'flist{' num2str(i) ',1}.' gname{i,1}{j,1} '(' num2str(sub) ',1)' '.' iname{i,1}{j,1}{k} ';'];
                            eval(cmd);
                            fprintf(flog, '%s \n',cmd);
                        else
                            cmd = [fname{i} '_' iname{i,1}{j,1}{k} '(' num2str(sub) ',:)' ...
                                '=' 'flist{' num2str(i) ',1}.' gname{i,1}{j,1} '(' num2str(sub) ',1)' '.' iname{i,1}{j,1}{k} ';'];
                            eval(cmd);
                            fprintf(flog, '%s \n',cmd);
                        end
                    else
                        cmd  = [fname{i} '_' iname{i,1}{j,1}{k} '(' num2str(sub) ')' ...
                            '=' 'mean(flist{' num2str(i) ',1}.' gname{i,1}{j,1} '(' num2str(sub) ',1)' '.' iname{i,1}{j,1}{k} ');'];
                        eval(cmd);
                        fprintf(flog, '%s \n',cmd);
                    end
                end
            else
                for k = 1:length(iname{i,1}{j,1})
                    if  ~isempty(regexp(iname{i,1}{j,1}{k}, '^a'))
                        cmd = [fname{i} '_' iname{i,1}{j,1}{k} '(' num2str(sub) ',:)' ...
                            '=' 'flist{' num2str(i) ',1}.' gname{i,1}{j,1} '.' iname{i,1}{j,1}{k} '(' num2str(sub) ',:)' ';'];
                        eval(cmd);
                        fprintf(flog, '%s \n',cmd);
                    else
                        cmd  = [fname{i} '_' iname{i,1}{j,1}{k} '(' num2str(sub) ',:)' ...
                            '=' 'mean(flist{' num2str(i) ',1}.' gname{i,1}{j,1} '.' iname{i,1}{j,1}{k} '(' num2str(sub) ',:,:)'  ',2);'];
                        eval(cmd);
                        fprintf(flog, '%s \n',cmd);
                    end
                end
            end
        end
    end
end

%%% ------------------------correlation---------------------------------
NumROI = length(eval(['flist{' num2str(i) ',1}.' gname{i,1}{m,1} '.' iname{i,1}{j,1}{k}]));
fid = fopen([dpath,nname,'.txt'],'wt');
for v = 1:size(variable,2)
    fprintf(fid, 'variable %d\n\n',v);    
    for i = 1:length(fname)
        for j = 1:length(gname{i,1})
            if isempty(regexp(gname{i,1}{j,1}, 'node_para','match'))
                fprintf(fid, [repmat('-',1,30) 'Global' repmat('-',1,30) '\n']);
                fprintf(fid, 'parameter\tt\tp\tComments\n');
                for k = 1:length(iname{i,1}{j,1})
                    if  ~isempty(regexp(iname{i,1}{j,1}{k}, 'thresh_s','match'))
                        continue
                    elseif isempty(regexp(iname{i,1}{j,1}{k}, 'anodalE','match'))
                        cmd = ['[c, p] =' 'corr(' fname{i} '_' iname{i,1}{j,1}{k} ''',' ...
                            'variable' '(:,' num2str(v) '));'];
                        eval(cmd);
                        fprintf(flog, '%s\n',cmd);
                        if p <0.05
                            fprintf(fid, '%s\t%f\t%f\n',iname{i,1}{j,1}{k},c,p);
                        end
                    else
                        for r = 1:NumROI
                            cmd = ['[c(r),p(r)] = corr(' fname{i} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                                'variable' '(:,' num2str(v) '));'];
                            eval(cmd);
                            fprintf(flog, '%s\n',cmd);
                            if p(r)<0.05
                            fprintf(fid, '%s\t%f\t%f\t%d\n',iname{i,1}{j,1}{k},c(r),p(r),r);
                            end
                        end
                        [pID,pN] = gretna_FDR(p,0.05);
                        if pID < 0.05
                            index = find (p<pID);
                            fprintf(fid, '%s\t%f\t%f\t ROI=%d\n',iname{i,1}{j,1}{k},c(index),p(index),index);
                        end
                    end
                end
            else
                fprintf(fid, [repmat('-',1,30) 'Nodal' repmat('-',1,30) '\n']);
                fprintf(fid, 'parameter\tt\tp\tROI\tComments\n');
                for k = 1:length(iname{i,1}{j,1})
                    for r = 1:NumROI
                        cmd = ['[c(r),p(r)] = corr(' fname{i} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                            'variable' '(:,' num2str(v) '));'];
                        eval(cmd);
                        fprintf(flog, '%s\n',cmd);
                        if p(r)<0.05
                            fprintf(fid, '%s\t%f\t%f\t%d\n',iname{i,1}{j,1}{k},c(r),p(r),r);
                        end
                    end
                    [pID,pN] = gretna_FDR(p,0.05);
                    if pID < 0.05
                        index = find (p<pID);
                        fprintf(fid, '%s\t%f\t%f\t%d FDR\n',iname{i,1}{j,1}{k},c(r),p(r),index);
                    end
                end
            end
        end
    end
end

%fprintf(flog,'%s',datestr(clock,30));
fprintf(flog,'%s',datestr(now));
fclose(fid);
fclose(flog);