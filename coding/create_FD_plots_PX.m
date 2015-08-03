clear all
threshold = 0.5;
clear rpfiles R
cwd = '/data/local_share/huiai/Documents/NESDA/L1_scan/';
rpfiles  = spm_select('FPListRec',pwd, '^rp_.*.txt')

for r = 1:length(rpfiles)
    h = figure;
    clear R
    R = load(rpfiles{r}); %rpfiles  = spm_select('FPListRec',pwd, '^rp_.*.txt')
    
    
    translation = R(:,1:3);
    rotation    = R(:,4:6) .* 50; %% multiplied with 50mm
    total = [translation rotation];
    FD = sqrt(sum(diff(total).^2,2))
    
    
    
    
    plot(FD);
    minFD = min(FD);
    maxFD = max(FD);
    kick_out_volumes = find(FD(2:end) > threshold);
    
    hold on;
    for i = 1:length(kick_out_volumes)
        
        kov = kick_out_volumes(i);
        
        l= line([kov kov], [minFD, maxFD]);
        set(l, 'Color', [1 0 0], 'LineWidth', 1);
        
    end
    
     
    title(rpfiles{r},'Interpreter', 'none');
    
    file_out = pwd;'/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/'

    [folder file ext] = fileparts(rpfiles{r});
    [folder session] = fileparts(folder);
    [tmp subject] = fileparts(folder);

%     file_out = ['/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/' subject '_' session '.jpg'];
%     outliers_file = ['/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/' subject '_' session '.mat'];
    
    file_out = [pwd subject '_' session '.jpg'];
    outliers_file = [pwd subject '_' session '.mat'];
    
    save(outliers_file, 'kick_out_volumes');
    print(h,'-djpeg', file_out);
    close(h);
end

    