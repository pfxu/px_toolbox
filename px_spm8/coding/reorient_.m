%Script to batch reorient functionals after determining correct
%reorientation coordinates by comparing T1 canonical and subject's
%anatomicals.
%
%Step1: Determine coordinates to align subject's anatomical with the
%templace (canonical single-subject T1). Needs to be done individually for
%each subject; record coordinates below. 
%Step2: Use the function spm_matrix to turn those coordinates into the
%affine matrix that is needed by the batch processing script.
%Step3: Apply that reorientation matrix to the functionals using
%matlabbatch.
%Hanah Chapman 2011

%Directory locations.
    %This script expects all your subject directories to be collected
    %in one root directory (allsubsdir), then within each subject directory
    %there is a functionals directory (functionalsdir), and within that are run
    %directories (rundirs), and within your rundirs is a file with your
    %imported dicoms (f files). 
    allsubsdir = 'C:\Documents and Settings\hanah\research\spm8_practice\first_level'; % what directory are all your subjects in
    anatomicalsdir = 'anatomical'; % what directory are your anatomicals in
    functionalsdir = 'functional'; % what directory are your functionals in
    rundirs = {'SPP_1','SPP_2'}; % 'SPP_1','SPP_2'   %list of directories that your runs are in
    importedfunctionalsdir = {'f_files'}; % what directory are your imported functionals in (i.e. f files)

%REORIENTATION COORDINATES
%We're going to create an array of structures that contains the
%reorientation coordinates for each subject. The template for each
%structure is this:
%   coordslist(1).subject = 'CON2676'        %As given in subjdirs
%   coordslist(1).coordinates = spm_matrix([x y z pitch roll yaw xscaling
%                                           yscaling zscaling xaffine
%                                           yaffine zaffine])
% x,y,z,pitch,roll,yaw correspond to the coordinates you enter in the
% "Display" window. Xscaling, yscaling and zscaling will usually be 1, and
% xaffine, yaffine, and zaffine will be 0.
% So: Go through your subjects and fill out the array below with the
% subject names and the coordinates needed.
%   Why the spm_matrix function?
%       The batch interface for reorientation requires an "affine
%       transformation matrix" (can't say I know what that is), rather than
%       the xyz coordinates we're used to. spm_matrix takes your regular
%       coordinates and spits out the desired affine transformation matrix,
%       which can then be fed to the batch processor. 

coordslist(1).subject = 'CON2767';
coordslist(1).coordinates = spm_matrix([0 -30 -15 0.209 0 0 1 1 1]);

coordslist(2).subject = 'CON2768';
coordslist(2).coordinates = spm_matrix([0 -30 -15 0.209 0 0 1 1 1]);

subjectslist = {coordslist(:).subject};     %Get a list with all of your subject names


%CREATE AND RUN REORIENTATION BATCHES

for currentsub = 1:numel(subjectslist); %Loop over subjects
    for currentrun = 1:numel(rundirs);  %Loop over functional runs
        
        currentsubfuncdir = cell2mat([allsubsdir,filesep,subjectslist(currentsub),filesep,functionalsdir,filesep,rundirs(currentrun),filesep,importedfunctionalsdir]);
        cd (currentsubfuncdir);
        
        %Get the full path to all of the f*.img files in this directory and put this info in a cell array
        %called ffilecells
        clear ffilestruct % Clear the existing ffilestruct structure; this is important in case some of your runs have different lengths
        ffilestruct = dir('f*.img');    

        if length(ffilestruct) == 0     %This is here in case the script doesn't find the f files
            disp('Problem with finding f files; aborting preprocess batch')
            return
        end
        
        clear ffilecells %Clear the ffilecells array before filling it in again           

        for i = 1:numel(ffilestruct);
            ffilecells{i} = [fullpath(ffilestruct(i).name) ',1']; %For some reason spm needs the ',1' at the end
        end
        
        
        clear matlabbatch
        matlabbatch{1}.spm.util.reorient.srcfiles = ffilecells; %subject's anatomicals here
        matlabbatch{1}.spm.util.reorient.transform.transM = coordslist(currentsub).coordinates; %subject's coordinates here (need the affine matrix) 
        matlabbatch{1}.spm.util.reorient.prefix = '';
        
        
        %Save the batch file (e.g. CON2988_2011-03-10_preprocess_batch )
        batchfilename = strcat(char(subjectslist(currentsub)),'_',char(rundirs(currentrun)),'_',datestr(now,29),'_reorient_batch');
        save(batchfilename,'matlabbatch');

        %Run the spm preprocessing steps
        spm_jobman('run',matlabbatch)
        
        
    end     %Close runs loop
end     %Close subjects loop

    
   
%SANITY CHECKING
%If you want to make sure this is running correctly, use the debugger to step
%through some of the loops and inspect these variables along the way:
% disp(subjectslist(currentsub))
% disp(rundirs(currentrun))
% disp(matlabbatch{1}.spm.util.reorient.srcfiles{1})
% disp(matlabbatch{1}.spm.util.reorient.srcfiles{end})