function px_check_normalise(fdp,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_check_normalise(fdp,op)
%  Input
%   fdp - fullfile path of normalised image;
%   para.op  - out put path for the pictures.
%   para.id  - subject ID in according to the fdp list.
% Pengfei Xu, based on DPARSF, 12/30/2014, @UMCG
%--------------------------------------------------------------------------
cd(para.op);

if license('test','image_toolbox') % Added by YAN Chao-Gan, 100420.
    global DPARSF_rest_sliceviewer_Cfg;
    h=DPARSF_rest_sliceviewer;
    [RESTPath, fileN, extn] = fileparts(which('rest.m'));
    Ch2Filename=[RESTPath,filesep,'Template',filesep,'ch2.nii'];
    set(DPARSF_rest_sliceviewer_Cfg.Config(1).hOverlayFile, 'String', Ch2Filename);
    DPARSF_rest_sliceviewer_Cfg.Config(1).Overlay.Opacity = 0.2;
    DPARSF_rest_sliceviewer('ChangeOverlay', h);
    for i = 1:length(fdp)
        Filename = fdp{i};        
        DPARSF_Normalized_TempImage =fullfile(tempdir,['DPARSF_Normalized_TempImage','_',rest_misc('GetCurrentUser'),'.img']);
        y_Reslice(Filename,DPARSF_Normalized_TempImage,[1 1 1],0);
        set(DPARSF_rest_sliceviewer_Cfg.Config(1).hUnderlayFile, 'String', DPARSF_Normalized_TempImage);
        set(DPARSF_rest_sliceviewer_Cfg.Config(1).hMagnify ,'Value',2);
        DPARSF_rest_sliceviewer('ChangeUnderlayFile', h);
        eval(['print(''-dtiff'',''-r100'',''',para.id{i},'.tif'',h);']);
        fprintf(['Generating the pictures for checking normalization: ',para.id{i},' OK\n']);
    end
    close(h);
    fprintf('\n');
else
    fprintf('Since Image Processing Toolbox of MATLAB is not valid, the pictures for checking normalization will not be generated.\n');
    fid = fopen('Warning.txt','at+');
    fprintf(fid,'%s','Since Image Processing Toolbox of MATLAB is not valid, the pictures for checking normalization will not be generated.\n');
    fclose(fid);
end