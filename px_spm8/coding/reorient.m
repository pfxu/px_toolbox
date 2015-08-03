List = spm_select;

for file = 1:size(List,1)
    display(['reorienting : ' List(file,:)]);
    P = spm_vol(List(file,:));
    Vin = spm_read_vols(spm_vol(P));

    %% change orientation based on dimension
     
    V = shiftdim(Vin,2);

    dim = size(V);
        
    for n = 1:dim(1)
        Vflip(dim(1) +1-  n,:,:) = rot90(rot90(reshape(V(n,:,:),256,256)));                  
    end

    slashes = strfind(P.fname,'/');
    P.dim = dim; 
    P.fname = [P.fname(1:slashes(end)) 'x' P.fname(slashes(end)+1:end)];
    P.pinfo = [5.0210;0;0];
    P.mat = ...
     [-1.0000         0         0   85.5000;
         0    1.0000         0 -128.5000;
         0         0    1.0000 -128.5000;
         0         0         0    1.0000];
    spm_write_vol(P, Vflip);
end