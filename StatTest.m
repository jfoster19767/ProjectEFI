%% Now lets run our test suite and save plots %%
% Make sure your Big_Matrix is loaded up and ready to go %
win = 35;
alpha = .1:.1:.9;
load('Big_Matrix.mat');
% SMA tests %

Stat_SMA_Matrix = wwStatTestSuite(Big_Matrix, 'SMA', win);
% identify where we should plot lines
seperators = nan(1,length(Big_Matrix));
sep_Code = nan(1,length(Big_Matrix));
index = 1;
for j = 1:length(Stat_SMA_Matrix)
    if j == 1 
        seperators(1) = 0;
        sep_Code(1) = Stat_SMA_Matrix(1,10);
        index = index + 1;
        continue
    end
    previous_Code = Stat_SMA_Matrix(j-1,10);
    current_Code = Stat_SMA_Matrix(j,10);
    if current_Code ~= previous_Code
        seperators(index) = j-1;
        sep_Code(index) = current_Code;
        index = index + 1;
    end
end
% assign each code a color
seperators = rmmissing(seperators);
sep_Code = rmmissing(sep_Code);
unique_Code = unique(sep_Code);
Num_of_Codes = 120;
color_Spacing = 15000000/Num_of_Codes;   
figure
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_SMA_Matrix(:,1));
        else
            current_seperator = next_seperator;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color); 
        else
            hexVal = '#' + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
        end
    end
end
subplot(6,1,1)
plot(Stat_SMA_Matrix(:,1),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,1)) max(Stat_SMA_Matrix(:,1))])
title('SMA ACCX, WindowSize:  ' + string(win))
subplot(6,1,2)
plot(Stat_SMA_Matrix(:,2),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,2)) max(Stat_SMA_Matrix(:,2))])
title('SMA ACCY, WindowSize:  ' + string(win))
subplot(6,1,3)
plot(Stat_SMA_Matrix(:,3),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,3)) max(Stat_SMA_Matrix(:,3))])
title('SMA ACCZ, WindowSize:  ' + string(win))
subplot(6,1,4)
plot(Stat_SMA_Matrix(:,4),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,4)) max(Stat_SMA_Matrix(:,4))])
title('SMA GYROX, WindowSize:  ' + string(win))
subplot(6,1,5)
plot(Stat_SMA_Matrix(:,5),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,5)) max(Stat_SMA_Matrix(:,5))])
title('SMA GYROY, WindowSize:  ' + string(win))
subplot(6,1,6)
plot(Stat_SMA_Matrix(:,6),'Color', [1 1 1])
axis([0 length(Stat_SMA_Matrix)+10 min(Stat_SMA_Matrix(:,6)) max(Stat_SMA_Matrix(:,6))])
title('SMA GYROZ, WindowSize:  ' + string(win))
filename = "SMA_RESULTS_WINSIZE_";
filename = filename + string(win) + ".fig";
savefig(char(filename))
toPNG = plot([seperators(divider) seperators(divider)], [-.02 .02]);
filename = char(filename);
filename = filename(1:end-4);
filename = filename + ".png";
filename = char(filename);
saveas(toPNG, filename)
save Stat_SMA_Matrix.mat Stat_SMA_Matrix
hold off
% Just in case copying and pasting w/o renaming
clear Stat_SMA_Matrix
close all

% CMA tests %

Stat_CMA_Matrix = wwStatTestSuite(Big_Matrix, 'CMA');  
figure
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_CMA_Matrix(:,1));
        else
            current_seperator = next_seperator;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color); 
        else
            hexVal = '#' + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
        end
    end
end
subplot(6,1,1)
plot(Stat_CMA_Matrix(:,1),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,1)) max(Stat_CMA_Matrix(:,1))])
title('CMA ACCX')
subplot(6,1,2)
plot(Stat_CMA_Matrix(:,2),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,2)) max(Stat_CMA_Matrix(:,2))])
title('CMA ACCY')
subplot(6,1,3)
plot(Stat_CMA_Matrix(:,3),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,3)) max(Stat_CMA_Matrix(:,3))])
title('CMA ACCZ')
subplot(6,1,4)
plot(Stat_CMA_Matrix(:,4),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,4)) max(Stat_CMA_Matrix(:,4))])
title('CMA GYROX')
subplot(6,1,5)
plot(Stat_CMA_Matrix(:,5),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,5)) max(Stat_CMA_Matrix(:,5))])
title('CMA GYROY')
subplot(6,1,6)
plot(Stat_CMA_Matrix(:,6),'Color', [1 1 1])
axis([0 length(Stat_CMA_Matrix)+10 min(Stat_CMA_Matrix(:,6)) max(Stat_CMA_Matrix(:,6))])
title('CMA GYROZ')
filename = "CMA_RESULTS";
filename = filename + ".fig";
savefig(char(filename))
toPNG = plot([seperators(divider) seperators(divider)], [-.02 .02]);
filename = char(filename);
filename = filename(1:end-4);
filename = filename + ".png";
filename = char(filename);
saveas(toPNG, filename)
save Stat_CMA_Matrix.mat Stat_CMA_Matrix
clear Stat_CMA_Matrix
hold off
close all

% EMA test %

Stat_Matrix = wwStatTestSuite(Big_Matrix, 'EMA', 0, alpha(1));
% identify where we should plot lines
seperators = nan(1,length(Big_Matrix));
sep_Code = nan(1,length(Big_Matrix));
index = 1;
for j = 1:length(Stat_Matrix)
    if j == 1 
        seperators(1) = 0;
        sep_Code(1) = Stat_Matrix(1,10);
        index = index + 1;
        continue
    end
    previous_Code = Stat_Matrix(j-1,10);
    current_Code = Stat_Matrix(j,10);
    if current_Code ~= previous_Code
        seperators(index) = j;
        sep_Code(index) = current_Code;
        index = index + 1;
    end
end
% assign each code a color
seperators = rmmissing(seperators);
sep_Code = rmmissing(sep_Code);
unique_Code = unique(sep_Code);
Num_of_Codes = 120;
color_Spacing = 15000000/Num_of_Codes; 
for i = 1:length(alpha)
    Stat_Matrix = wwStatTestSuite(Big_Matrix, 'EMA',0,alpha(i));
    for S_plot = 1:6
        subplot(6,1,S_plot)
        hold on
        for divider = 1:length(seperators)
            if divider == 1
                current_seperator = 0;
                next_seperator = seperators(2);
            elseif divider == length(seperators)
                current_seperator = seperators(end);
                next_seperator = length(Stat_EMA_Matrix(:,1));
            else
                current_seperator = next_seperator;
                next_seperator = seperators(divider+1);
            end
            if S_plot <= 3
                hexVal = "#" + string(sep_Code(divider)*color_Spacing);
                hexVal = char(hexVal);
                color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
                plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
                fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color);
            else
                hexVal = '#' + string(sep_Code(divider)*color_Spacing);
                hexVal = char(hexVal);
                color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
                plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
                fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
            end
        end
    end
    figure
    subplot(6,1,1)
    plot(Stat_Matrix(:,1))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA ACCX, ALPHA = ' + string(alpha(i)))
    subplot(6,1,2)
    plot(Stat_Matrix(:,2))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA ACCY, ALPHA = ' + string(alpha(i)))
    subplot(6,1,3)
    plot(Stat_Matrix(:,3))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA ACCZ, ALPHA = ' + string(alpha(i)))
    subplot(6,1,4)
    plot(Stat_Matrix(:,4))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA GYROX, ALPHA = ' + string(alpha(i)))
    subplot(6,1,5)
    plot(Stat_Matrix(:,5))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA GYROY, ALPHA = ' + string(alpha(i)))
    subplot(6,1,6)
    plot(Stat_Matrix(:,6))
    axis([0 length(Stat_EMA_Matrix)+10 min(Stat_EMA_Matrix(:,1)) max(Stat_EMA_Matrix(:,1))])
    title('EMA GYROZ, ALPHA = ' + string(alpha(i)))
    filename = "EMA_RESULTS_ALPHA__";
    salp = string(alpha(i));
    salp = replace(salp,'.','_');
    filename = filename + salp + ".fig";

    savefig(char(filename))
    toPNG = plot([seperators(divider) seperators(divider)], [-2 2]);
    filename = char(filename);
    filename = filename(1:end-4);
    filename = filename + ".png";
    filename = char(filename);
    saveas(toPNG, filename)
    filename = ['Stat_EMA_Matrix_' + char(alpha(i)) + '.mat'];
    save(filename, 'Stat_EMA_Matrix')
    hold off
    close all
end

% WMA test %

Stat_WMA_Matrix = wwStatTestSuite(Big_Matrix, 'WMA', win);  
figure
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_WMA_Matrix(:,1));
        else
            current_seperator = next_seperator;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color);
        else
            hexVal = '#' + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
        end
    end
end
subplot(6,1,1)
plot(Stat_WMA_Matrix(:,1),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,1)) max(Stat_WMA_Matrix(:,1))])
title('WMA ACCX, WindowSize:  ' + string(win))
subplot(6,1,2)
plot(Stat_WMA_Matrix(:,2),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,2)) max(Stat_WMA_Matrix(:,2))])
title('WMA ACCY, WindowSize:  ' + string(win))
subplot(6,1,3)
plot(Stat_WMA_Matrix(:,3),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,3)) max(Stat_WMA_Matrix(:,3))])
title('WMA ACCZ, WindowSize:  ' + string(win))
subplot(6,1,4)
plot(Stat_WMA_Matrix(:,4),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,4)) max(Stat_WMA_Matrix(:,4))])
title('WMA GYROX, WindowSize:  ' + string(win))
subplot(6,1,5)
plot(Stat_WMA_Matrix(:,5),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,5)) max(Stat_WMA_Matrix(:,5))])
title('WMA GYROY, WindowSize:  ' + string(win))
subplot(6,1,6)
plot(Stat_WMA_Matrix(:,6),'Color', [1 1 1])
axis([0 length(Stat_WMA_Matrix)+10 min(Stat_WMA_Matrix(:,6)) max(Stat_WMA_Matrix(:,6))])
title('WMA GYROZ, WindowSize:  ' + string(win))
filename = "WMA_RESULTS_WINSIZE_";
filename = filename + string(win) + ".fig";
savefig(char(filename))
toPNG = plot([seperators(divider) seperators(divider)], [-.02 .02]);
filename = char(filename);
filename = filename(1:end-4);
filename = filename + ".png";
filename = char(filename);
saveas(toPNG, filename)
save Stat_WMA_Matrix.mat Stat_WMA_Matrix
clear Stat_WMA_Matrix
hold off
close all

% first derivative test %

Stat_D1_Matrix = wwStatTestSuite(Big_Matrix, 'D1', 35); 
figure
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_D1_Matrix(:,1));
        else
            current_seperator = next_seperator;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color); 
        else
            hexVal = '#' + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
        end
    end
end
subplot(6,1,1)
plot(Stat_D1_Matrix(:,1),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,1)) max(Stat_D1_Matrix(:,1))])
title('1st Deriv ACCX, WindowSize:  ' + string(win))
subplot(6,1,2)
plot(Stat_D1_Matrix(:,2),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,2)) max(Stat_D1_Matrix(:,2))])
title('1st Deriv ACCY, WindowSize:  ' + string(win))
subplot(6,1,3)
plot(Stat_D1_Matrix(:,3),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,3)) max(Stat_D1_Matrix(:,3))])
title('1st Deriv ACCZ, WindowSize:  ' + string(win))
subplot(6,1,4)
plot(Stat_D1_Matrix(:,4),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,4)) max(Stat_D1_Matrix(:,4))])
title('1st Deriv GYROX, WindowSize:  ' + string(win))
subplot(6,1,5)
plot(Stat_D1_Matrix(:,5),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,5)) max(Stat_D1_Matrix(:,5))])
title('1st Deriv GYROY, WindowSize:  ' + string(win))
subplot(6,1,6)
plot(Stat_D1_Matrix(:,6),'Color', [1 1 1])
axis([0 length(Stat_D1_Matrix)+10 min(Stat_D1_Matrix(:,6)) max(Stat_D1_Matrix(:,6))])
title('1st Deriv GYROZ, WindowSize:  ' + string(win))
filename = "First_Deriv_RESULTS_WINSIZE_";
filename = filename + string(win) + ".fig";
savefig(char(filename))
toPNG = plot([seperators(divider) seperators(divider)], [-.02 .02]);
filename = char(filename);
filename = filename(1:end-4);
filename = filename + ".png";
filename = char(filename);
saveas(toPNG, filename)
save Stat_D1_Matrix.mat Stat_D1_Matrix
clear Stat_D1_Matrix
hold off
close all

% second derivative test %

Stat_D2_Matrix = wwStatTestSuite(Big_Matrix, 'D2', 35);
figure
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_D2_Matrix(:,1));
        else
            current_seperator = next_seperator;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-2 2], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2 2 2 -2], color);
        else
            hexVal = '#' + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            plot([seperators(divider) seperators(divider)], [-800 800], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-800 800 800 -800], color);
        end
    end
end
subplot(6,1,1)
plot(Stat_D2_Matrix(:,1),'Color', [1 1 1])
title('2nd Deriv ACCX, WindowSize:  ' + string(win))
subplot(6,1,2)
plot(Stat_D2_Matrix(:,2),'Color', [1 1 1])
title('2nd Deriv ACCY, WindowSize:  ' + string(win))
subplot(6,1,3)
plot(Stat_D2_Matrix(:,3),'Color', [1 1 1])
title('2nd Deriv ACCZ, WindowSize:  ' + string(win))
subplot(6,1,4)
plot(Stat_D2_Matrix(:,4),'Color', [1 1 1])
title('2nd Deriv GYROX, WindowSize:  ' + string(win))
subplot(6,1,5)
plot(Stat_D2_Matrix(:,5),'Color', [1 1 1])
title('2nd Deriv GYROY, WindowSize:  ' + string(win))
subplot(6,1,6)
plot(Stat_D2_Matrix(:,6),'Color', [1 1 1])
title('2nd Deriv GYROZ, WindowSize:  ' + string(win))
filename = "Second_Deriv_RESULTS_WINSIZE__";
filename = filename + string(win) + ".fig";
savefig(char(filename))
toPNG = plot([seperators(divider) seperators(divider)], [-.02 .02]);
filename = char(filename);
filename = filename(1:end-4);
filename = filename + ".png";
filename = char(filename);
saveas(toPNG, filename)
save Stat_D2_Matrix.mat Stat_D2_Matrix
clear Stat_D2_Matrix
hold off
close all