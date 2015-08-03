function [Accuracy Sensitivity Specificity W_vector] = SVM_2group_ForSL(Subjects_Data, Subjects_Label, Pre_Method)

%
% Subject_Data:
%           m*n matrix
%           m is the number of subjects
%           n is the number of features
%
% Subject_Label:
%           array of 0 or 1
%
% Pre_Method:
%           'Normalize' or 'Scale'
%

%
% Written by Zaixu Cui, State Key Laboratory of Cognitive 
% Neuroscience and Learning, Beijing Normal University, 2013.
% Maintainer: zaixucui@gmail.com
%

[Subjects_Quantity Feature_Quantity] = size(Subjects_Data);

W_vector = zeros(1, Feature_Quantity);
for i = 1:Subjects_Quantity
    
    disp(['The ' num2str(i) ' iteration!']);
    
    Subjects_Data_tmp = Subjects_Data;
    Subjects_Label_tmp = Subjects_Label;
    % Select training data and testing data
    test_label = Subjects_Label_tmp(i);
    test_data = Subjects_Data_tmp(i, :);
    
    Subjects_Label_tmp(i) = [];
    Subjects_Data_tmp(i, :) = [];
    Training_group1_Index = find(Subjects_Label_tmp == 1);
    Training_group0_Index = find(Subjects_Label_tmp == -1);
    Training_group1_data = Subjects_Data_tmp(Training_group1_Index, :);
    Training_group0_data = Subjects_Data_tmp(Training_group0_Index, :);
    Training_group1_Label = Subjects_Label_tmp(Training_group1_Index);
    Training_group0_Label = Subjects_Label_tmp(Training_group0_Index);
    
    Training_all_data = [Training_group1_data; Training_group0_data];
    Label = [Training_group1_Label Training_group0_Label];

    if strcmp(Pre_Method, 'Normalize')
        %Normalizing
        MeanValue = mean(Training_all_data);
        StandardDeviation = std(Training_all_data);
        [~, columns_quantity] = size(Training_all_data);
        for j = 1:columns_quantity
            Training_all_data(:, j) = (Training_all_data(:, j) - MeanValue(j)) / StandardDeviation(j);
        end
    elseif strcmp(Pre_Method, 'Scale')
        % Scaling to [0 1]
        MinValue = min(Training_all_data);
        MaxValue = max(Training_all_data);
        [~, columns_quantity] = size(Training_all_data);
        for j = 1:columns_quantity
            Training_all_data(:, j) = (Training_all_data(:, j) - MinValue(j)) / (MaxValue(j) - MinValue(j));
        end
    end

    % SVM classification
    Label = reshape(Label, length(Label), 1);
    Training_all_data = double(Training_all_data);
    model(i) = svmtrain(Label, Training_all_data,'-t 0');

    if strcmp(Pre_Method, 'Normalize')
        % Normalizing
        test_data = (test_data - MeanValue) ./ StandardDeviation;
    elseif strcmp(Pre_Method, 'Scale')
        % Scale
        test_data = (test_data - MinValue) ./ (MaxValue - MinValue);
    end

    % predicts
    test_data = double(test_data);
    [predicted_labels(i), ~, ~] = svmpredict(test_label, test_data, model(i));
    
    w{i} = zeros(1, Feature_Quantity);
    for j = 1 : model(i).totalSV
        w{i} = w{i} + model(i).sv_coef(j) * model(i).SVs(j, :);
    end
    W_vector = W_vector + w{i};
    
end

W_vector = W_vector / Subjects_Quantity;

Group1_Index = find(Subjects_Label == 1);
Group0_Index = find(Subjects_Label == -1);
Category_group1 = predicted_labels(Group1_Index);
Category_group0 = predicted_labels(Group0_Index);

Group1_Quantity = length(Group1_Index);
Group0_Quantity = length(Group0_Index);

Group1_Wrong_ID = find(Category_group1 == -1);
Group1_Wrong_Quantity = length(Group1_Wrong_ID);
Group0_Wrong_ID = find(Category_group0 == 1);
Group0_Wrong_Quantity = length(Group0_Wrong_ID);

Accuracy = (Subjects_Quantity - Group0_Wrong_Quantity - Group1_Wrong_Quantity) / Subjects_Quantity;
Sensitivity = (Group1_Quantity - Group1_Wrong_Quantity) / Group1_Quantity;
Specificity = (Group0_Quantity - Group0_Wrong_Quantity) / Group0_Quantity;
