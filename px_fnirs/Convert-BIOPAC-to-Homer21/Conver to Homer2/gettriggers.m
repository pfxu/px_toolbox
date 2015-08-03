
function [triggers] = gettriggers(filename)

fid = fopen(filename); %Links the file to the unique identifier in matlab called "fid"

i = 0;

temp = fgetl(fid); 

%i is equal to total number of lines in file

while ischar(temp)
    i=i+1;
    temp = fgetl(fid); 
end

%dlmread starts index at 0
header_size = 6;
data_offset = header_size;
i = i-1;

triggers = dlmread(filename, '\t' ,[data_offset, 0, i, 2]);

end