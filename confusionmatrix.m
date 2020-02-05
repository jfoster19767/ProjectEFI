function confusionmatrix(varargin)
% confusionmatrix(A, B)
%      A(1)  A(2) ...
% B(1)
% B(2)
% ...
% Kyle Winfree, kyle.winfree@nau.edu
% December 2017
% This function is part of the WearWare Toolkit and is covered by the GNU GPL3
% Jason Foster, jf727@nau.edu
% November 2019
% Feburary 2020
% confusionmatrix(A,B) will give a basic matrix, though it doesnt seem to
% work properly.
% confusionmatrix(A,B,'%') will give a basic matrix with percents, this one
% works properly.
% confusionmatrix(A,B,'%',[code1,code2,...]) will return the confusion
% matrix and the submatrix containing only the codes you are interested in.
% if you dont want to make a sub matrix then your call will be 
% confusionmatrix(A,B,'%',[])
% confusionmatrix(A,B,'%',[code1,code2,...], Tolerance) will return the
% matrixes excluding those whose values fall bellow tolerance. I.E. if you
% dont want the measure if it has less than 5% of the total data then you
% would call confusionmatrix(A,B,'%',[code1,code2,...], 5)

switch nargin
	case 2
		A = varargin{1};
		B = varargin{2};
		percents_too = false;
		tabsize = '\t';
	case 3
		A = varargin{1};
		B = varargin{2};
		percents_too = varargin{3};
		if (strcmp('percent', percents_too) || strcmp('%', percents_too))
			percents_too = true;
			tabsize = '\t\t\t';
		else
			percents_too = false;
			tabsize = '\t';
        end
    case 4
        A = varargin{1};
		B = varargin{2};
		percents_too = varargin{3};
		if (strcmp('percent', percents_too) || strcmp('%', percents_too))
			percents_too = true;
			tabsize = '\t\t\t';
		else
			percents_too = false;
			tabsize = '\t';
        end
        Special_Codes = varargin{4};
    case 5
        A = varargin{1};
		B = varargin{2};
		percents_too = varargin{3};
		if (strcmp('percent', percents_too) || strcmp('%', percents_too))
			percents_too = true;
			tabsize = '\t\t\t';
		else
			percents_too = false;
			tabsize = '\t';
        end
        Special_Codes = varargin{4};
        Tolerance = varargin{5};
end
		
Aset = unique(A);
Bset = unique(B);

if ~exist('Tolerance','var')
    Tolerance = 0;
end

prtline = '\t';
% Print number of occurances for A(0) A(1) ......
% Print all of the A(0) A(1) ..... 
for a = 1:length(Aset)
    if a == 1
        untab = false;
        if length([num2str(sum(A == Aset(a))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)']) >= 13
            untab = true;
        else
            untab = false;
        end
        prtline = [prtline, '\t\t\t\t\t', num2str(sum(A == Aset(a)))];
        if percents_too
        	prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)'];
        end
    else
        if untab
            prtline = [prtline, '\t\t\t', num2str(sum(A == Aset(a)))];
        else
            prtline = [prtline, '\t\t\t\t', num2str(sum(A == Aset(a)))];
        end
        if length([num2str(sum(A == Aset(a))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)']) >= 13
            untab = true;
        else
            untab = false;
        end
        if percents_too
        	prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)'];
        end
    end
end
fprintf([prtline, '\n']);

if percents_too
	prtline = '\t\t\t\t\t\t';
else
	prtline = '\t';
end

for a = 1:length(Aset)
    if length(['A(', num2str(Aset(a)), ')']) >= 8
        untab = true; 
    else
        untab = false;            
    end
    if untab
        prtline = [prtline, 'A(', num2str(Aset(a)), ')', '\t\t\t\t'];
    else
        prtline = [prtline, 'A(', num2str(Aset(a)), ')', '\t\t\t\t\t'];
    end
end
fprintf([prtline, '\n'])

% Print B(0) 
% B(1)
% ....
% and the number of occurances of B(x) that were labeled A(x)
for b = 1:length(Bset)
    untab = false;
	prtline = ['\t', 'B(', num2str(Bset(b)), ')'];
	for a = 1:length(Aset)
		% find each instance of A(a) where it was classified as B(b)
        % try to line up all info so that I dont have to manually remove
        % excess \t
        if 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a)) < Tolerance
            prtline = [prtline, '\t\t\t\t\t\t'];
            continue
        end
        if a == 1
            if length(['B(', num2str(Bset(b)), ')']) >= 8
                untab = true; 
            else
                untab = false;            
            end
        end
        if untab
            prtline = [prtline, '\t\t\t', num2str(sum(A == Aset(a) & B == Bset(b)))];
        else
            prtline = [prtline, '\t\t\t\t', num2str(sum(A == Aset(a) & B == Bset(b)))];
        end
        if length([num2str(sum(A == Aset(a) & B == Bset(b))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a))), '%%)']) >= 13
            untab = true; 
        else
            untab = false;            
        end
		if percents_too
			prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a))), '%%)'];
		end
	end
	fprintf([prtline, '\n']);
end


% Generate the submatrix
if nargin >= 4
fprintf('\n');
fprintf('SubMatrix:   ');
fprintf('\n');
Aset = zeros(1,length(Special_Codes));
Bset = zeros(1,length(Special_Codes));

for i = 1:length(Special_Codes)    
    Aset(i) = Special_Codes(i);
    Bset(i) = Special_Codes(i);
end

Aset = string(Aset);
Bset = string(Bset);
prtline = '\t';
% Print number of occurances for A(0) A(1) ......
% Print all of the A(0) A(1) ..... 
for a = 1:length(Aset)
    if a == 1
        untab = false;
        if length([num2str(sum(A == Aset(a))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)']) >= 13
            untab = true;
        else
            untab = false;
        end
        prtline = [prtline, '\t\t\t\t\t', num2str(sum(A == Aset(a)))];
        if percents_too
        	prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)'];
        end
    else
        if untab
            prtline = [prtline, '\t\t\t', num2str(sum(A == Aset(a)))];
        else
            prtline = [prtline, '\t\t\t\t', num2str(sum(A == Aset(a)))];
        end
        if length([num2str(sum(A == Aset(a))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)']) >= 13
            untab = true;
        else
            untab = false;
        end
        if percents_too
        	prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a)) / length(A))), '%%)'];
        end
    end
end
fprintf([prtline, '\n']);

if percents_too
	prtline = '\t\t\t\t\t\t';
else
	prtline = '\t';
end

for a = 1:length(Aset)
    if length(['A(', num2str(Aset(a)), ')']) >= 8
        untab = true; 
    else
        untab = false;            
    end
    if untab
        prtline = [prtline, 'A(', num2str(Aset(a)), ')', '\t\t\t\t'];
    else
        prtline = [prtline, 'A(', num2str(Aset(a)), ')', '\t\t\t\t\t'];
    end
end
fprintf([prtline, '\n'])

% Print B(0) 
% B(1)
% ....
% and the number of occurances of B(x) that were labeled A(x)
for b = 1:length(Bset)
    untab = false;
	prtline = ['\t', 'B(', num2str(Bset(b)), ')'];
	for a = 1:length(Aset)
		% find each instance of A(a) where it was classified as B(b)
        % try to line up all info so that I dont have to manually remove
        % excess \t
        if 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a)) < Tolerance
            prtline = [prtline, '\t\t\t\t\t\t'];
            continue
        end
        if a == 1
            if length(['B(', num2str(Bset(b)), ')']) >= 8
                untab = true; 
            else
                untab = false;            
            end
        end
        if untab
            prtline = [prtline, '\t\t\t', num2str(sum(A == Aset(a) & B == Bset(b)))];
        else
            prtline = [prtline, '\t\t\t\t', num2str(sum(A == Aset(a) & B == Bset(b)))];
        end
        if length([num2str(sum(A == Aset(a) & B == Bset(b))), ' (', sprintf('%1.2f', 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a))), '%%)']) >= 13
            untab = true; 
        else
            untab = false;            
        end
		if percents_too
			prtline = [prtline, ' (', sprintf('%1.2f', 100*(sum(A == Aset(a) & B == Bset(b))) / sum(A == Aset(a))), '%%)'];
		end
	end
	fprintf([prtline, '\n']);
end
end