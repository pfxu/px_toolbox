function [number] = px_num(vector,num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   [number] = px_num(vector,num)
%
%    Pengfei Xu, MSSM, Oct/25/2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n      = vector(1);
number = [];
for i = vector
    number((1+(i-n)*num):(num+(i-n)*num),1) = i*ones(num,1);
end

%save('number.txt','number', '-DOUBLE','-TABS');