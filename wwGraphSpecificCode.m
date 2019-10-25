function wwGraphSpecificCode(Stat_XXX_Matrix, Codes)
% Developed by Jason Foster, jf727@nau.edu, June 2019
% This function takes in a array of codes and a stat_matrix and returns the
% plots with only those codes. 
% Stat_XXX_Matrix is a matrix generated by StatTest and codes is an array
% of codes, [26, 36, 47]. One way to call this function is
% wwGraphSpecificCode(Stat_CMA_Matrix, [26, 36, 47])

% Regenerate our original plot, with seperators, colors and indexes
seperators = nan(1,length(Stat_XXX_Matrix));
win = 35;
sep_Code = nan(1,length(Stat_XXX_Matrix));
index = 1;
for j = 1:length(Stat_XXX_Matrix)
    if j == 1 
        seperators(1) = 0;
        sep_Code(1) = Stat_XXX_Matrix(1,10);
        index = index + 1;
        continue
    end
    previous_Code = Stat_XXX_Matrix(j-1,10);
    current_Code = Stat_XXX_Matrix(j,10);
    previous_Time = Stat_XXX_Matrix(j-1,9);
    Current_Time = Stat_XXX_Matrix(j,9);
    if current_Code ~= previous_Code
        seperators(index) = j-1;
        sep_Code(index) = current_Code;
        index = index + 1;
    elseif ~strcmp(num2str(Current_Time - previous_Time), '0.01')
        if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
            seperators(index) = j-1;
            sep_Code(index) = current_Code;
            index = index + 1;
        end
    end
end
seperators = rmmissing(seperators);
sep_Code = rmmissing(sep_Code);
unique_Code = unique(sep_Code);
Num_of_Codes = 120;
color_Spacing = 15000000/Num_of_Codes; 

% Now cut out the matrix so that only the codes of interest remain
% Also remove the seperator if we need to

for i = 1:length(sep_Code)
    if ~ismember(sep_Code(i), Codes)
        sep_Code(i) = nan;
    end
end

% if code doesnt exist in our data remove it and notify the user, If no
% codes exist then end the function.

toRemove = true;

for i = 1:length(Codes)
    toRemove = true;
    for j = 1:length(sep_Code)
        if sep_Code(j) == Codes(i)
            toRemove = false;
        end
    end
    if toRemove
        disp("Removing Code " + num2str(Codes(i)) + ", Code does not exist in this dataset");
        Codes(i) = nan;
    end
end

Codes = rmmissing(Codes);

if isempty(Codes)
    disp('No Codes of interest exist in this dataset, function ending');
    return
end
        

% Lets remove most of the blank space
% First plot the first part at the start, when we reach a nan we let some
% stay for padding, then cut the rest. we keep track of how much we cut out
% and apply that to seperators so the plots still line up.

Specific_Stat_Matrix = nan(2*length(Stat_XXX_Matrix),12);
Specific_Stat_Index = 1;

for i = 1:length(seperators)
    if isnan(sep_Code(i))
        continue
    end
    time_Jump = false;
    if i == 1
        Specific_Stat_Matrix(1:1+seperators(2)-seperators(1)-1,:) = Stat_XXX_Matrix(seperators(1)+1:seperators(2),:);
        Specific_Stat_Index = 1+seperators(2)-seperators(1);
        continue
    end
    if i == length(seperators)
        previous_code = sep_Code(end-1);
        if isnan(previous_code)
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+win,:) = 0;
            Specific_Stat_Index = Specific_Stat_Index + win;
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+length(Stat_XXX_Matrix)-seperators(end)-1,:) = Stat_XXX_Matrix(seperators(end)+1:end,:);  
            continue
        end
        
        previous_Time = Stat_XXX_Matrix(seperators(end-1),9);
        Current_Time = Stat_XXX_Matrix(seperators(end-1)+1,9);
        next_code = sep_Code(end);
        
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                time_Jump = true;
            end
        end
        
        if previous_code ~= next_code && time_Jump
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+win,:) = 0;
            Specific_Stat_Index = Specific_Stat_Index + win;
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+length(Stat_XXX_Matrix)-seperators(end)-1,:) = Stat_XXX_Matrix(seperators(end)+1:end,:);  
            continue
        elseif previous_code ~= next_code && ~time_Jump
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+length(Stat_XXX_Matrix)-seperators(end)-1,:) = Stat_XXX_Matrix(seperators(end)+1:end,:);  
            continue
        else
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+win,:) = 0;
            Specific_Stat_Index = Specific_Stat_Index + win;
            Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+length(Stat_XXX_Matrix)-seperators(end)-1,:) = Stat_XXX_Matrix(seperators(end)+1:end,:);  
            continue
        end
    end
    
    if Specific_Stat_Index == 1
        Specific_Stat_Matrix(1:1+seperators(i+1)-seperators(i)-1,:) = Stat_XXX_Matrix(seperators(i)+1:seperators(i+1),:);
        Specific_Stat_Index = 1+seperators(i+1)-seperators(i);
        continue
    end
    
    current_code = sep_Code(i);
    next_code = sep_Code(i+1);
    Current_Time = Stat_XXX_Matrix(seperators(i),9);
    Future_Time = Stat_XXX_Matrix(seperators(i)+1,9);
 
    if ~strcmp(num2str(Current_Time - Future_Time), '0.01')
        if ~strcmp(num2str(Current_Time - Future_Time), '-59.99')
            time_Jump = true;
        end
    end
    
    if current_code ~= next_code && time_Jump
        Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+win,:) = 0;
        Specific_Stat_Index = Specific_Stat_Index + win;
        Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+seperators(i+1)-seperators(i)-1,:) = Stat_XXX_Matrix(seperators(i)+1:seperators(i+1),:);
        Specific_Stat_Index = Specific_Stat_Index+seperators(i+1)-seperators(i);
        continue
    elseif current_code ~= next_code && ~time_Jump
        Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+seperators(i+1)-seperators(i)-1,:) = Stat_XXX_Matrix(seperators(i)+1:seperators(i+1),:);
        Specific_Stat_Index = Specific_Stat_Index+seperators(i+1)-seperators(i);
        continue
    else
        Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+win,:) = 0;
        Specific_Stat_Index = Specific_Stat_Index + win;
        Specific_Stat_Matrix(Specific_Stat_Index:Specific_Stat_Index+seperators(i+1)-seperators(i)-1,:) = Stat_XXX_Matrix(seperators(i)+1:seperators(i+1),:);
        Specific_Stat_Index = Specific_Stat_Index+seperators(i+1)-seperators(i);
        continue
    end     
end

% now plot our new figure

cutoff = find(isnan(Specific_Stat_Matrix(:,10)));
cutoff = cutoff(1)-1;
Specific_Stat_Matrix = Specific_Stat_Matrix(1:cutoff,:);
Stat_XXX_Matrix = Specific_Stat_Matrix;

seperators = nan(1,length(Stat_XXX_Matrix));
win = 35;
sep_Code = nan(1,length(Stat_XXX_Matrix));
index = 1;
for j = 1:length(Stat_XXX_Matrix)
    if j == 1 
        seperators(1) = 0;
        sep_Code(1) = Stat_XXX_Matrix(1,10);
        index = index + 1;
        continue
    end
    previous_Code = Stat_XXX_Matrix(j-1,10);
    current_Code = Stat_XXX_Matrix(j,10);
    previous_Time = Stat_XXX_Matrix(j-1,9);
    Current_Time = Stat_XXX_Matrix(j,9);
    if current_Code ~= previous_Code
        seperators(index) = j-1;
        sep_Code(index) = current_Code;
        index = index + 1;
        continue
    elseif ~strcmp(num2str(Current_Time - previous_Time), '0.01')
        if current_Code == 0 
            continue
        end
        if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
            seperators(index) = j-1;
            sep_Code(index) = current_Code;
            index = index + 1;
        end
        continue
    end
end
sep_Code = rmmissing(sep_Code);
seperators = rmmissing(seperators);

Num_of_Codes = 120;
color_Spacing = 15000000/Num_of_Codes;

for i = 1:length(Stat_XXX_Matrix)
    if Stat_XXX_Matrix(i,10) == 0
        Stat_XXX_Matrix(i,:) = nan;
    end
end

figure
max13 = max(max(abs(Stat_XXX_Matrix(:,1:3))));
max46 = max(max(abs(Stat_XXX_Matrix(:,4:6))));
for S_plot = 1:6
    subplot(6,1,S_plot)
    hold on
    for divider = 1:length(seperators)
        if divider == 1
            current_seperator = 0;
            next_seperator = seperators(2);
        elseif divider == length(seperators)
            current_seperator = seperators(end);
            next_seperator = length(Stat_XXX_Matrix(:,1));
        else
            current_seperator = seperators(divider)+1;
            next_seperator = seperators(divider+1);
        end
        if S_plot <= 3
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            if color == 0
                color = [1 1 1];
            end
            plot([current_seperator current_seperator], [-2*max13 2*max13], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2*max13 2*max13 2*max13 -2*max13], color);                 
        else
            hexVal = "#" + string(sep_Code(divider)*color_Spacing);
            hexVal = char(hexVal);
            color = sscanf(hexVal(2:end),'%2x%2x%2x',[1 3])/255;
            if color == 0
                color = [1 1 1];
            end
            plot([current_seperator current_seperator], [-2*max46 2*max46], 'Color', color);
            fill([current_seperator current_seperator next_seperator next_seperator],[-2*max46 2*max46 2*max46 -2*max46], color); 
        end
    end
end

% so my titles can be accurate, lets get the name of the test

test = inputname(1);
testIndex = find(test == '_');

subplot(6,1,1)
plot(Stat_XXX_Matrix(:,1),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max13 2*max13])
title([test(testIndex(1)+1:testIndex(2)-1), ' ACCX, WindowSize:  ' + string(win)])
subplot(6,1,2)
plot(Stat_XXX_Matrix(:,2),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max13 2*max13])
title([test(testIndex(1)+1:testIndex(2)-1), ' ACCY, WindowSize:  ' + string(win)])
subplot(6,1,3)
plot(Stat_XXX_Matrix(:,3),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max13 2*max13])
title([test(testIndex(1)+1:testIndex(2)-1), ' ACCZ, WindowSize:  ' + string(win)])
subplot(6,1,4)
plot(Stat_XXX_Matrix(:,4),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max46 2*max46])
title([test(testIndex(1)+1:testIndex(2)-1), ' GYROX, WindowSize:  ' + string(win)])
subplot(6,1,5)
plot(Stat_XXX_Matrix(:,5),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max46 2*max46])
title([test(testIndex(1)+1:testIndex(2)-1), ' GYROY, WindowSize:  ' + string(win)])
subplot(6,1,6)
plot(Stat_XXX_Matrix(:,6),'Color', [1 1 1])
axis([0 length(Stat_XXX_Matrix)+10 -2*max46 2*max46])
title([test(testIndex(1)+1:testIndex(2)-1), ' GYROZ, WindowSize:  ' + string(win)])

end