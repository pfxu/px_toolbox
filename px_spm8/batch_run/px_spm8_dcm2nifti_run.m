dirin = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataReady\ANT-R';
dirout= 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataAnalysis\ANT-R';
% dirin = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataReady\GNT';
% dirout= 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataAnalysis\GNT';
% dirin = 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataReady\t1';
% dirout= 'I:\DataAnalysis\Runing\AnxietyModel\fMRI\DataAnalysis\t1';
vector = 9;
prename = '1';
for i = vector
        runlist = px_ls(fullfile(dirin,[prename num2str(i,'%03.0f')]),'-D',1);
    n = 0;
    for j = 1: length(runlist)
        if ~isempty(regexp(runlist{j},'t1_mprage','match'))
            pathout = fullfile(dirout,[prename num2str(i,'%03.0f')],'t1');
            if ~exist(pathout,'dir'); mkdir(pathout);end
        elseif ~isempty(regexp(runlist{j},'func','match'))
            n = n+1;
            pathout = fullfile(dirout,[prename num2str(i,'%03.0f')],...
                ['run' num2str(n,'%03.0f')]);
            if ~exist(pathout,'dir'); mkdir(pathout);end
        end
        pathin = runlist{j};
        px_spm8_dcm2nifti(pathin,pathout);
    end
end