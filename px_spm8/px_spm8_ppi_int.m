function px_spm8_ppi_int(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_spm8_ppi_int(fdp,para)
% Usage This function was used to create ppi variate either for the  
%       psyphysical interaction or for the phyphysical interaction.
% fdp.SPM 
%      full file path of the SPM.mat file
% fdp.VOI 
%      for psyphysical interaction, one physiological variable.
%      for phyphysical interaction, two phyphysical variables, cell format. 
% para.type 
%      1 - psyphysical interaction 
%      2 - phyphysical interaction
% para.on  
%      output name for the ppi variable.   
% para.con  
%      contrast weights for psyphysical interaction ONLY; 
%
% Pengfei Xu, 12/26/2012, @BNU
% Revised by PX, Dec-09-2014, @UMCG; from px_spm8_ppi;
%========================================================================== 

% check input
if ~exist(fdp.SPM,'file');
    error('%s does not exist.',fdp.SPM);
end
if ~exist(fdp.VOI,'file');
    error('%s does not exist.',fdp.VOI);
end

if ischar(fdp.SPM)
    fdp.SPM = cellstr(fdp.SPM);
end
if ischar(fdp.VOI)
    fdp.VOI = cellstr(fdp.VOI);
end
if ~isfield(para,'op')
    para.op = fileparts(char(fdp.SPM));
end
%
matlabbatch{1}.spm.stats.ppi.spmmat = fdp.SPM;
if para.type == 1
    matlabbatch{1}.spm.stats.ppi.type.ppi.voi = fdp.VOI;
    matlabbatch{1}.spm.stats.ppi.type.ppi.u = para.con;
elseif para.type == 2
    matlabbatch{1}.spm.stats.ppi.type.phipi.voi = {fdp.VOI{1};fdp.VOI{2}};
end
matlabbatch{1}.spm.stats.ppi.name = para.on;
matlabbatch{1}.spm.stats.ppi.disp = 1;
save (fullfile(para.op,'ppi_int'), 'matlabbatch');

spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch);