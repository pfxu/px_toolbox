function [data] = px_importcsv(fn,opt,nn)
% This function is used to load .csv file only.
% Input
%   fn - filename
%   opt - option for output file
%         0, no output;
%         1, generate output file.
%   nn  - new file name, only if opt == 1;

if nargin == 1;
    opt = 0;
end
if opt == 0;
    nn = ['tmp_' fn];
end
if ~strcmp(fn(end-3:end),'.csv');
    error('%s is not .csv file.',files(f).name);
end

fid_old = fopen(fn);
fid_new = fopen(nn,'w+');


firstline = fgetl(fid_old);

num_delimiter = numel(regexp(firstline,';'));

firstline = regexprep(firstline,';;',';0;');
firstline = regexprep(firstline,';;',';0;');
firstline = regexprep(firstline,';$',';0$');
firstline = regexprep(firstline,'^;','0;');
firstline = [firstline '\n'];

fprintf(fid_new,firstline);

while ~feof(fid_old)
    
    line = fgetl(fid_old);
    
    num_delim_thisline = numel(regexp(line,';'));
    
    diff_delim = num_delimiter-num_delim_thisline;
    
    if diff_delim > 0
        
        line = [line repmat(';',1,diff_delim)];
        
    end
    line = regexprep(line,';;',';0;');
    line = regexprep(line,';;',';0;');
    line = regexprep(line,';$',';0');
    line = regexprep(line,'^;','0;');
    line = [line '\n'];
    % line = regexprep(line,';\n',';0\n');
    fprintf(fid_new,line);
    
end

fclose(fid_old);
fclose(fid_new);
try
    data = load(nn);
catch
    data = importdata(nn);
    %     error(lasterr)
end
if opt == 0;
    delete(nn);
end