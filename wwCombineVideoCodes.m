function [Combined_Codes] = wwCombineVideoCodes(fname, type)
% Developed by Jason Foster jf727@nau.edu, November 2018.
% This function take a folder name where all the video code files are.
% This function then attempts to make a person ID for each seperate folder
% that exists with video codes data.
% To call this function use:
% Combined_Codes = wwCombineVideoCodes(foldername);
% Also, this function assumes that a folder with video codes doesn't have
% more folders in it. I.E, that the data is organized where the top level 
% folder contains folders for all the subjects but in the subject folder
% there are NO subfolders. If this is not the case you probably won't be
% pleased with the output.

Combined_Codes = struct('Start_Time', [], 'End_Time', [], 'Code', {},...
    'Notes', {}, 'Subject_ID', [], 'Hand', [], 'Start_Time_Index',...
    [], 'End_Time_Index', []);

% Assuming that fname is a folder containg our subject folders we should go
% into fname and create a list of all the subject folders to process.

Subject_Folders = dir(fname);
num_of_folders = length(Subject_Folders);
% For each folder try to call SearchOneFolder
for folder_number = 1:num_of_folders
    % Skip the go back folder
    if strcmpi(Subject_Folders(folder_number,1).name(1), '.') == 1
           % do nothing! 
    elseif Subject_Folders(folder_number,1).isdir == 1
        folder_name = strcat(Subject_Folders(folder_number,1).folder,'\',Subject_Folders(folder_number,1).name);
        Subject_Codes = SearchOneFolder(folder_name, Subject_Folders(folder_number,1).name, type);
        % Just In case we dont have enough files to make a new one
        if isempty(Subject_Codes)
            continue
        end
        if isempty(Combined_Codes)
            Combined_Codes(1).Hand = 'l';
            Combined_Codes(1).Start_Time = Subject_Codes.Start_Time;
            Combined_Codes(1).End_Time = Subject_Codes.End_Time;
            Combined_Codes(1).Code = Subject_Codes.Code;
            Combined_Codes(1).Notes = Subject_Codes.Notes;
            Combined_Codes(1).Subject_ID = Subject_Codes.Subject_ID;
            Combined_Codes(1).Start_Time_Index = Subject_Codes.Start_Time_Index;
            Combined_Codes(1).End_Time_Index = Subject_Codes.End_Time_Index;
            Combined_Codes(1).Hand = Subject_Codes.Hand;
        else
            Combined_Codes(length(Combined_Codes)+1).Start_Time = Subject_Codes.Start_Time;
            Combined_Codes(length(Combined_Codes)).End_Time = Subject_Codes.End_Time;
            Combined_Codes(length(Combined_Codes)).Code = Subject_Codes.Code;
            Combined_Codes(length(Combined_Codes)).Notes = Subject_Codes.Notes;
            Combined_Codes(length(Combined_Codes)).Subject_ID = Subject_Codes.Subject_ID;
            Combined_Codes(length(Combined_Codes)).Start_Time_Index = Subject_Codes.Start_Time_Index;
            Combined_Codes(length(Combined_Codes)).End_Time_Index = Subject_Codes.End_Time_Index;
            Combined_Codes(length(Combined_Codes)).Hand = Subject_Codes.Hand;
        end
    else
        % do nothing!
    end
end

% Lets remove all the empty stuff

nonempty_index = [];
for index = 1:length(Combined_Codes)
if ~isempty(Combined_Codes(index).Start_Time)
nonempty_index = [nonempty_index; index];
end
Combined_Codes(index).Subject_ID = Combined_Codes(index).Subject_ID{1};
end
Combined_Codes = Combined_Codes(nonempty_index);
end

function [Subject_Codes] = SearchOneFolder(fname, Subject_ID, type)
% This function will take one folder that contains video code files and 
% if we have less than 3 code files we will return a value of NaN.
% If we have 3 or more we will try to use different methods to combine them
% into a single code sheet, Subject_Codes. More info on combination methods
% can be read in the comments for all the case statements.

Video_Codes = wwLoadVideoCodes(fname, Subject_ID);
index = 0;
Subject_Codes = struct('Start_Time', [], 'End_Time', [], 'Code', {},...
    'Notes', {}, 'Subject_ID', [], 'Hand', [], 'Start_Time_Index',...
    [], 'End_Time_Index', []);

if length(Video_Codes) < 3
    return
end
    
% You know, this would be really easy if every code file was the
% same length, but some coders are more descriptive than others. So lets
% get some considerations out of the way. First, if one person has a start
% time ill check to see if everyone else has a similar code within 1
% second. Otherwise ill assume they didnt code it. Person 1 will always be
% the coder with the longest file.

switch type
    % Case 1 will just look at the first start time and last end times
    % and use those as labels, Crude yes but I have to start somewhere.
    case 1
        % The First thing I want to do is identify the longest video code
        % file. This will be the file I look to first when determining
        % times.
        size = 0;
        num_of_codes = length(Video_Codes);
        majority = round(num_of_codes/2);
        for file_number = 1:num_of_codes
            if length(Video_Codes(file_number).Start_Time) > size
                Coder_1 = Video_Codes(file_number);
                Coder_1_index = file_number;
            end
        end
        
        % Now lets run through all of Coder_1's codes. For each code lets
        % try to find a matching code in the other coders file around this
        % time period. I assume the codes wont be in dispute, but rather
        % the time. EX: Coder_1 says code 1234NEM starts at 0.12.236 and
        % ends at 0.15.336. We will then flip through the other coders
        % files within a second of those start times looking for
        % the same code. If we find one we will do our math if not we will
        % assume somethings up. If at least half the coders acknowledge a
        % given code in this timeframe we will include it. 
        
        for code_number = 1:length(Coder_1.Start_Time.values)
            Votes = 0;
            Min_Start_Time = Coder_1.Start_Time.values(code_number);
            Max_End_Time = Coder_1.End_Time.values(code_number);
            current_code = Coder_1.Code(code_number);
            current_note = Coder_1.Notes(code_number);
            S_Time_Index = Coder_1.Start_Time_Index.values(code_number);
            E_Time_Index = Coder_1.End_Time_Index.values(code_number);
            Start_Time_minus1 = Coder_1.Start_Time.values(code_number) - 1000;
            Start_Time_plus1 = Coder_1.Start_Time.values(code_number) + 1000;
            % For each code lets see if the other coders have it in the
            % specified bounds
            for coder = 1:num_of_codes
                % we should skip coder 1
                if coder == Coder_1_index
                    continue
                end
                % skip slots until we hit slots that are within our 2
                % second window
                for time_index = 1:length(Video_Codes(coder).Start_Time.values)
                    if Video_Codes(coder).Start_Time.values(time_index) < Start_Time_minus1
                        continue
                    elseif Video_Codes(coder).Start_Time.values(time_index) > Start_Time_plus1
                        break
                    else
                        if strcmpi(current_code, Video_Codes(coder).Code(time_index))
                            Votes = Votes + 1;
                            if Video_Codes(coder).Start_Time.values(time_index) < Min_Start_Time
                                Min_Start_Time = Video_Codes(coder).Start_Time.values(time_index);
                                S_Time_Index = Video_Codes(coder).Start_Time_Index.values(time_index);
                            end
                            if Video_Codes(coder).End_Time.values(time_index) > Max_End_Time
                                Max_End_Time = Video_Codes(coder).End_Time.values(time_index);
                                E_Time_Index = Video_Codes(coder).End_Time_Index.values(time_index);
                            end
                        end
                    end
                end
                
                % If the majority of coders recognized this code we will
                % record it.
                if Votes >= majority
                    if isempty(Subject_Codes)
                        Subject_Codes(1).Start_Time(1) = Min_Start_Time; 
                        Subject_Codes.End_Time(1) = Max_End_Time;
                        Subject_Codes.Code{1} = current_code{1};
                        Subject_Codes.Notes{1} = current_note{1};
                        Subject_Codes.Start_Time_Index(1) = S_Time_Index;
                        Subject_Codes.End_Time_Index(1) = E_Time_Index;
                        Subject_Codes.Subject_ID{1} = Subject_ID;
                        index = 1;
                    else
                        Subject_Codes.Start_Time(index + 1) = Min_Start_Time;
                        index = index + 1;
                        Subject_Codes.End_Time(index) = Max_End_Time;
                        Subject_Codes.Code{index} = current_code{1};
                        Subject_Codes.Notes{index} = current_note{1};
                        Subject_Codes.Start_Time_Index(index) = S_Time_Index;
                        Subject_Codes.End_Time_Index(index) = E_Time_Index;
                        Subject_Codes.Subject_ID{index} = Subject_ID;
                    end
                    try
                    if strcmpi(Subject_Codes.Code{index}(1), 'l') == 1
                        Subject_Codes.Hand{index} = 'Left';
                    else
                        Subject_Codes.Hand{index} = 'Right';
                    end
                    catch
                        disp('something strange')
                    end
                end
            end
        end
    case 2
        disp('under construction');
    otherwise
        disp("invalid type");
end
return
end

function array_out = wwLoadVideoCodes(fname, subID)
N = 1;
Array = [];
[array_out, ~] = wwVideoCodeSearch(fname, N, Array, subID);
return
end

function [All_data, M] = wwVideoCodeSearch(fname, N, Array, subID)

All_data = [];

% The first step is to decide whether fname is a file or a
% folder.

% If fname is a file, try to load the file as an IMU.

if exist(fname, 'file') == 2
    try
       temp_array = wwVideoCodeRead(fname, subID);
       Array(N).Start_Time = temp_array.Start_Time;
       Array(N).End_Time = temp_array.End_Time;
       Array(N).Code = temp_array.Code;
       Array(N).Notes = temp_array.Notes;
       Array(N).Start_Time_Index = temp_array.Start_Time_Index;
       Array(N).End_Time_Index = temp_array.End_Time_Index;
       Array(N).Subject_ID = temp_array.Subject_ID;
       Array(N).Hand = temp_array.Hand;
       All_data = Array;
    catch
        % If fname was not an IMU file throw a warning and decrease the
        % data array index by one so if we dont have an array filled with
        % null or bad data.
        warning('not an .xlsx file');
        % Then return the current array so that it can be returned when
        % recursion ends.
        All_data = Array;
    end
    % if fname was a file then theres no point in executing the rest of the
    % code so lets stop.
    M = N;
    return

% Now I need to consider the case where fname is a folder, first lets see
% whats inside and try to call wwIMU_search(new_fname) on each of its
% contents.

elseif exist(fname, 'dir') == 7
    % Recover the list of all the folders contents.
    Files = dir(fname);
    % Because I can't index a temp array I need a permanent one.
    Num_of_files = size(Files);
    % For every file in this folder lets try to call wwIMU_search(new_file)
    % and see what happends.
    for index = 1:Num_of_files(1)
       % Apparently a "go back" folder is included when dir(folder) gets
       % called so lets skip those so we dont recurse upwards. This code
       % will skip ANY Files.name that has '.' as the leading string.
       % Hopefully this ends up being a safe assumption since folders 
       % usually aren't allowed to have . as a character.
       if strcmpi(Files(index,1).name(1), '.') == 1
           % do nothing!           
       elseif Files(index,1).isdir == 1
           folder_name = strcat(Files(index,1).folder,'\',Files(index,1).name);
           [All_data, M] = wwVideoCodeSearch(folder_name, N, Array, Files(index,1).name);
           Array = All_data;
           N = M + 1;
       elseif length(Files(index,1).name) < 6 || strcmpi(Files(index,1).name(length(Files(index,1).name)-4:length(Files(index,1).name)),'.xlsx') ~= 1
           % do nothing!
       else
          file_name = strcat(fname,'\',Files(index,1).name);
          [All_data, M] = wwVideoCodeSearch(file_name, N, Array,subID);
          Array = All_data;
          N = M + 1;
       end
    end
else
    disp('ERROR: exist(fname) returned something not 2 or 7');
end
if(isempty(All_data))
    All_data = Array;
    M = N - 1;
end
end

function data = wwVideoCodeRead(fname, subID)
data_out = struct('Start_Time', [], 'End_Time', [], 'Code', [], 'Notes', [], ...
    'Start_Time_Index', [], 'End_Time_Index', [], 'Subject_ID', [], 'Hand', []);
[~,txtarr,~] = xlsread(fname);
A = strrep(txtarr(:,1), '.', '');
B = strrep(txtarr(:,2),'.', '');
C = txtarr(:,3);
D = txtarr(:,4);

Start_Time_array = nan(length(A)-1,1);
End_Time_array = nan(length(A)-1,1);
Start_Time_Index = nan(length(A)-1,1);
End_Time_Index = nan(length(A)-1,1);

for index = 2:length(A)
  Start_Time = A{index,1};
  End_Time = B{index,1};
  % Just in case my coder forgets to fill in a start/end Time
  if(isempty(Start_Time) || isempty(End_Time))
      continue
  end
  % im just gonna pad my string out with zeros to make loading times easier
  if length(Start_Time) ~= 9
     difference = 9 - length(Start_Time);
     for pad = 1:difference
         Start_Time = strcat('0',Start_Time);
     end
  end
  
  if length(End_Time) ~= 9
     difference = 9 - length(End_Time);
     for pad = 1:difference
         End_Time = strcat('0',End_Time);
     end
  end
  
  Start_Time_array(index - 1) = str2double(Start_Time);
  End_Time_array(index - 1) = str2double(End_Time);
  % To make my life easier in later functions Im gonna make a index for the
  % time.

  hours = str2double(Start_Time(1:2));
  minutes = str2double(Start_Time(3:4));
  Start_Time_Index(index - 1) = hours*360000 + minutes*6000 + str2double(Start_Time(end-4:end-1));
  
  hours = str2double(End_Time(1:2));
  minutes = str2double(End_Time(3:4));
  End_Time_Index(index - 1) = hours*360000 + minutes*6000 + str2double(End_Time(end-4:end-1));

end

data_out.Start_Time.values = Start_Time_array;
data_out.End_Time.values = End_Time_array;
data_out.Code = C(2:end,1);
data_out.Notes = D(2:end,1);
data_out.Start_Time_Index.values = Start_Time_Index;
data_out.End_Time_Index.values = End_Time_Index;
data_out.Subject_ID = subID;
data = data_out;
return
end