%Developed by Jason Foster jf727@nau.edu Feb 2020
%This function takes in stuff
%this function returns graphs
function wwTestSpecificParticipant(Big_Matrix)
    diary conf_mat;
    diary off;
    %regenerate the original predicted model
    %test is 20% train is 80%
    right_indexes = find(Big_Matrix(:,end) == 0);
    left_indexes = find(Big_Matrix(:,end) == 1);
    right_matrix = Big_Matrix(right_indexes,:);
    left_matrix = Big_Matrix(left_indexes,:);
    right20 = ceil(length(right_indexes)*.2);
    left20 = ceil(length(left_indexes)*.2);
    rightTestIndexes = randperm(length(right_indexes), right20);
    leftTestIndexes = randperm(length(left_indexes), left20);
    right_test_matrix = right_matrix(rightTestIndexes,:);
    left_test_matrix = left_matrix(leftTestIndexes,:);
    right_model = fitctree(right_matrix(:,1:end-6), char(string(right_matrix(:,end-2))));
    left_model = fitctree(left_matrix(:,1:end-6), char(string(left_matrix(:,end-2))));
    % How many participants do I have?
    participant_list = unique(Big_Matrix(:,end-1));
    % for each participant, seperate out their data, split by hand and run
    % them through the generated models for the full dataset
    for i = 1:length(participant_list)
        relevant_indexes = find(Big_Matrix(:,end-1) == participant_list(i));
        participant_matrix = Big_Matrix(relevant_indexes(1):relevant_indexes(end),:);
        left_part_indexes = find(participant_matrix(:,end) == 1);
        right_part_indexes = find(participant_matrix(:,end) == 0);
        left_leftpart_matrix = participant_matrix(left_part_indexes,:);
        right_rightpart_matrix = participant_matrix(right_part_indexes,:);
        left_leftpred_matrix = predict(left_model, left_leftpart_matrix(:,1:end-6));
        right_rightpred_matrix = predict(right_model, right_rightpart_matrix(:,1:end-6));
        % now call wwGraphSpecificCode for plots
        left_leftpred_matrix = [left_leftpart_matrix(:,1:end-3), double(string(left_leftpred_matrix)), left_leftpart_matrix(:,end-1:end)];
        right_rightpred_matrix = [right_rightpart_matrix(:,1:end-3), double(string(right_rightpred_matrix)), right_rightpart_matrix(:,end-1:end)];
        wwGraphSpecificCode(left_leftpred_matrix, left_leftpart_matrix, 1:120)
        wwGraphSpecificCode(right_rightpred_matrix, right_rightpart_matrix, 1:120);
        % now lets generate a full conf matrix 
        %diary on;
        participant_list(i)
        confusionmatrix(left_leftpred_matrix(:,end-2), left_leftpart_matrix(:,end-2), '%', [], 5)
        confusionmatrix(right_rightpred_matrix(:,end-2), right_rightpart_matrix(:,end-2), '%', [], 5)
        %diary off;
    end
end