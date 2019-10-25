function Stat_Matrix = wwStatTestSuite(Big_Matrix, test, duration, alpha)
% developed by Jason Foster jf727@nau.edu, May 2019. This function takes a
% processed Big_Matrix and returns the result of a test under some duration
% if applicable. Tests supported are D1 for first derivative, D2 for second
% derivative, SMA for simple moving average, CMA for cumulative moving
% average, WMA for weighted moving average, EMA for exponential moving
% average, FFT for discrete fourier transform. 
% duration is how large you want your window in centiseconds, though some
% functions such as CMA wont use a window. 

%% 1st Derivative %%

if strcmpi(test, 'D1')
% Initilize arrays
diffAX = nan(length(Big_Matrix),1);
diffAY = nan(length(Big_Matrix),1);
diffAZ = nan(length(Big_Matrix),1);
diffGX = nan(length(Big_Matrix),1);
diffGY = nan(length(Big_Matrix),1);
diffGZ = nan(length(Big_Matrix),1);
n = ceil(duration/2);
count = 1;
skip = true;
for i = 2:length(Big_Matrix)
    % have we jumped time/hand?
    previous_Time = Big_Matrix(i-1,9);
    Current_Time = Big_Matrix(i,9);
    previous_hand = Big_Matrix(i-1,12);
    current_hand = Big_Matrix(i,12);
    if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
        if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
            skip = true;
            count = 0;
        end
    elseif previous_hand ~= current_hand
        skip = true;
        count = 0;
    end
    % if the window isnt max size, increase it and skip.
    if skip
        count = count + 1;
        if count == n - 1
            count = 0;
            skip = false;
            % well the previous measures are invalid too
            for k = 1:n-1
                if i == n-1
                    break
                end
                diffAX(i-k+2-n) = nan;
                diffAY(i-k+2-n) = nan;
                diffAZ(i-k+2-n) = nan;
                diffGX(i-k+2-n) = nan;
                diffGY(i-k+2-n) = nan;
                diffGZ(i-k+2-n) = nan;
            end
        end
        continue
    end
    diffAX(i) = (Big_Matrix(i,1) - Big_Matrix(i-(n-1),1))/(n-1);
    diffAY(i) = (Big_Matrix(i,2) - Big_Matrix(i-(n-1),2))/(n-1);
    diffAZ(i) = (Big_Matrix(i,3) - Big_Matrix(i-(n-1),3))/(n-1);
    diffGX(i) = (Big_Matrix(i,4) - Big_Matrix(i-(n-1),4))/(n-1);
    diffGY(i) = (Big_Matrix(i,5) - Big_Matrix(i-(n-1),5))/(n-1);
    diffGZ(i) = (Big_Matrix(i,6) - Big_Matrix(i-(n-1),6))/(n-1);
end

% Values at the end need to be tossed, too
for k = 1:n-1
    diffAX(i-k+1) = nan;
    diffAY(i-k+1) = nan;
    diffAZ(i-k+1) = nan;
    diffGX(i-k+1) = nan;
    diffGY(i-k+1) = nan;
    diffGZ(i-k+1) = nan;
end

Stat_Matrix = [diffAX,diffAY,diffAZ,diffGX,diffGY,diffGZ,Big_Matrix(:,7:12)];
return
end

%% 2nd Derivative

if strcmpi(test, 'D2')
% Initilize arrays
diffAX = nan(length(Big_Matrix),1);
diffAY = nan(length(Big_Matrix),1);
diffAZ = nan(length(Big_Matrix),1);
diffGX = nan(length(Big_Matrix),1);
diffGY = nan(length(Big_Matrix),1);
diffGZ = nan(length(Big_Matrix),1);
n = ceil(duration/2);
count = 1;
skip = true;
for i = 2:length(Big_Matrix)
    % have we jumped time/hand?
    previous_Time = Big_Matrix(i-1,9);
    Current_Time = Big_Matrix(i,9);
    previous_hand = Big_Matrix(i-1,12);
    current_hand = Big_Matrix(i,12);
    if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
        if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
            skip = true;
            count = 0;
        end
    elseif previous_hand ~= current_hand
        skip = true;
        count = 0;
    end
    % if the window isnt max size, increase it and skip.
    if skip
        count = count + 1;
        if count == n - 1
            count = 0;
            skip = false;
            for k = 1:n-1
                if i == n-1
                    break
                end
                diffAX(i-k+2-n) = nan;
                diffAY(i-k+2-n) = nan;
                diffAZ(i-k+2-n) = nan;
                diffGX(i-k+2-n) = nan;
                diffGY(i-k+2-n) = nan;
                diffGZ(i-k+2-n) = nan;
            end
        end
        continue
    end
    diffAX(i) = (Big_Matrix(i,1) - Big_Matrix(i-(n-1),1))/(n-1);
    diffAY(i) = (Big_Matrix(i,2) - Big_Matrix(i-(n-1),2))/(n-1);
    diffAZ(i) = (Big_Matrix(i,3) - Big_Matrix(i-(n-1),3))/(n-1);
    diffGX(i) = (Big_Matrix(i,4) - Big_Matrix(i-(n-1),4))/(n-1);
    diffGY(i) = (Big_Matrix(i,5) - Big_Matrix(i-(n-1),5))/(n-1);
    diffGZ(i) = (Big_Matrix(i,6) - Big_Matrix(i-(n-1),6))/(n-1);
end

for k = 1:n
    diffAX(i-k+1) = nan;
    diffAY(i-k+1) = nan;
    diffAZ(i-k+1) = nan;
    diffGX(i-k+1) = nan;
    diffGY(i-k+1) = nan;
    diffGZ(i-k+1) = nan;
end

Diff_Matrix = [diffAX,diffAY,diffAZ,diffGX,diffGY,diffGZ,Big_Matrix(:,7:12)];    

diff2AX = nan(length(Big_Matrix),1);
diff2AY = nan(length(Big_Matrix),1);
diff2AZ = nan(length(Big_Matrix),1);
diff2GX = nan(length(Big_Matrix),1);
diff2GY = nan(length(Big_Matrix),1);
diff2GZ = nan(length(Big_Matrix),1);
count = 0;
skip = true;
for i = 1:length(Big_Matrix)
    % skip nans from 1st derivative, since they are where jumps happened
    if isnan(Diff_Matrix(i,1))
        count = 0;
        skip = true;
        continue
    end
    if skip
        count = count + 1;
        if count == n - 1
            count = 0;
            skip = false;
            for k = 1:(n-1)*2
                if i == (n-1)*2
                    break
                end
                diff2AX(i-k+3-n*2) = nan;
                diff2AY(i-k+3-n*2) = nan;
                diff2AZ(i-k+3-n*2) = nan;
                diff2GX(i-k+3-n*2) = nan;
                diff2GY(i-k+3-n*2) = nan;
                diff2GZ(i-k+3-n*2) = nan;
            end
        end
        continue
    end
    
    diff2AX(i) = diffAX(i,1) - diffAX(i-(n-1),1)/(n-1);
    diff2AY(i) = diffAY(i,1) - diffAY(i-(n-1),1)/(n-1);
    diff2AZ(i) = diffAZ(i,1) - diffAZ(i-(n-1),1)/(n-1);
    diff2GX(i) = diffGX(i,1) - diffGX(i-(n-1),1)/(n-1);
    diff2GY(i) = diffGY(i,1) - diffGY(i-(n-1),1)/(n-1);
    diff2GZ(i) = diffGZ(i,1) - diffGZ(i-(n-1),1)/(n-1);
end
    
for k = 1:(n-1)*2
    diff2AX(i-k+1) = nan;
    diff2AY(i-k+1) = nan;
    diff2AZ(i-k+1) = nan;
    diff2GX(i-k+1) = nan;
    diff2GY(i-k+1) = nan;
    diff2GZ(i-k+1) = nan;
end

Stat_Matrix = [diff2AX,diff2AY,diff2AZ,diff2GX,diff2GY,diff2GZ,Big_Matrix(:,7:12)];
return 
end

%% Simple Moving Average %%

if strcmpi(test, 'SMA')
    % initilize my arrays
    n = ceil(duration/2);
    AX = nan(length(Big_Matrix),1);
    AY = nan(length(Big_Matrix),1);
    AZ = nan(length(Big_Matrix),1);
    GX = nan(length(Big_Matrix),1);
    GY = nan(length(Big_Matrix),1);
    GZ = nan(length(Big_Matrix),1);
    skip = true;
    count = 1;
    for i = 2:length(Big_Matrix)
        % check to see if moving our window occurs during a jump in
        % time/jump in hand. If so reset the window.
        previous_Time = Big_Matrix(i-1,9);
        Current_Time = Big_Matrix(i,9);
        previous_hand = Big_Matrix(i-1,12);
        current_hand = Big_Matrix(i,12);
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                skip = true;
                count = 0;
            end
        elseif previous_hand ~= current_hand
            skip = true;
            count = 0;
        end
        % if our window is not at its max size
        if skip
            % increase my skip counter(window size) and do nothing
            count = count+1;
            % Unless the next increase gets us to our max window size
            if count == n - 1
                skip = false;
                for k = 1:n-1
                    if i == n-1
                        break
                    end
                AX(i-k+2-n) = nan;
                AY(i-k+2-n) = nan;
                AZ(i-k+2-n) = nan;
                GX(i-k+2-n) = nan;
                GY(i-k+2-n) = nan;
                GZ(i-k+2-n) = nan;
                end
            end
            continue
        end    
        % window is max size, use formula from wikipedia to calculate next
        % PSM___ and store value in array
        AX(i) = mean(Big_Matrix(i-(n-1):i,1));
        AY(i) = mean(Big_Matrix(i-(n-1):i,2));
        AZ(i) = mean(Big_Matrix(i-(n-1):i,3));
        GX(i) = mean(Big_Matrix(i-(n-1):i,4));
        GY(i) = mean(Big_Matrix(i-(n-1):i,5));
        GZ(i) = mean(Big_Matrix(i-(n-1):i,6));
    end
    % Stick my output into Big_Matrix and return it
    
for k = 1:n-1
    AX(i-k+1) = nan;
    AY(i-k+1) = nan;
    AZ(i-k+1) = nan;
    GX(i-k+1) = nan;
    GY(i-k+1) = nan;
    GZ(i-k+1) = nan;
end
    
    Stat_Matrix = [AX,AY,AZ,GX,GY,GZ,Big_Matrix(:,7:12)];   
    return
end

%% Cumulative Moving Average %%

if strcmpi(test, 'CMA')
    % initilize my arrays
    CMAAX = 0;
    CMAAY = 0;
    CMAAZ = 0;
    CMAGX = 0;
    CMAGY = 0;
    CMAGZ = 0;
    AX = nan(length(Big_Matrix),1);
    AY = nan(length(Big_Matrix),1);
    AZ = nan(length(Big_Matrix),1);
    GX = nan(length(Big_Matrix),1);
    GY = nan(length(Big_Matrix),1);
    GZ = nan(length(Big_Matrix),1);
    n = 0;
    skip = true;
    for i = 1:length(Big_Matrix)  
        % if we are just starting our cumualtive average
        n = n + 1;
        if i == 1
            CMAAX = Big_Matrix(1,1);
            CMAAY = Big_Matrix(1,2);
            CMAAZ = Big_Matrix(1,3);
            CMAGX = Big_Matrix(1,4);
            CMAGY = Big_Matrix(1,5);
            CMAGZ = Big_Matrix(1,6);
            AX(i) = CMAAX;
            AY(i) = CMAAY;
            AZ(i) = CMAAZ;
            GX(i) = CMAGX;
            GY(i) = CMAGY;
            GZ(i) = CMAGZ;
            skip = false;
            continue
        end
        % if we have a break in time or a different hand
        previous_Time = Big_Matrix(i-1,9);
        Current_Time = Big_Matrix(i,9);
        previous_hand = Big_Matrix(i-1,12);
        current_hand = Big_Matrix(i,12);
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                n = 0;
                skip = true;
            end
        elseif current_hand ~= previous_hand
            n = 0;
            skip = true;
        end
        if skip
            CMAAX = Big_Matrix(i,1);
            CMAAY = Big_Matrix(i,2);
            CMAAZ = Big_Matrix(i,3);
            CMAGX = Big_Matrix(i,4);
            CMAGY = Big_Matrix(i,5);
            CMAGZ = Big_Matrix(i,6);
            AX(i) = CMAAX;
            AY(i) = CMAAY;
            AZ(i) = CMAAZ;
            GX(i) = CMAGX;
            GY(i) = CMAGY;
            GZ(i) = CMAGZ;
            skip = false;
            n = n + 1;
            continue
        end

        % we havent skipped
        CMAAX = CMAAX + (Big_Matrix(i,1) - CMAAX)/(n);
        CMAAY = CMAAY + (Big_Matrix(i,2) - CMAAY)/(n);
        CMAAZ = CMAAZ + (Big_Matrix(i,3) - CMAAZ)/(n);
        CMAGX = CMAGX + (Big_Matrix(i,4) - CMAGX)/(n);
        CMAGY = CMAGY + (Big_Matrix(i,5) - CMAGY)/(n);
        CMAGZ = CMAGZ + (Big_Matrix(i,6) - CMAGZ)/(n);
        AX(i) = CMAAX;
        AY(i) = CMAAY;
        AZ(i) = CMAAZ;
        GX(i) = CMAGX;
        GY(i) = CMAGY;
        GZ(i) = CMAGZ;
    end
    
Stat_Matrix = [AX,AY,AZ,GX,GY,GZ,Big_Matrix(:,7:12)];   
return
end

%% Weighted Moving Average %% 

if strcmpi(test,'WMA')
    % initilize my arrays
    n = ceil(duration/2);
    weights = gausswin(n)';
    denominator = sum(weights);
    AX = nan(length(Big_Matrix),1);
    AY = nan(length(Big_Matrix),1);
    AZ = nan(length(Big_Matrix),1);
    GX = nan(length(Big_Matrix),1);
    GY = nan(length(Big_Matrix),1);
    GZ = nan(length(Big_Matrix),1);
    skip = true;
    count = 1;
    for i = 2:length(Big_Matrix)
        % Skip if we encounter a jump in time/change of hand
        previous_Time = Big_Matrix(i-1,9);
        Current_Time = Big_Matrix(i,9);
        previous_hand = Big_Matrix(i-1,12);
        current_hand = Big_Matrix(i,12);
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                skip = true;
                count = 0;
            end
        elseif previous_hand ~= current_hand
            skip = true;
            count = 0;
        end
        % If we arent at max window size
        if skip
            % do nothing and increase window size
            count = count+1;
            % unless our next increase maxes window size.
            if count == n - 1
                skip = false;
                count = 0;
                for k = 1:n-1
                    if i == n-1
                        break
                    end
                    AX(i-k+2-n) = nan;
                    AY(i-k+2-n) = nan;
                    AZ(i-k+2-n) = nan;
                    GX(i-k+2-n) = nan;
                    GY(i-k+2-n) = nan;
                    GZ(i-k+2-n) = nan;
                end
            end
            continue
        end
        % No skip necessary
        WMAAX = 0;
        WMAAY = 0;
        WMAAZ = 0;
        WMAGX = 0;
        WMAGY = 0;
        WMAGZ = 0;
        for k = 1:n
            WMAAX = WMAAX + weights(k)*Big_Matrix(i-(k-1),1)/denominator;
            WMAAY = WMAAY + weights(k)*Big_Matrix(i-(k-1),2)/denominator;
            WMAAZ = WMAAZ + weights(k)*Big_Matrix(i-(k-1),3)/denominator;
            WMAGX = WMAGX + weights(k)*Big_Matrix(i-(k-1),4)/denominator;
            WMAGY = WMAGY + weights(k)*Big_Matrix(i-(k-1),5)/denominator;
            WMAGZ = WMAGZ + weights(k)*Big_Matrix(i-(k-1),6)/denominator;
        end
        AX(i) = WMAAX;
        AY(i) = WMAAY;
        AZ(i) = WMAAZ;
        GX(i) = WMAGX;
        GY(i) = WMAGY;
        GZ(i) = WMAGZ;
    end
    
for k = 1:n-1
    AX(i-k+1) = nan;
    AY(i-k+1) = nan;
    AZ(i-k+1) = nan;
    GX(i-k+1) = nan;
    GY(i-k+1) = nan;
    GZ(i-k+1) = nan;
end
    
    Stat_Matrix = [AX,AY,AZ,GX,GY,GZ,Big_Matrix(:,7:12)];   
    return
end

%% Exponential Moving Average %%

if strcmpi(test,'EMA')
    % initilize arrays
    AX = nan(length(Big_Matrix),1);
    AY = nan(length(Big_Matrix),1);
    AZ = nan(length(Big_Matrix),1);
    GX = nan(length(Big_Matrix),1);
    GY = nan(length(Big_Matrix),1);
    GZ = nan(length(Big_Matrix),1);
    EMAAX = 0;
    EMAAY = 0;
    EMAAZ = 0;
    EMAGX = 0;
    EMAGY = 0;
    EMAGZ = 0;
    skip = true;
    for i = 1:length(Big_Matrix)   
        if i == 1
            EMAAX = Big_Matrix(i,1);
            EMAAY = Big_Matrix(i,2);
            EMAAZ = Big_Matrix(i,3);
            EMAGX = Big_Matrix(i,4);
            EMAGY = Big_Matrix(i,5);
            EMAGZ = Big_Matrix(i,6);
            AX(i) = EMAAX;
            AY(i) = EMAAY;
            AZ(i) = EMAAZ;
            GX(i) = EMAGX;
            GY(i) = EMAGY;
            GZ(i) = EMAGZ;
            skip = false;
            continue
        end
        previous_hand = Big_Matrix(i-1,12);
        current_hand = Big_Matrix(i,12);
        previous_Time = Big_Matrix(i-1,9);
        Current_Time = Big_Matrix(i,9);
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                skip = true;
            end
        elseif current_hand ~= previous_hand
            skip = true;
        end
        if skip
            EMAAX = Big_Matrix(i,1);
            EMAAY = Big_Matrix(i,2);
            EMAAZ = Big_Matrix(i,3);
            EMAGX = Big_Matrix(i,4);
            EMAGY = Big_Matrix(i,5);
            EMAGZ = Big_Matrix(i,6);
            AX(i) = EMAAX;
            AY(i) = EMAAY;
            AZ(i) = EMAAZ;
            GX(i) = EMAGX;
            GY(i) = EMAGY;
            GZ(i) = EMAGZ;
            skip = false;
            continue
        end
        
        EMAAX = alpha*Big_Matrix(i,1)+(1-alpha)*EMAAX;
        EMAAY = alpha*Big_Matrix(i,2)+(1-alpha)*EMAAY;
        EMAAZ = alpha*Big_Matrix(i,3)+(1-alpha)*EMAAZ;
        EMAGX = alpha*Big_Matrix(i,4)+(1-alpha)*EMAGX;
        EMAGY = alpha*Big_Matrix(i,5)+(1-alpha)*EMAGY;
        EMAGZ = alpha*Big_Matrix(i,6)+(1-alpha)*EMAGZ;
        AX(i) = EMAAX;
        AY(i) = EMAAY;
        AZ(i) = EMAAZ;
        GX(i) = EMAGX;
        GY(i) = EMAGY;
        GZ(i) = EMAGZ;
    end
    
Stat_Matrix = [AX,AY,AZ,GX,GY,GZ,Big_Matrix(:,7:12)];   
return    
end

%% Fast Fourier Transform %%

if strcmpi(test, 'FFT')
    AX = nan(length(Big_Matrix),1);
    AY = nan(length(Big_Matrix),1);
    AZ = nan(length(Big_Matrix),1);
    GX = nan(length(Big_Matrix),1);
    GY = nan(length(Big_Matrix),1);
    GZ = nan(length(Big_Matrix),1);
    fftAX = 0;
    fftAY = 0;
    fftAZ = 0;
    fftGX = 0;
    fftGY = 0;
    fftGZ = 0;
    skip = false;
    count = 0;
    for i = 1:length(Big_Matrix)   
        if skip
            count = count + 1;
            if count == duration
                count = 0;
                skip = false;
            end
            continue
        end
        previous_Time = Big_Matrix(duration+i-1,9);
        Current_Time = Big_Matrix(duration+i,9);
        if ~strcmp(num2str(Current_Time - previous_Time), '0.01')
            if ~strcmp(num2str(Current_Time - previous_Time), '-59.99')
                skip = true;
                continue
            end
        end
        fftAX = fft(Big_Matrix(i:i+duration,1),11);
        fftAY = 0;
        fftAZ = 0;
        fftGX = 0;
        fftGY = 0;
        fftGZ = 0;
        AX(i) = fftAX;
        AY(i) = fftAY;
        AZ(i) = fftAZ;
        GX(i) = fftGX;
        GY(i) = fftGY;
        GZ(i) = fftGZ;
        
        
        
    end
    
Stat_Matrix = [AX,AY,AZ,GX,GY,GZ,Big_Matrix(:,7:12)];   
return   
end

%% Recurrent Nueral Network %%

if strcmpi(test, 'RNN')
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

%% Hidden Markov Model %%

if strcmpi(test, 'HMM')
    
    
    
    
    
    
    
    
    
    
    
    
end

end