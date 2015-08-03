threshold = 0.5;

h = figure;
for r = 1:length(rpfiles)
    
    R = load(rpfiles{r}); %rpfiles  = spm_select('FPListRec',pwd, '^rp_.*.txt')
    
    translation = R(:,1:3);
    rotation    = R(:,4:6);
    C = sqrt(sum(rotation.^2,2))
    dsigma = 2* asind(C/2)
    d = 50 * dsigma;
    
    norm_translation = sum(translation.^2,2);
    FD = sqrt(norm_translation + d);

    subplot(321)
    plot(translation);
    subplot(322)
    plot(norm_translation)
    subplot(323);
    plot(rotation)
    subplot(324);
    plot(d);
    subplot(325)
    plot(FD)
    
    
    
    kick_out_volumes = find(FD > threshold);
    plot(FD);
    title(rpfiles{r});
    
    file_out = '/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/'

    [folder file ext] = fileparts(rpfiles{r});
    [folder session] = fileparts(folder);
    [tmp subject] = fileparts(folder);

    file_out = ['/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/' subject '_' session '.jpg'];
    outliers_file = ['/data/local_share/huiai/Documents/NESDA/Longitudinal/check_realign_figure/FD/' subject '_' session '.mat'];
    save(outliers_file, 'kick_out_volumes');
    print(h,'-djpeg', file_out);
    
end

    