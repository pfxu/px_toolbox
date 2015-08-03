
function ROIs_Merge(ROIs_Cell, ResultantFile)

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

All_ROIs = [];

for i = 1:length(ROIs_Cell)
    
    tmp = load(ROIs_Cell{i});
    if ~isempty(tmp.Sphere_ROI)
        All_ROIs = [All_ROIs tmp.Sphere_ROI]; 
    end
    
end

save(ResultantFile, 'All_ROIs');

