function px_fsl_bet(fdp,para)
% FORMAT function px_fsl_bet(fdp,para)
%  Input
%  fdp.scan - full path of the image files from one t1/run of one subject, char array;
%  para.on  - output name of the extracted brain file.
%  para.opt   - fractional intensity threshold;
%  para.vt  - volume type
%             - 0, 3D volumes;
%             - 1, 3D to 4D;
% Pengfei Xu, 10/13/2013, QC, CUNY
%%%%%%%%%%%%%%%%%%%%

%
ifile = fdp.scan;
dp = fileparts(fdp.scan(1,:));
ofile = fullfile(dp,para.on);
% if para.vt == 1
%     ofile_tmp = ['tmp_', para.on];
%     %     spm_file_merge(ifile,ofile_tmp)  % cmd = ['fslmerge -t ' on ' ' fdp.scan]
%     files = [];
%     for nf = 1:size(fdp,1)
%         files = [files ' ' ifile(nf,:)];
%     end
%     cmd = ['fslmerge -t ' ofile_tmp ' ' files];
%     display(cmd);
%     system(cmd);
%     ifile = fullfile(dp,ofile_tmp);
% end

cmd = cat(2, 'bet ', ifile, ' ', ofile, ' ',para.opt);
fprintf('%s\n',cmd);
[status,results] = system(cmd);
if status == 1;    
    warning(results);
    fprintf('\n');
    fprintf('Please try to run the above command in the terminal.\n');
    f = warndlg('Press OK after done.', ' Wait...');
    drawnow     % Necessary to print the message
    waitfor(f);
end
%% change NIFTI_GZ TO NIFTI
ofile_gz = dir(fullfile(dp, '*.gz'));
for ngz = 1: length(ofile_gz )
    fn  = fullfile(dp,ofile_gz(ngz).name);
    cmd = ['fslchfiletype NIFTI ' fn];
    system(cmd);
    if exist(fn,'file')
        delete(fullfile(dp,ofile_gz(ngz).name));
    end
end
%%
% if para.vt == 1;
%     spm_file_split(ofile); % also fslsplit
%     % delete the intermediate files;
%     [~,ofile_tmp_mat] = fileparts(ofile_tmp);
%     ofile_tmp_mat = fullfile(dp,[ofile_tmp_mat '.mat']);
%     delete(ofile_tmp_mat);
%     ofile_tmp = fullfile(dp,ofile_tmp);
%     if exist(ofile_tmp,'file');
%         delete(ofile_tmp);
%     end
%     delete(ofile);
% end