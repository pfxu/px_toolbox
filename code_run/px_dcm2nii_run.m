clear all
clc

ip = '/Volumes/Data/PX/Lesion/Repeat/fMRI/DataReady';
op = '/Volumes/Data/PX/Lesion/Rest/DataAnalysis';
protocol = {'Rest','t1','t2'};
group = {'1','2'};

for t = 2: length(protocol)
    for g = 1:length(group)
        if t ==1 ; vector = {1:14;1:28};elseif t == 2; vector = {[1:6,8:14];1:28};elseif t == 3; vector = {[1:6,8:14];[1:6,8:28]}; end%
        for sub = vector{g}
            subj = fullfile(ip, protocol{t},[group{g}, num2str(sub,'%03.0f')]);
            dirout = fullfile(op, protocol{t},[group{g}, num2str(sub,'%03.0f')]);
            dcmlist = px_ls('Rec',subj,'-F');
            in = dcmlist{1};
            type = 'nii';
            px_dcm2nii(in,dirout,type)
        end
    end
end