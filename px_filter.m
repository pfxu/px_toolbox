function Data = px_filter(TR,band,txtfile,path,name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Data =  px_filter(TR,band,file,path,name)
% 
%   TR     =2.5;
%   band   =[0.01 0.08];
%   txtfile   input path and file with rows corresponding to obervations and columns 
%           to time course, txt format,e.g.'/data/behavior.txt';
%   path   output path of the file after filtered;
%   name   outputname,e.g.,'subject001';
%
%
%   Pengfei Xu, QC, CUNY, 1/19/2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(path(end),filesep),outputpath = path; else outputpath=cat(2,path,filesep);end
if ~exist(outputpath,'dir'); mkdir(outputpath);end
if strcmp(name(end-3:end),'.txt'),outputname = name; else outputname=cat(2,name,'.txt');end
file = load (txtfile);
SampleRate = 1/TR;
Fs = SampleRate;
[b, a] = butter(5, band/(Fs/2));
for i = 1:size(file,1)
    CellFile = file(i,:);
    CellFile_fil = detrend(CellFile);
    Data(i,:) = filtfilt(b,a,CellFile_fil);
end
save([outputpath,outputname],'Data','-ASCII', '-DOUBLE','-TABS');