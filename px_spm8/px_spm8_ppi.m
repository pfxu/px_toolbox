function px_spm8_ppi(pd,flag,voi,na,con)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_ppi(pd,flag,voi,na,con)
% Usage This function was used to create ppi variate.
% For the psyphysical interaction 
% For the phyphysical interaction
% pd 
%      the path of the SPM.mat file
% flag 
%      1 psyphysical interaction 
%      2 phyphysical interaction
% voi 
%      for psyphysical interaction, one physiological variable.
%      for phyphysical interaction, two phyphysical variables, cell format. 
% na  
%      name for the output ppi variable.   
% con  psyphyi only
%      contrast weights for psyphysical interaction only; 
% Pengfei Xu, 12/26/2012, @BNU
%========================================================================== 
matlabbatch{1}.spm.stats.ppi.spmmat = {fullfile(pd,'SPM.mat')};
if flag == 1
    matlabbatch{1}.spm.stats.ppi.type.ppi.voi = voi;
    matlabbatch{1}.spm.stats.ppi.type.ppi.u = con;
elseif flag == 2
    matlabbatch{1}.spm.stats.ppi.type.phipi.voi = {voi{1};voi{2}};
end
matlabbatch{1}.spm.stats.ppi.name = na;
matlabbatch{1}.spm.stats.ppi.disp = 1;
save (fullfile(pd,'matlabbatch_ppi'), 'matlabbatch')
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);