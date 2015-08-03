function out=px_readlog_eprime(pname,fname)
out=[];
%open the file
f=fullfile(pname,fname);
fid=fopen(f);
if fid<0;
    disp('error file not found');
    out=[];
    return;
end;
out=readheader(fid,out);%first get the info from the header
out=readbody(fid,out); %now read the rest of the file.
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out=readbody(fid,out);
stop=false;
linecnt=0;
level=0;
while ~(feof(fid)|stop)
    %%%data = textscan(fid,'%s','delimiter','\n');
    tline=fgetl(fid); %read a line
    %disp(tline)
    tline=px_delx(tline,0,inf); %% comment it according to different computer or data
    %tline=px_delx(tline,33,inf); %% comment it according to different computer or data
    %tline =native2unicode(tline);
    %disp(tline)
    if isempty(tline); continue; end  % skip the empty line
    if ~isempty(findstr(tline,'Level:')) %a level is defined
        ind=findstr(tline,':');
        level=str2num(tline(ind+2:end));
        continue
    end
    %     if ~isempty(findstr(tline,'LogFrame Start')); %A new line with info is stored
    if ~isempty(findstr(tline,'LogFrame Start')); %A new line with info is stored
        linecnt=linecnt+1;
        continue
    end;
    %     if ~isempty(findstr(tline,'LogFrame End')); %I don't want to use a line containing this text
    if ~isempty(findstr(tline,'LogFrame End')); %I don't want to use a line containing this text
        continue
    end;
    ind=findstr(tline,':');
    value = str2num(tline(ind+2:end)); %% This step will generate a figure sometimes
    if isempty(value); %apparently it was not a number
        value=tline(ind+2:end); %now store it as string!
    end
    s=tline(1:ind-1);
    s1=['tmp=out.' s '.level; out.' s '.level=cat(1,tmp,level);'];
    s2=['tmp=out.' s '.linecnt; out.' s '.linecnt=cat(1,tmp,linecnt);'];
    s3=['tmp=out.' s '.value; out.' s '.value=cat(1,tmp,{value});'];
    se1=['out.' s '.level=level;'];
    se2=['out.' s '.linecnt=linecnt;'];
    se3=['out.' s '.value={value};'];
    if isempty(value)
        value = NaN;
        %Maybe there was nothing to store
        %then don't store anything;
        s1=['tmp=out.' s '.level; out.' s '.level=cat(1,tmp,level);'];
        s2=['tmp=out.' s '.linecnt; out.' s '.linecnt=cat(1,tmp,linecnt);'];
        s3=['tmp=out.' s '.value; out.' s '.value=cat(1,tmp,{value});'];
        se1=['out.' s '.level=level;'];
        se2=['out.' s '.linecnt=linecnt;'];
        se3=['out.' s '.value={value};'];
    end
    eval(s1,se1);
    eval(s2,se2);
    eval(s3,se3);
end;
return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out=readheader(fid,out)
stop=false;
nlevel=0;
while ~(feof(fid)|(stop))
    tline=fgetl(fid);%read a line,
    %disp(tline)
    tline=px_delx(tline,0,inf); %% comment it according to different computer or data
    %disp(tline)
    % tline=px_delx(tline,33,inf); %% comment it according to different computer or data
    if ~isempty(findstr(tline,'Header End'));%check for header end %% delet space between words.
        stop=true;
    end
    if ~isempty(findstr(tline,'LevelName'));
        nlevel = nlevel+1;
    end
end;
out.nlevel=nlevel;
return
%store information
%close the file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Y = px_delx(X,l,u) %delet the error code
N = uint16(X);
N = N(N > l & N< u);
Y = char(N);
return