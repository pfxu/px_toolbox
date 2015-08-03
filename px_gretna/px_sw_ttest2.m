function px_sw_ttest2(fpath,fname,nname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  px_sw_ttest2(fpath,fname,nname)
%  this funtion is for the two sample t-test of sw data.
%  fname is a cell file which includs the name of sw data for each group
%  Example for data structure of each group:
%  'fname{1}.propertytype.paremetername.data';
%
%
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

px_log;
flog = fopen([pwd,filesep,nname,'_sw_ttest2_log',datestr(clock,30), '.txt'],'wt');
for i = 1:length(fname)
    NumSub = length(eval(['flist{i,1}.' gname{i,1}{n,1}]));
    for sub = 1: NumSub
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
                        eval(cmd );
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

%%% ------------------------two sample t-test---------------------------------
NumROI = length(eval(['flist{' num2str(i) ',1}.' gname{i,1}{m,1} '.' iname{i,1}{j,1}{k}]));
fid = fopen([dpath,nname,'.txt'],'wt');
for i = 1:length(fname)
    for j = 1:length(gname{i,1})
        if isempty(regexp(gname{i,1}{j,1}, 'node_para','match'))
            fprintf(fid, [repmat('-',1,30) 'Global' repmat('-',1,30) '\n']);
            fprintf(fid, 'parameter\tt\tp\tComments\n');
            for k = 1:length(iname{i,1}{j,1})
                if  ~isempty(regexp(iname{i,1}{j,1}{k}, 'thresh_s','match'))
                    continue
                elseif isempty(regexp(iname{i,1}{j,1}{k}, 'anodalE','match'))
                    cmd = ['[h,p,ci,stats] =' 'ttest2(' fname{1} '_' iname{i,1}{j,1}{k} ', '...
                        fname{2} '_' iname{i,1}{j,1}{k} ');'];
                    eval(cmd);
                    fprintf(flog, '%s\n',cmd);
                    if p <0.05
                        fprintf(fid, '%s\t%d\t%d\n',iname{i,1}{j,1}{k},stats.tstat,p);
                    end
                else
                    for r = 1:NumROI
                        cmd = ['[h(r),p(r)] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                            fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) '));'];
                        eval(cmd);
                        fprintf(flog, '%s\n',cmd);
                        if p(r)<0.05
                            cmd = ['[a b c d] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                                fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) '));'];
                            eval(cmd);
                            fprintf(fid, '%s\t%f\t%f\tROI=%d\n',iname{i,1}{j,1}{k},d.tstat,b,r);
                        end
                    end
                    [pID,pN] = gretna_FDR(p,0.05);
                    if pID < 0.05
                        index = find (p<pID);
                        for num = 1:length(index)
                            cmd = ['[a,b,c,d] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                                fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(num) '));'];
                            eval(cmd);
                            fprintf(fid, '%s\t%f\t%f\tROI=%d FDR\n',iname{i,1}{j,1}{k},d.tstat,b,index);
                        end
                    end
                end
            end
        else
            fprintf(fid, [repmat('-',1,30) 'Nodal' repmat('-',1,30) '\n']);
            fprintf(fid, 'parameter\tt\tp\tROI\tComments\n');
            for k = 1:length(iname{i,1}{j,1})
                for r = 1:NumROI
                    cmd = ['[h(r),p(r)] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                        fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) '));'];
                    eval(cmd);
                    fprintf(flog, '%s\n',cmd);
                    if p(r)<0.05
                        cmd = ['[a b c d] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) ')' ', ' ...
                            fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(r) '));'];
                        eval(cmd);
                        fprintf(fid, '%s\t%f\t%f\t%d\n',iname{i,1}{j,1}{k},d.tstat,b,r);
                    end
                end
                [pID,pN] = gretna_FDR(p,0.05);
                if pID < 0.05
                    index = find (p<pID);
                    for num = 1:length(index)
                        cmd = ['[a b c d] = ttest2(' fname{1} '_' iname{i,1}{j,1}{k} '(:,',num2str(index) ')' ', ' ...
                            fname{2} '_' iname{i,1}{j,1}{k} '(:,',num2str(index) '));'];
                        eval(cmd);
                        fprintf(fid, '%s\t%f\t%f\t%d\tFDR\n',iname{i,1}{j,1}{k},d.tstat,b,index);
                    end
                end
            end
        end
    end
end
fprintf(flog,'%s',datestr(clock,30));
%fprintf(flog,'%s',datestr(now));
fclose(fid);
fclose(flog);