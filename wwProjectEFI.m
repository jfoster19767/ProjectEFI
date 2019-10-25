function [Labeled_Struct_Completed, Big_Matrix, Big_Matrix_Col] =  wwProjectEFI(fname, imu_d, Comb_vid)
% Developed by Jason Foster jf727@nau.edu, December 2018.
% This function serves to more easily split up all the tasks I need to do.
% This more or less helps me figure out what changes certain functions need
% to be more capatabile with others since I keep running into problems as I
% build...
% Call this function by typing [Labeled_Struct_Completed, Big_Matrix,
% Big_Matrix_Col] =  wwProjectEFI(fname, imu_d, Comb_vid);
% where Labeled_Struct_Completed contains the labeled struct, Big_Matrix
% contains the Matrix that will be sent to monsoon and Big_Matrix_Col
% contains the row names for Big_Matrix.
% if you have .mat files for the imu and video codes then you should call
% wwProjectEFI('',imu.mat,codes.mat)
% otherwise you can call wwProjectEFI(folderName) but because this will
% take a long time (Days) you should use imu.mat = wwIMUload(folderName)
% and codes.mat = wwCombineVideoCodes(folderName).


% So assuming I have a neat folder setup, which I may have to do later...
% Lets first pull out two big structs of all the IMU data and video codes
% data.

% IMU_DATA = wwIMUload(fname);
% COMBINED_VIDEOCODES = wwCombineVideoCodes(fname,1);

IMU_DATA = imu_d;
COMBINED_VIDEOCODES = Comb_vid;

% Cool, So for now lets break our stuct's up into pieces. We will seperate
% our struct's via subselecting each subject to have their own struct.

Searched_subjects = [];
Labeled_Struct_Completed = [];

% For every subject, subselect them from the main struct
for subject_number = 1:length(COMBINED_VIDEOCODES)
%     skip = 0;
%     % lets not repeat multiple subjects
%     if subject_number ~= 1
%         for index = 1:length(Searched_subjects)
%             if strcmpi(Searched_subjects(index), IMU_DATA(subject_number + skip).Subject_ID) == 1
%             end
%         end
%     end
    Searched_subjects = [Searched_subjects, string(COMBINED_VIDEOCODES(subject_number).Subject_ID)];
    IMU_subsection = wwSubselect(IMU_DATA, IMU_DATA(subject_number*2).Subject_ID);
    % If we dont get two IMU results somethings wrong, so lets skip that.
    if length(IMU_subsection) ~= 2
        continue
    end
    % Now lets get that subjects video code file
    Video_subsection = wwSubselect(COMBINED_VIDEOCODES, COMBINED_VIDEOCODES(subject_number).Subject_ID);
    % now that we (hopefully) got all the necessary pieces lets label the
    % subjects struct
    try
        Labeled_Struct = wwStructLabler(IMU_subsection, Video_subsection);
        if isempty(Labeled_Struct_Completed)
           Labeled_Struct_Completed(1).Acc_X = Labeled_Struct(1).Acc_X;
           Labeled_Struct_Completed(1).Acc_Y = Labeled_Struct(1).Acc_Y;
           Labeled_Struct_Completed(1).Acc_Z = Labeled_Struct(1).Acc_Z;
           Labeled_Struct_Completed(1).Temp_C = Labeled_Struct(1).Temp_C;
           Labeled_Struct_Completed(1).Gyro_X = Labeled_Struct(1).Gyro_X;
           Labeled_Struct_Completed(1).Gyro_Y = Labeled_Struct(1).Gyro_Y;
           Labeled_Struct_Completed(1).Gyro_Z = Labeled_Struct(1).Gyro_Z;
           Labeled_Struct_Completed(1).Magnet_X = Labeled_Struct(1).Magnet_X;
           Labeled_Struct_Completed(1).Magnet_Y = Labeled_Struct(1).Magnet_Y;
           Labeled_Struct_Completed(1).Magnet_Z = Labeled_Struct(1).Magnet_Z;
           Labeled_Struct_Completed(1).Timestamp = Labeled_Struct(1).Timestamp;
           Labeled_Struct_Completed(1).Labels = Labeled_Struct(1).Labels;
           Labeled_Struct_Completed(1).Subject_ID = Labeled_Struct(1).Subject_ID;
           Labeled_Struct_Completed(1).Hand = Labeled_Struct(1).Hand;
           Labeled_Struct_Completed(1).Calibration_Time = Labeled_Struct(1).Calibration_Time;
           Labeled_Struct_Completed(2).Acc_X = Labeled_Struct(2).Acc_X;
           Labeled_Struct_Completed(2).Acc_Y = Labeled_Struct(2).Acc_Y;
           Labeled_Struct_Completed(2).Acc_Z = Labeled_Struct(2).Acc_Z;
           Labeled_Struct_Completed(2).Temp_C = Labeled_Struct(2).Temp_C;
           Labeled_Struct_Completed(2).Gyro_X = Labeled_Struct(2).Gyro_X;
           Labeled_Struct_Completed(2).Gyro_Y = Labeled_Struct(2).Gyro_Y;
           Labeled_Struct_Completed(2).Gyro_Z = Labeled_Struct(2).Gyro_Z;
           Labeled_Struct_Completed(2).Magnet_X = Labeled_Struct(2).Magnet_X;
           Labeled_Struct_Completed(2).Magnet_Y = Labeled_Struct(2).Magnet_Y;
           Labeled_Struct_Completed(2).Magnet_Z = Labeled_Struct(2).Magnet_Z;
           Labeled_Struct_Completed(2).Timestamp = Labeled_Struct(2).Timestamp;
           Labeled_Struct_Completed(2).Labels = Labeled_Struct(2).Labels;
           Labeled_Struct_Completed(2).Subject_ID = Labeled_Struct(2).Subject_ID;
           Labeled_Struct_Completed(2).Hand = Labeled_Struct(2).Hand;
           Labeled_Struct_Completed(2).Calibration_Time = Labeled_Struct(2).Calibration_Time;
           Index = 2;
        else
           Labeled_Struct_Completed(Index+1).Acc_X = Labeled_Struct(1).Acc_X;
           Labeled_Struct_Completed(Index+1).Acc_Y = Labeled_Struct(1).Acc_Y;
           Labeled_Struct_Completed(Index+1).Acc_Z = Labeled_Struct(1).Acc_Z;
           Labeled_Struct_Completed(Index+1).Temp_C = Labeled_Struct(1).Temp_C;
           Labeled_Struct_Completed(Index+1).Gyro_X = Labeled_Struct(1).Gyro_X;
           Labeled_Struct_Completed(Index+1).Gyro_Y = Labeled_Struct(1).Gyro_Y;
           Labeled_Struct_Completed(Index+1).Gyro_Z = Labeled_Struct(1).Gyro_Z;
           Labeled_Struct_Completed(Index+1).Magnet_X = Labeled_Struct(1).Magnet_X;
           Labeled_Struct_Completed(Index+1).Magnet_Y = Labeled_Struct(1).Magnet_Y;
           Labeled_Struct_Completed(Index+1).Magnet_Z = Labeled_Struct(1).Magnet_Z;
           Labeled_Struct_Completed(Index+1).Timestamp = Labeled_Struct(1).Timestamp;
           Labeled_Struct_Completed(Index+1).Labels = Labeled_Struct(1).Labels;
           Labeled_Struct_Completed(Index+1).Subject_ID = Labeled_Struct(1).Subject_ID;
           Labeled_Struct_Completed(Index+1).Hand = Labeled_Struct(1).Hand;
           Labeled_Struct_Completed(Index+1).Calibration_Time = Labeled_Struct(1).Calibration_Time;
           Labeled_Struct_Completed(Index+2).Acc_X = Labeled_Struct(2).Acc_X;
           Labeled_Struct_Completed(Index+2).Acc_Y = Labeled_Struct(2).Acc_Y;
           Labeled_Struct_Completed(Index+2).Acc_Z = Labeled_Struct(2).Acc_Z;
           Labeled_Struct_Completed(Index+2).Temp_C = Labeled_Struct(2).Temp_C;
           Labeled_Struct_Completed(Index+2).Gyro_X = Labeled_Struct(2).Gyro_X;
           Labeled_Struct_Completed(Index+2).Gyro_Y = Labeled_Struct(2).Gyro_Y;
           Labeled_Struct_Completed(Index+2).Gyro_Z = Labeled_Struct(2).Gyro_Z;
           Labeled_Struct_Completed(Index+2).Magnet_X = Labeled_Struct(2).Magnet_X;
           Labeled_Struct_Completed(Index+2).Magnet_Y = Labeled_Struct(2).Magnet_Y;
           Labeled_Struct_Completed(Index+2).Magnet_Z = Labeled_Struct(2).Magnet_Z;
           Labeled_Struct_Completed(Index+2).Timestamp = Labeled_Struct(2).Timestamp;
           Labeled_Struct_Completed(Index+2).Labels = Labeled_Struct(2).Labels;
           Labeled_Struct_Completed(Index+2).Subject_ID = Labeled_Struct(2).Subject_ID;
           Labeled_Struct_Completed(Index+2).Hand = Labeled_Struct(2).Hand;
           Labeled_Struct_Completed(Index+2).Calibration_Time = Labeled_Struct(2).Calibration_Time;
           Index = Index + 2;
        end
    catch
        disp("WARNING: Invalid Alphanumeric code, check to ensure the dictionary is updated!")
    end
    
end

% now lets pull from our struct to make a matrix

% first figure out how big it needs to be

total = 0;
for n = 1:length(Labeled_Struct_Completed)
    total = total + length(Labeled_Struct_Completed(n).Labels);
end

Big_Matrix = nan(total,12);
count = 0;

% No point in having NAN so lets lop off the unlabeled sections

for n = 1:length(Labeled_Struct_Completed)
    acc_x = Labeled_Struct_Completed(n).Acc_X.values;
    acc_y = Labeled_Struct_Completed(n).Acc_Y.values;
    acc_z = Labeled_Struct_Completed(n).Acc_Z.values;
    gyro_x = Labeled_Struct_Completed(n).Gyro_X.values;
    gyro_y = Labeled_Struct_Completed(n).Gyro_Y.values;
    gyro_z = Labeled_Struct_Completed(n).Gyro_Z.values;
    timestamp = Labeled_Struct_Completed(n).Timestamp.values;
    labels = Labeled_Struct_Completed(n).Labels;
    subject_id = Labeled_Struct_Completed(n).Subject_ID;
    hand = Labeled_Struct_Completed(n).Hand;
    
    acc_x = rmmissing(acc_x);
    acc_y = rmmissing(acc_y);
    acc_z = rmmissing(acc_z);
    gyro_x = rmmissing(gyro_x);
    gyro_y = rmmissing(gyro_y);
    gyro_z = rmmissing(gyro_z);
    
    for j = 1:length(acc_x)
        count = count + 1;
        Big_Matrix(count,1) = acc_x(j);
        Big_Matrix(count,2) = acc_y(j);
        Big_Matrix(count,3) = acc_z(j);
        Big_Matrix(count,4) = gyro_x(j);
        Big_Matrix(count,5) = gyro_y(j);
        Big_Matrix(count,6) = gyro_z(j);
        Big_Matrix(count,7) = timestamp(j,4);
        Big_Matrix(count,8) = timestamp(j,5);
        Big_Matrix(count,9) = timestamp(j,6);
        Big_Matrix(count,10) = labels(j);
        Big_Matrix(count,11) = str2num(subject_id(4:end));
        if strcmpi('left', hand)
            Big_Matrix(count,12) = 1;
        else
            Big_Matrix(count,12) = 0;
        end
    end
end

Big_Matrix = rmmissing(Big_Matrix);
Big_Matrix_Col = 'Acc_X/Acc_Y/Acc_Z/Gyro_X/Gyro_Y/Gyro_Z/hour/minuet/second.centiseconds/labels/subject_ID/Hand';

return
end