function [complete_data] = wwIMUload(fname)
% Developed by Jason Foster, jf727@nau.edu.
% This function starts other functions necessary for the proper loading of
% IMU data.
% This function will load a file/folder and return the IMU data in a array
% containing structs. To properly use this function you should
% 1: Ensure the file/folder you are loading is in the proper path then
% 2: Call this function using
% complete_data = wwIMUload(file|foldername); 
% To sort through complete_data just call complete_data(1).Timestamp
N = 1;
Array = [];
[complete_data] = wwIMU_search(fname, N, Array, subID);

size_of_struct = size(complete_data);
size_of_struct = size_of_struct(2);
BIG_MATRIX = [];

% for i = 1:size_of_struct
%    BIG_MATRIX(i).Acc_X = 
%    BIG_MATRIX(i).Acc_Y =
%    BIG_MATRIX(i).Acc_Z = 
%    BIG_MATRIX(i).Temp_C = 
%    BIG_MATRIX(i).Gyro_X = 
%    BIG_MATRIX(i).Gyro_Y = 
%    BIG_MATRIX(i).Gyro_Z = 
%    BIG_MATRIX(i).Magnet_X = 
%    BIG_MATRIX(i).Magnet_Y = 
%    BIG_MATRIX(i).Magnet_Z = 
%    BIG_MATRIX(i).Sample_Rate = 
%    BIG_MATRIX(i).Software_Version = 
%    BIG_MATRIX(i).Firmware =
%    BIG_MATRIX(i).Start_Date = 
%    BIG_MATRIX(i).Start_Time = 
%    BIG_MATRIX(i).Timestamp = 
% end

Big_Matrix_Map = 'Acc_x/y/z Temp_C Gyro_x/y/z Magnet_X/y/z Sample_Rate Software_version Firmware Start_Date Start_Time TimeStamp';

return
end

function [All_data, M] = wwIMU_search(fname, N, Array, subID)
% Developed by Jason Foster jf727@nau.edu.
% This function is supposed to be called as wwIMUload runs so that files
% can be sorted from folders and folders can be traversed to find more
% data. To Properly call this function use All_data =
% wwIMU_search(file|foldername);

All_data = [];

% The first step is to decide whether fname is a file or a
% folder.

% If fname is a file lets try to pull IMU data from it.
if exist(fname, 'file') == 2
    try
       temp = wwIMUread(fname, subID);
       Array(N).Acc_X = temp.Acc_X;
       Array(N).Acc_Y = temp.Acc_Y;
       Array(N).Acc_Z = temp.Acc_Z;
       Array(N).Temp_C = temp.Temp_C;
       Array(N).Gyro_X = temp.Gyro_X;
       Array(N).Gyro_Y = temp.Gyro_Y;
       Array(N).Gyro_Z = temp.Gyro_Z;
       Array(N).Magnet_X = temp.Magnet_X;
       Array(N).Magnet_Y = temp.Magnet_Y;
       Array(N).Magnet_Z = temp.Magnet_Z;
       Array(N).Sample_Rate = temp.Sample_Rate;
       Array(N).Software_Version = temp.Software_Version;
       Array(N).Firmware = temp.Firmware;
       Array(N).Start_Date = temp.Start_Date;
       Array(N).Start_Time = temp.Start_Time;
       Array(N).Timestamp = temp.Timestamp;
       Array(N).Labels = temp.Labels;
       Array(N).Subject_ID = temp.Subject_ID;
       Array(N).Hand = temp.Hand;
       All_data = Array;
    catch
        % If we cant get IMU data we should decrease the index by one so
        % bad or null data gets overwritten by actual IMU data.
        warning('not an IMU.csv file');
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
       % If Files(index,1) does not reference the "go back" folder(s) and it
       % is a Folder lets sort through that folder.
       elseif Files(index,1).isdir == 1
           folder_name = strcat(Files(index,1).folder,'\',Files(index,1).name);
           [All_data, M] = wwIMU_search(folder_name, N, Array, Files(index,1).name);
           Array = All_data;
           N = M + 1;
       % If the file name probably does not reference a IMU file we should
       % just skip it.
       elseif length(Files(index,1).name) < 8 || strcmpi(Files(index,1).name(length(Files(index,1).name)-6:length(Files(index,1).name)),'IMU.csv') ~= 1
           % do nothing!
       % If we get this far we likely found an IMU file in this folder! So
       % let get its address in memory, EX:
       % D:\MATLAB\Folder\Data\IMU_data.csv
       % and call wwIMUsearch(D:\MATLAB\Folder\Data\IMU_data.csv) and see
       % what we get.
       else
          file_name = strcat(fname,'\',Files(index,1).name);
          [All_data, M] = wwIMU_search(file_name, N, Array, subID);
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

function [data] = wwIMUread(fname, subID)
% Developed by Jason Foster jf727@nau.edu October 2018.
% Ensure path is set up properly and make sure the IMU.csv file you
% want to work with is in octaves current directory.
% To ensure your data is loaded properly call this function using 
% data = wwIMUread(filename).
% This function will take a .csv and pull the IMU data 
% into a struct. Data will hold all the necessary data.

% To avoid future headache.
format long;

% The first 11 rows are used by actigraph to make the header, so lets cut
% that out.

cleaned_Data = dlmread(fname, ',', 11, 1);

% Because MATLAB won't let me index a temporary index I have to make it
% permanent.

size_cleaned_Data = size(cleaned_Data);

% Now lets build the current index into our data structure. 

All_Data.Acc_X.values = cleaned_Data(1:size_cleaned_Data(1),1);
All_Data.Acc_Y.values = cleaned_Data(1:size_cleaned_Data(1),2);
All_Data.Acc_Z.values = cleaned_Data(1:size_cleaned_Data(1),3);
All_Data.Temp_C.values = cleaned_Data(1:size_cleaned_Data(1),4);
All_Data.Gyro_X.values = cleaned_Data(1:size_cleaned_Data(1),5);
All_Data.Gyro_Y.values = cleaned_Data(1:size_cleaned_Data(1),6);
All_Data.Gyro_Z.values = cleaned_Data(1:size_cleaned_Data(1),7);
All_Data.Magnet_X.values = cleaned_Data(1:size_cleaned_Data(1),8);
All_Data.Magnet_Y.values = cleaned_Data(1:size_cleaned_Data(1),9);
All_Data.Magnet_Z.values = cleaned_Data(1:size_cleaned_Data(1),10);
All_Data.Acc_X.unit = 'g';
All_Data.Acc_Y.unit = 'g';
All_Data.Acc_Z.unit = 'g';
All_Data.Temp_C.unit = 'C';
All_Data.Gyro_X.unit = 'Deg/Sec';
All_Data.Gyro_Y.unit = 'Deg/Sec';
All_Data.Gyro_Z.unit = 'Deg/Sec';
All_Data.Magnet_X.unit = 'microT';
All_Data.Magnet_Y.unit = 'microT';
All_Data.Magnet_Z.unit = 'microT';

% Since the time stamp wont come out using the above method we have to
% build it ourselves. This will involve pulling some info out of the
% header, so lets switch gears and build it.

uncleaned_Header = fileread(fname);

% Since the header shouldn't change baring any software/hardware updates we
% can just hard code values where the important info will be.

% First lets find the sample rate, since its always set to 100 hz we dont
% actually have to look for it. Should things change this is where I/you
% should put it.

All_Data.Sample_Rate.values = 100;
All_Data.Sample_Rate.unit = 'Hz';

% Since im hardcoding this, if the software/hardware version changes this
% may no longer work so let try to pull that info and throw a warning
% should a software/hardware update occur.

All_Data.Software_Version = uncleaned_Header(66:81);
All_Data.Firmware = uncleaned_Header(83:97);

% which hand is this?

device = uncleaned_Header(159:171);
if strcmpi('TAS1F22170039',device)
    All_Data.Hand = 'left';
elseif strcmpi('TAS1F22170061',device)
    All_Data.Hand = 'right';
else
    All_Data.Hand = 'ERROR: Undetermined, Check Code';
end

if(strcmpi(All_Data.Software_Version, 'ActiLife v6.13.3') ~= 1 || strcmpi(All_Data.Firmware, 'Firmware v1.7.1') ~= 1)
    warning('WARNING: software/hardware update detected, please ensure the header is properly pulling relevant information. Check code');
end

% Now lets grab our Timestamp information.

All_Data.Start_Date = uncleaned_Header(206:215);
All_Data.Start_Time = uncleaned_Header(185:192);

% Lets build our timestamp

% First, lets read in the data as a string, then split the string at each
% newline.
data_in = fileread(fname);
data_in = strsplit(data_in, "\n");

data_in_size = length(data_in);

% Now lets make an empty array for our timestamp, since I know what the
% size of the array is I can make an empty array of size Number_of_samples x 6

Timestamp = nan(data_in_size - 13, 6);

% For every line where our data is lets take the timestamp part out and
% further split it

for index = 12:data_in_size - 1
  uncleaned_date = data_in{index}(1:27);
  uncleaned_date = strsplit(uncleaned_date, "T");
  date_time = strsplit(uncleaned_date{1}, "-");
  year = str2double(date_time{1});
  month = str2double(date_time{2});
  day = str2double(date_time{3});
  date_time = strsplit(uncleaned_date{2}, ":");
  hour = str2double(date_time{1});
  minute = str2double(date_time{2});
  second = str2double(date_time{3});
  Timestamp(index - 11, 1) = year;
  Timestamp(index - 11, 2) = month;
  Timestamp(index - 11, 3) = day;
  Timestamp(index - 11, 4) = hour;
  Timestamp(index - 11, 5) = minute;
  Timestamp(index - 11, 6) = second;
end
All_Data.Timestamp.values = Timestamp;
All_Data.Timestamp.unit = 'yy/mm/dd/hh/mm/ss.cc';

% Because I need to label this struct in later functions its easier to
% already have that field ready to go.

All_Data.Labels = nan(data_in_size - 12, 1);
All_Data.Subject_ID = subID;
data = All_Data;
return

end