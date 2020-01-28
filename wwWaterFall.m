% wwWaterFall(taxonomy, testData, testCodes, trainData, trainCodes, exclusionList)
% Developed by Jason Foster jf727@nau.edu, Jan 2020.
% This function takes in the filename for the taxonomy, and test/training
% data and codes and creates all of the trees for the analysis. We also
% include an exclusion list which is a text file containing codes that we
% can remove for being incorrect. The exclusion list will simply be a text
% file where each line contains a code to remove if incorrectly labeled
% The taxonomy should be a txt file ordered in the following format,
% Code:PATH1,PATH2....
% Code is the alphanumeric (please no weird symbols) code like 2 4 EM ....
% : just is a delimiter that say everything after are possible paths
% PATH1, PATH2, .... PATH1 is the next possible alphanumeric code, PATH2
% being the second possible path. If there is no further paths then this
% field will simply be NULL.
% the data and codes should already be genreated and saved as .mat files,
% create a string containing the path to that file so that my function can
% load it. Here I assume test is the 20% of data and train is the 80% data.
% to call this fuction try wwWaterFall("tax.txt", "/TEST/testData.mat",
% "/TEST/testDataCodes.mat", ...., ....)
function wwWaterFall(taxonomy, testData, testCodes, trainData, trainCodes, slurmCodes, exclusionList)
% First we need to load in the taxonomy
taxonomyID = fopen(taxonomy,'r');
slurmID = fopen(slurmCodes, 'r');
exclusionID = fopen(exclusionList);
% if done properly, textscan will load in the taxonomy in a 1x1 cell array,
% inside the 1x1 should be a Nx1 cell array containing the taxonomy as seen
% in the txt file
taxonomyCellArray = textscan(taxonomyID, '%s');
slurmCellArray = textscan(slurmID, '%s');
exclusionCellArray = textscan(exclusionID, '%s');
% pull the Nx1 array out of the 1x1
taxonomyCellArray = taxonomyCellArray{1};
slurmCellArray = slurmCellArray{1};
exclusionCellArray = exclusionCellArray{1};
exclusionArray = nan(1,length(exclusionCellArray));
exclusionArray = string(exclusionArray);
for i = 1:length(exclusionCellArray)
    exclusionArray(i) = string(exclusionCellArray{i});
end
% How many models are we going to make? Well, it seems that the amount of
% models is equal to the number of paths. Draw it out and you'll see what I
% mean.
number_Of_Models = 0;
for i = 1:length(taxonomyCellArray)
    % pull the i line out of the txt file
    line = taxonomyCellArray{i};
    % seperate out the paths from this line
    codePath = strsplit(line, ':');
    % now lets get only the PATH1, PATH2, ...
    paths = codePath{2};
    % This split will tell me how many paths exist
    pathArray = strsplit(paths,',');
    % Add those paths to the running count
    % oh, if the path is NULL we shouldnt count it
    if string(pathArray{1}) ~= "NULL"
        number_Of_Models = number_Of_Models + length(pathArray);
    end
end
intermediateCellArray = cell(number_Of_Models,3);
line = taxonomyCellArray{1};
codePath = strsplit(line, ':');
intermediateCellArray{1,1} = codePath{1};
load(trainData, 'TrainData')
load(trainCodes, 'TrainCodes')
TrainCodes = double(string(TrainCodes));
intermediateCellArray{1,2} = TrainData;
intermediateCellArray{1,3} = TrainCodes;
intermediateIndex = 2;
% DISCLAMER
% My code assumes that the Taxonomy has a code shared by all, if thats not
% the case then just add a code (START)(the rest of your code) to the start
% of your codes.
% Lets begin the waterfall, we will read the start of the taxonomy and
% traverse each path. Generating intermediate models as we go until we hit
% the end.
for i = 1:length(taxonomyCellArray)
    % load the data
    load(testData, 'TestData')
    load(testCodes, 'TestCodes')
    TestCodes = double(string(TestCodes));
    % The data can be loaded in just fine, but the codes need an extra column
    % added, such that they can have their original tag and any new tags.
    TestCodes = [TestCodes, TestCodes];
    TestCodes = string(TestCodes);
    % load the ith line of the taxonomy
    line = taxonomyCellArray{i};
    % seperate out the paths from this line
    codePath = strsplit(line, ':');
    % seperate out the code
    code = codePath{1};
    % now lets get only the PATH1, PATH2, ...
    paths = codePath{2};
    % This split will tell me how many paths exist
    pathArray = strsplit(paths,',');
    % if the path is NULL we have nowhere to go
    if string(pathArray{1}) == "NULL"
        continue
    end
    for j = 1:number_Of_Models
        if string(intermediateCellArray{j}) == string(code)
            TrainData = intermediateCellArray{j,2};
            TrainData = [TrainData, ones(length(TrainData),1)];
            TrainCodes = intermediateCellArray{j,3};
            TrainCodes = [TrainCodes, TrainCodes, ones(length(TrainCodes),1)];
            TrainCodes = string(TrainCodes);
            break
        end
    end
    % if the path is not null then we need to build our code and any other
    % branches, EX: the first node is 1 and we branch into 2 or 3, so we
    % need to make 12 and 13 and use these for relabling.
    % for each possible path
    % To prevent a code from being counted more than once
    TestCodes(:,2) = "";
    TrainCodes(:,2) = "";
    for j = 1:length(pathArray)
        currentNode = {code, pathArray{j}};
        % find all rebinable codes and relable them
        for k = 1:2:length(slurmCellArray)
            if ismember([currentNode{1}, currentNode{2}], slurmCellArray{k})
                code_To_Swap = str2num(slurmCellArray{k+1});
                for l = 1:length(TestCodes)
                    if TestCodes(l,1) == string(code_To_Swap)
                        TestCodes(l,2) = string(currentNode{2});
                    end
                end
                for l = 1:length(TrainCodes)
                    if TrainCodes(l,1) == string(code_To_Swap)
                        TrainCodes(l,2) = string(currentNode{2});
                    end
                end
            end
        end
    end
    % Remove non relevant entries
    RelevantTestCodes = nan(length(TestCodes), 2);
    RelevantTrainCodes = nan(length(TrainCodes), 2);
    RelevantTrainCodes = [RelevantTrainCodes, ones(length(RelevantTrainCodes),1)];
    RelevantTestCodes = string(RelevantTestCodes);
    RelevantTrainCodes = string(RelevantTrainCodes);
    for j = 1:length(TestCodes)
        if TestCodes(j,2) ~= ""
            RelevantTestCodes(j,:) = TestCodes(j,:);
        else
            TestData(j,:) = nan;
        end
    end
    for j = 1:length(TrainCodes)
        if TrainCodes(j,2) ~= ""
            RelevantTrainCodes(j,:) = TrainCodes(j,:);
        else
            TrainData(j,:) = nan;
        end
    end
    RelevantTestCodes = rmmissing(RelevantTestCodes);
    RelevantTrainCodes = rmmissing(RelevantTrainCodes);
    TestData = rmmissing(TestData);
    TrainData = rmmissing(TrainData);
    % now generate a new model and see how it fares
    model = fitctree(TestData, char(RelevantTestCodes(:,2)));
    pred = predict(model, TrainData(:,1:end-1));
    Nodes = unique(pathArray);
    for j = 1:length(Nodes)
        RelevantTrainCodes(:,3) = "1";
        TrainData(:,end) = 1;
        correct = 0;
        total = 0;
        for k = 1:length(pred)
            if strtrim(string(pred(k,:))) == RelevantTrainCodes(k,2) && strtrim(string(pred(k,:))) == string(Nodes{j})
                correct = correct + 1;
            end
            if RelevantTrainCodes(k,2) == string(Nodes{j})
                total = total + 1;
                if ismember(string(Nodes{j}), exclusionArray) && strtrim(string(pred(k,:))) ~= RelevantTrainCodes(k,2)
                    RelevantTrainCodes(k,3) = nan;
                    TrainData(k,end) = nan;
                end
            else
                RelevantTrainCodes(k,3) = nan;
                TrainData(k,end) = nan;
            end
        end
        disp("Correct categorization of code " + string(Nodes{j}) + " was " + num2str(correct) + " out of " + total + " for a success rate of " + num2str(correct/total * 100) + "%")
        intermediateCellArray{intermediateIndex,1} = Nodes{j};
        TD = rmmissing(TrainData);
        TC = rmmissing(RelevantTrainCodes);
        intermediateCellArray{intermediateIndex,2} = TD(:,1:end-1);
        intermediateCellArray{intermediateIndex,3} = TC(:,1:1);
        intermediateIndex = intermediateIndex + 1;
    end
end
fclose('all');
end