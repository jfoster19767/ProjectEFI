function [Cleaned_Struct] = wwSetInitTime(Struct, Auto)
% developed by Jason Foster, jf727@nau.edu December 2018
% This function will attempt to align both the accelerometers and identify
% when the calibration occurs in both real(Actigraph) time and relative(the
% time observed in the videos) time.

% Lets get some assumptions out there, first I assume that I always get two
% hands, if for some reason one hands data is missing I'm going to ignore
% that subject. Second Im going to input subsections of the main struct,
% cutting at participant ID's to ensure I always have two data points.
% Right and Left.

% so which set is for the right hand?
if ~Auto

    if strcmpi('left', Struct(1).Hand) == 1
        for index = 1:length(Struct(1).Acc_X.values)
            if index > length(Struct(1).Acc_X.values) || index > length(Struct(2).Acc_X.values)
                continue
            end
            lefthand(1,index) = sqrt(Struct(1).Acc_X.values(index)^2 + Struct(1).Acc_Y.values(index)^2 + Struct(1).Acc_Z.values(index)^2);
            righthand(1,index) = sqrt(Struct(2).Acc_X.values(index)^2 + Struct(2).Acc_Y.values(index)^2 + Struct(2).Acc_Z.values(index)^2);
            left = true;
        end
    else
        for index = 1:length(Struct(1).Acc_X.values)
            if index > length(Struct(1).Acc_X.values) || index > length(Struct(2).Acc_X.values)
                continue
            end
            lefthand(1,index) = sqrt(Struct(2).Acc_X.values(index)^2 + Struct(2).Acc_Y.values(index)^2 + Struct(2).Acc_Z.values(index)^2);
            righthand(1,index) = sqrt(Struct(1).Acc_X.values(index)^2 + Struct(1).Acc_Y.values(index)^2 + Struct(1).Acc_Z.values(index)^2);
            left = false;
        end
    end

    plot(lefthand)
    hold on;
    plot(righthand)
    legend('left','right')
    xlabel('Time in seconds')
    ylabel("total acceleration in g's")

    disp('on the screen is the actigraph waveforms')
    disp('Ideally you should see two colors and a section near the start')
    disp('where there are 3 sharp peaks')

    input('Zoom into the area of interest then hit enter when your ready for clicking')
    disp('Do me a favor and click the tip of the first left peak first, then the first right peak')

    [x,~] = ginput(2);
    difference = x(1) - x(2);

    % now I need to know which hand is lagging

    if difference <= 0
        isRightLagging = true;
    else
        isRightLagging = false;
    end

    % now lets shift the lagging waveform

    difference = abs(round(difference));

    Cleaned_Struct(1) = Struct(1);
    Cleaned_Struct(2) = Struct(2);

    if isRightLagging
        %cleaned_right = zeros(1,length(lefthand));
        for index = 1:length(Struct(1).Acc_X.values)
           if index == length(Struct(1).Acc_X.values)-difference
               break
           end
           if left
               Cleaned_Struct(2).Acc_X.values(index) = Struct(2).Acc_X.values(index+difference);
               Cleaned_Struct(2).Acc_Y.values(index) = Struct(2).Acc_Y.values(index+difference);
               Cleaned_Struct(2).Acc_Z.values(index) = Struct(2).Acc_Z.values(index+difference);
           else
               Cleaned_Struct(2).Acc_X.values(index) = Struct(1).Acc_X.values(index+difference);
               Cleaned_Struct(2).Acc_Y.values(index) = Struct(1).Acc_Y.values(index+difference);
               Cleaned_Struct(2).Acc_Z.values(index) = Struct(1).Acc_Z.values(index+difference);
           end
           %cleaned_right(index) = righthand(index+difference);
        end
        Time_Zero = round(x(1));
    else
        %cleaned_left = zeros(1,length(lefthand));
        for index = 1:length(Struct(1).Acc_X.values)
           if index == length(Struct(1).Acc_X.values)-difference
               break
           end
           if index > length(Struct(1).Acc_X.values) || index > length(Struct(1).Acc_X.values)...
                   || index + difference > length(Struct(1).Acc_X.values) || index + difference > length(Struct(2).Acc_X.values)
               continue
           end
           %cleaned_left(index) = lefthand(index+difference);
           if left
               Cleaned_Struct(1).Acc_X.values(index) = Struct(2).Acc_X.values(index+difference);
               Cleaned_Struct(1).Acc_Y.values(index) = Struct(2).Acc_Y.values(index+difference);
               Cleaned_Struct(1).Acc_Z.values(index) = Struct(2).Acc_Z.values(index+difference);
           else
               Cleaned_Struct(1).Acc_X.values(index) = Struct(1).Acc_X.values(index+difference);
               Cleaned_Struct(1).Acc_Y.values(index) = Struct(1).Acc_Y.values(index+difference);
               Cleaned_Struct(1).Acc_Z.values(index) = Struct(1).Acc_Z.values(index+difference);
           end
        end
        Time_Zero = round(x(2));
    end
    
else
    % To automatically find my zero point we need to find 3 consecutive
    % periods of very high acceleration from both imu's
    if strcmpi('left', Struct(1).Hand) == 1
        for index = 1:length(Struct(1).Acc_X.values)
            if index > length(Struct(1).Acc_X.values) || index > length(Struct(2).Acc_X.values)
                continue
            end
            lefthand(1,index) = sqrt(Struct(1).Acc_X.values(index)^2 + Struct(1).Acc_Y.values(index)^2 + Struct(1).Acc_Z.values(index)^2);
            righthand(1,index) = sqrt(Struct(2).Acc_X.values(index)^2 + Struct(2).Acc_Y.values(index)^2 + Struct(2).Acc_Z.values(index)^2);
            left = true;
        end
    else
        for index = 1:length(Struct(1).Acc_X.values)
            if index > length(Struct(1).Acc_X.values) || index > length(Struct(2).Acc_X.values)
                continue
            end
            lefthand(1,index) = sqrt(Struct(2).Acc_X.values(index)^2 + Struct(2).Acc_Y.values(index)^2 + Struct(2).Acc_Z.values(index)^2);
            righthand(1,index) = sqrt(Struct(1).Acc_X.values(index)^2 + Struct(1).Acc_Y.values(index)^2 + Struct(1).Acc_Z.values(index)^2);
            left = false;
        end
    end
    
    shift_Left = median(find(lefthand < .15));   
    shift_Right = median(find(righthand < .15));
    sub_dLeft = lefthand(int64(shift_Left) - 1000:int64(shift_Left) + 1000);
    sub_dRight = righthand(int64(shift_Right) - 1000:int64(shift_Right) + 1000);
    
    leftCalPoints = find((sub_dLeft(2:end) < .15) & (diff(sub_dLeft) > 0));
    rightCalPoints = find((sub_dRight(2:end) < .15) & (diff(sub_dRight) > 0));
    
    if left
        Struct(1).Calibration_Time = shift_Left;
        Struct(2).Calibration_Time = shift_Right;
    else
        Struct(2).Calibration_Time = shift_Left;
        Struct(1).Calibration_Time = shift_Right;
    end
    
    figurename = char(string(Struct(1).Subject_ID) + ' left');
    figure
    plot(sub_dLeft)
    hold on
    plot(leftCalPoints(end),0,'o')
    savefig(figurename)
    close all
    
    figurename = char(string(Struct(1).Subject_ID) + ' right');
    figure
    plot(sub_dRight)
    hold on
    plot(rightCalPoints(end),0,'o')
    savefig(figurename)
    close all
    Cleaned_Struct = Struct;
    
end
end