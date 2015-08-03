function [t d aux] = create_d( file )

fid = fopen(file); %Links the file to the unique identifier in matlab called "fid"
i = 0;
r2 = 0;

while r2 == 0
    temp = fgetl(fid); %reads in one line of the file at a time
    if ~isempty(strfind(temp, 'Baseline end')) %looks to see if the phrase "baseline end" is in this line
        r1 = i+1; %sets the position of row 1
        i = i+1;
        temp = fgetl(fid);
        c2 = length(strfind(temp, sprintf('\t'))); %calculates how many columns there are in the current line of data by counting the number of tabs
    end
    if ~isempty(strfind(temp, 'Device Stopped'))
        r2 = i-1;
    end
    i = i+1;
end

data = dlmread(file, '\t' ,[r1, 0, r2, c2]);  % converts biopac nir files into matlab files

%%integrating the data into the homer2 template
load test4                                                               


t = data (:,1);   % this is the time series from the .nir file
d = data (:,[2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47,49]);
                   % this is the data for 850 and 730 from the .nir file produced by fNIRS imager 1000, excluding ambient light channels. 
                   %to include them change to d = data (:,[2:49)) 

aux = t;
aux(:,2) = 0;
aux = aux(:,2);
end

