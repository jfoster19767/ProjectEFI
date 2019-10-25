function subsection = wwSubselect(Labeled_Struct, Video_Code_Subject_ID_Hand)
% Function developed by Jason Foster, jf727@nau.edu, November 2018.
% This function will take a already labeled struct and video code OR
% Subject_ID and subselect out from the main data the peice you want to
% see.

VC = false;

% Did we recieve a Video_Code or a Subject_ID?

subsection = [];

if isnumeric(Video_Code_Subject_ID_Hand)
    Video_Code = Video_Code_Subject_ID_Hand;
    VC = true;
elseif strcmpi(strtrim(Video_Code_Subject_ID_Hand), 'right')
    findhand = true;
    findleft = false;
elseif strcmpi(strtrim(Video_Code_Subject_ID_Hand), 'left')
    findhand = true;
    findleft = true;
else
    Subject_ID = Video_Code_Subject_ID_Hand;
    VC = false;
    findhand = false;
end

% If we recieved a video code(S) lets pull those sections out

if VC
    for index = 1:length(Video_Code)
        for time_index = 1:length(Labeled_Struct.Labels)
            if Labeled_Struct.Labels(time_index) == Video_Code(index)
                subsection.Acc_X = [subsection.Acc_X; Labeled_Struct.Acc_X(time_index)];
                subsection.Acc_Y = [subsection.Acc_Y; Labeled_Struct.Acc_Y(time_index)];
                subsection.Acc_Z = [subsection.Acc_Z; Labeled_Struct.Acc_Z(time_index)];
                subsection.Temp_C = [subsection.Temp_C; Labeled_Struct.Temp_C(time_index)];
                subsection.Gyro_X = [subsection.Gyro_X; Labeled_Struct.Gyro_X(time_index)];
                subsection.Gyro_Y = [subsection.Gyro_Y; Labeled_Struct.Gyro_Y(time_index)];
                subsection.Gyro_Z = [subsection.Gyro_Z; Labeled_Struct.Gyro_Z(time_index)];
                subsection.Magnet_X = [subsection.Magnet_X; Labeled_Struct.Magnet_X(time_index)];
                subsection.Magnet_Y = [subsection.Magnet_Y; Labeled_Struct.Magnet_Y(time_index)];
                subsection.Magnet_Z = [subsection.Magnet_Z; Labeled_Struct.Magnet_Z(time_index)];
                subsection.Labels = [subsection.Labels; Labeled_Struct.Labels(time_index)];
            end
        end
    end
elseif findhand
    for index = 1:length(Labeled_Struct)
        if strcmpi(Labeled_Struct(index).Hand, 'left') && findleft ||...
                strcmpi(Labeled_Struct(index).Hand, 'right') && ~findleft
           subsection = [subsection, Labeled_Struct(index)];
        end
    end
else
    for index = 1:length(Labeled_Struct)
        if strcmpi(Labeled_Struct(index).Subject_ID, Subject_ID) == 1
           subsection = [subsection, Labeled_Struct(index)];
        end
    end
end
end
