function px_spm8_vbm_estwr(fdp,para)
%FORMAT px_spm8_vbm_estwr(fdp,para)
%  Input
%   fdp.scan     - full path of input t1 NIfTI data
%   para.clean   - Clean up any partitions
%                   - 0, Dont do cleanup;
%                   - 1, Light Clean; <DEFAULT>
%                   - 2, Thorough Clean;
%   para.regtype - Affine regularisation
%                   - '', No affine registration;
%                   - 'mni', ICBM space template - European brains;
%                   - 'eastern', ICBM space template - East Asian brains; <DEFAULT>
%                   - 'subj', Average sized template;
%                   - 'none', No regularisation.
%   para.op      - Output path for batch. <default = fdp.scan{1}>
%  Pengfei Xu, 2013/08/26, QC,CUNY.
%==========================================================================

% check input
if nargin == 1; para = [];end
if ~isfield(para,'clean'); para.clean = 1;end
if ~isfield(para,'regtype'); para.regtype = 'eastern';end
if ~isfield(para,'op');
    try
        para.op = fileparts(fdp.scan{1});
    catch
        para.op = fileparts(fdp.scan{1,1}{1});
    end
end
% batch
matlabbatch{1}.spm.tools.vbm8.estwrite.data = fdp.scan;% cellformat
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.tpm = {fullfile(spm('dir','TPM.nii'),'TPM.nii')};%{'/Volumes/Data/Tool/matlab_toolbox/spm8/toolbox/Seg/TPM.nii'};
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.affreg = para.regtype;%
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{1}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.dartelwarp.normhigh.darteltpm =  {fullfile(spm('dir','Template_1_IXI550_MNI152.nii'),'Template_1_IXI550_MNI152.nii')};%{'/Volumes/Data/Tool/matlab_toolbox/spm8/toolbox/vbm8/Template_1_IXI550_MNI152.nii'};
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.sanlm = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.mrf = 0.15;
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.cleanup = para.clean;%
matlabbatch{1}.spm.tools.vbm8.estwrite.extopts.print = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.modulated = 2;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.modulated = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.native = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.vbm8.estwrite.output.warps = [0 0];
save (fullfile(para.op,'matlabbatch_vbm_estwr'), 'matlabbatch');
% run
spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);
end