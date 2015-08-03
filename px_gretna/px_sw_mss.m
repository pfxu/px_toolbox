function px_sw_mss(rpath, npath, rname, nname,vector)
% px_sw_mss(rpath, npath, rname, nname,vector)
%
% this function is used to merge the data for each single subject to one file.
% for each single subject, the data name must like 'name_001.mat' and there
% should have sw_auc, sw_eff_aucand node_para in each .mat file
%
%  Pengfei Xu, QCCUNY, Jan/12/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(rpath(end),filesep);pr=rpath; else pr=[rpath,filesep]; end
if strcmp(npath(end),filesep);pn=npath; else pn=[npath,filesep]; end
if ~exist(pn,'dir');mkdir(pn);end
px_log;
flog = fopen([pwd,filesep,nname,'_sw_merge_log',datestr(clock,30),'.txt'],'wt');
fprintf(flog, 'pathraw = %s \n',pr);
fprintf(flog, 'pathnew = %s \n',pn);
i = 0;
for sub = vector
    i = i+1;
    %     clear('-regexp', 'sw');
    %     clear('-regexp', 'node_para');
    file= load([pr,rname,num2str(sub,'%03.0f')]);
    flist = fieldnames(file);
    for j = 1:length(flist)
        if isempty(regexp(flist{j},'node_para','match'))
            k = length(eval(['file.' flist{j}]));
            cmd = [flist{j} '(' num2str(i) ',1)' '=' 'file.' flist{j} '(' num2str(k) ');'];
            eval(cmd);
            fprintf(flog, '%s \n',cmd);
        else
            names = fieldnames(eval(['file.' flist{j}]));
            for m = 1:length(names)
                n = size(eval(['file.' flist{j}  '.' names{m}]),1);
                if n ~= k, error(fprintf('sub %d length(node_para) ~= length(sw_auc)',sub));end
                cmd = [flist{j} '.' names{m} '(' num2str(i) ',:,:)' ...
                    '=' 'file.' flist{j} '.' names{m} '(' num2str(n) ',:,:);'];
                eval(cmd);
                fprintf(flog, '%s \n',cmd);
            end
        end
    end
end
for n = 1:length(flist)
    if n == 1;
        save([pn,nname], eval(['flist{' num2str(n) '}']));
    else
        save([pn,nname], eval(['flist{' num2str(n) '}']),'-append');
    end
end

%fprintf(flog,'%s',datestr(clock,30));
fprintf(flog,'%s', datestr(now));
fclose(flog);