clear
clc
path = '/data/tool/dataprocess';
ROI = load(fullfile(path,'MNI_Coordinates_264.txt'));
D = [];
for r = 1: length(ROI)
    D(r,:) = gretna_pdist2 (ROI(r,:),ROI);
end
nonzero = find(D ~= 0);
min(D(nonzero))