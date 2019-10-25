function [Labeled_Struct] = wwStructLabler(Struct, Video_Codes)
% Developed by Jason Foster jf727@nau.edu, November 2018.
% This function takes a struct with the gtNx data, preferably the struct
% was made by wwIMUload. 
% toLabel is a text file that should be availble in the toolkit, it 
% contains every possible video code and what its corresponding label is. 
% A ReadMe.txt file should also be available that explains what the code
% stands for if you're curious. Video_Codes is the combined video code file
% for this particular gtNx struct. 
% To properly call this function use,
% Labeled_Struct = wwStructLabler(Struct, Video_Codes);

% Because I have two timers going, actigraph and the actual video I need to
% establish what time in actigraph corresponds to time zero in the video.

[Labeled_Struct] = wwSetInitTime(Struct, false);

% The first thing I want to look for is when a video code starts, I.E,
% right hand moves to mouth at 00:04:36.214 and ends at 00:04:38.398.
% Oh and since we have milisecond precision on the code but only centi
% second precision on the gtNx data I'm just gonna cut off the last
% milisecond. Ex: 03.698 would be 03.69.

% For every start time,

num_of_times = Video_Codes.Start_Time;

% we need our start time and end time in measure of index

Labeled_Struct(1).Labels = nan(length(Struct(1).Acc_X.values),1);
Labeled_Struct(2).Labels = nan(length(Struct(2).Acc_X.values),1);

for time = 1:length(num_of_times)
   % Well, there is a code here.... R-right?
   if isnan(Video_Codes.Start_Time(time))
      continue 
   end
   % Find the interval to grant a code
   Start_Time_Index = Video_Codes.Start_Time_Index(time);
   End_Time_Index = Video_Codes.End_Time_Index(time);
   % Just making sure my end time is AFTER my start time.
   if Start_Time_Index > End_Time_Index
       continue
   end
  % Cool now I have a start and end time so now lets mark those in the
  % Struct then add the label in between start and end time.
  
  slurm_code = str2double(FindCode(Video_Codes.Code{time}));

  if strcmpi(Labeled_Struct(1).Hand, 'left')
      Time_Zero_Left = int64(Labeled_Struct(1).Calibration_Time);
      Time_Zero_Right = int64(Labeled_Struct(2).Calibration_Time);
  else
      Time_Zero_Left = Labeled_Struct(2).Calibration_Time;
      Time_Zero_Right = Labeled_Struct(1).Calibration_Time;
  end
       
  for T = Start_Time_Index:End_Time_Index
      Labeled_Struct(1).Labels(T+Time_Zero_Left) = slurm_code;
      Labeled_Struct(2).Labels(T+Time_Zero_Right) = slurm_code;
  end
  
end

end

function slurm_code = FindCode(code)

fclose('all');

try 
    fileID = fopen('Legacy_Matrix.txt', 'r');
catch
    disp('ERROR: Missing Video_Matrix.txt; please ensure the file is located in the same folder as the wwProjectEFI.m file')
    return
end

codes = textscan(fileID, '%s');

%lets find our code

for index = 1:length(codes{1})
    % based on how I made this file when i find the code the next line will
    % be my code
    if strcmpi(code, codes{1}{index}(1:end)) == 1
        slurm_code = codes{1}{index+1}(1:end);
        return
    end
end

disp('WARNING: Code did not return a slurm code, make sure Dictionary is updated!')
slurm_code = nan;
return
end