% %filter SCR
% clear all
% clc
% pathraw='/Volumes/Data/data/rsfMRI/07_0699/SCR/';
% pathnew='/Volumes/Data/data/rsfMRI/07_0699/SCR/SCRRaw/';
% mkdir(pathnew);
% TR=2.5;
% band=[0.01 0.08];
% SCR =  load([pathraw,'SCR_DATA.txt',]);
% %function wave=filter_px(TR,BAND,CellFile)
% SampleRate=1/TR;
% Fs=SampleRate;
% 
% N=128;
% [b, a]=butter(5, band/(Fs/2));
% [H, f]=freqz(b, a, N, Fs);
% %figure;
% %plot(f, abs(H));
% %title('Filter property');
% for i=1:size(SCR_DATA,1)
%     CellFile=SCR_DATA(i,:);
%     CellFile_fil=detrend(CellFile);
%     SCR(i,:)=filtfilt(b,a,CellFile_fil);
% end
% 
% save ([pathnew,'SCRFilter'], 'SCR')
% for pre='1'
%     for i=[1:11,13:19];
%         subj=SCR(i,:);
%         save([pathnew,pre,num2str(i,'%03.0f'),'.txt'],'subj','-ASCII', '-DOUBLE','-TABS');
%     end
% end
% for pre='2'
%     for i=[1,3:7,10:19];
%         j=i+19;
%         subj=SCR(j,:);
%         save([pathnew,pre,num2str(i,'%03.0f'),'.txt'],'subj','-ASCII', '-DOUBLE','-TABS');
%     end
% end

clear
clc
pathraw = '/Volumes/Data/data/rsfMRI/07_0699/SCR/';
pathnew = '/Volumes/Data/data/rsfMRI/07_0699/SCR/SCRFilter0119/';
mkdir(pathnew);
file = 'SCR_DATA.txt';
SCR = px_filter(2.5,[0.01 0.19],[pathraw,file],pathraw,'SCRFilter0119');
for pre='2'
    for i=[1,3:7,10:19];
        j=i+19;
        subj=SCR(j,:)';
        save([pathnew,pre,num2str(i,'%03.0f'),'.txt'],'subj','-ASCII', '-DOUBLE','-TABS');
    end
end