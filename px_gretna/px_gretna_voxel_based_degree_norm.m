function px_gretna_voxel_based_degree_norm(fdp)
%==========================================================================
% FORMAT px_gretna_voxel_based_degree_norm(fdp)
% Usage  normalize the nodal degree maps from gretna_voxle_based_degree.m
%        file.% z(i) = (s(i)- mean)/std
% Input
%        fdp.scan - full path of images from gretna_voxle_based_degree.m
%==========================================================================

V = spm_vol(fdp.scan);
for i = 1:length(V)        
  Y          = spm_read_vols(V(i));
  ind        = find(Y); % exclude non-edge (r = 0 (r < thr))
  Y_sort     = reshape(Y(ind),1,[]);
  Y(ind)     = (Y(ind)-mean(Y_sort))./std(Y_sort);    
  [pathstr,name,ext]   = fileparts(V(i).fname);  
  V(i).fname = fullfile(pathstr,[name '_z' ext]);
  spm_write_vol(V(i),Y);
end  


    

