function px_gm_scaling(P)
% FORMAT px_gm_scaling(P)
%  Usage This function is used to do the global mean scaling
%  Input P - image file, NIfTI format.
% -------------------------------------------------------------------------
% -
V                  = spm_vol(P); 
global_mean        = zeros(length(V),1);
global_mean_change = zeros(length(V),1);
EPI_image_tc       = [];
for i = 1:length(V),
  global_mean(i) = spm_global(V(i));  % Calculate global mean change
  global_mean_change(i) = 100*(global_mean(i)-global_mean(1))/global_mean(1);
  EPI_image_tc(i, :,:,:) = EPI_image_tc(i, :,:,:)/(1 + global_mean_change(i)/100); % Scale images based on global mean change
end;
save -ascii globals.txt global_mean;