function px_fsl_4D (fdp,para)

if ~isfield(para,'on');
    error('\nNeed output name for the 4D file.');
end
if isfield(para,'op');
    dp = op;
else
    dp = fileparts(fdp(1,:));
end
ofile = fullfile(dp,para.on);
% spm_file_merge(fdp,ofile);
files = [];
for nf = 1:size(fdp,1)
    files = [files ' ' fdp(nf,:)];
end
cmd = ['fslmerge -t ' ofile ' ' files];
fprintf('%s\n',cmd);
system(cmd);
%% change NIFTI_GZ TO NIFTI
ofile_gz = [ofile '.gz'];
ofile_ot = ofile(1:end-3); %% .nii.gz >> .nii
cmd = ['fslchfiletype NIFTI ' ofile_gz ' ' ofile_ot];
% fprintf('%s\n',cmd);
system(cmd);
delete(ofile_gz);