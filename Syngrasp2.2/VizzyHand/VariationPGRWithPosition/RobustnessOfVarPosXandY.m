% In this script, it is evaluated how PGR behave when a position in x and y
% axis changes a little bit of its initial position. The initial grasp is a
% Powergrasp.
clear all; close all; clc;

% With help of Syn_GUI, I saw that between this range of values, the grasp
% is stable, let's see the plot to be sure
load('CubePos.mat');
obj0 = obj;
hand0 = VizzyHandModel;
hand0.S = hand.S;
PGRtypes = ["BF", "H2", "H3", "H4"]; % PGR different types to be computed
x = 65:3:85;
y = -25:4:4;

[X,Y] = meshgrid(x,y);
n_rows = size(X,1);
n_col = size(X,2);
PGR = zeros(n_rows, n_col);
%%
for i = 1: n_rows
    waitbar(i/n_rows);
    
    for j = 1: n_col
        % Reset hand and obj
        hand =  hand0;
        obj = obj0;
        obj.center(1) = X(i,j);
        obj.center(2) = Y(i,j);
        rot = zeros(3,1);
        obj = SGrebuildObject(obj, obj.center, rot); % Rebuilds a new object
    
        % Close the hand
        [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj);
        
        % Quality metrics
        ind = (i-1)*n_col +j;
        Title = ['Pos: (x,y)= (',num2str(X(i,j)),',' num2str(Y(i,j)),')'];
        tic
        PGR_ = ComputePGRWithBFandHeur(hand, obj, 'BF');
        %Plot1Hand_Object(hand, obj, Title, PGR,ind);
        toc
        PGR(i,j) = PGR_.BF;
    end
    close all;
end
figure();
surf(X,Y,PGR);


%% Variation in the X axis

% How much mm can an object move and the grasp is still be considered stable

% Pre allocation of memory
for type = PGRtypes
    xPosLen.(type) = zeros(n_rows, n_col);
end


for i = 1: n_rows
    waitbar(i/n_rows);
    
    for j = 1: n_col
        % Reset hand and obj
        hand =  hand0;
        obj = obj0;
        obj.center(1) = X(i,j);
        obj.center(2) = Y(i,j);
        rot = zeros(3,1);
        obj = SGrebuildObject(obj, obj.center, rot); % Rebuilds a new object

        axisGrasps = ComputePosVariance41Axis(obj, 'x', 5, 5, PGRtypes);
        for type = PGRtypes
            xPosLen.(type)(i,j) = axisGrasps.PosLen.(type);
        end
    end
    close all;
end

%%
for type = PGRtypes
    figure();
    surf(X,Y,xPosLen.(type));
    xlabel('X')
    ylabel('Y');
    zlabel('Maxvar in Xaxis')
    titl = sprintf('(X,Y)-> obj center Pos\n(Z)-> Max X Var a grasp can resist\n PGR=%s',type);
    title(titl);
end

%% Variation in the Y axis

% How much mm can an object move and the grasp is still be considered stable

% Pre allocation of memory
for type = PGRtypes
    yPosLen.(type) = zeros(n_rows, n_col);
end



for i = 1: n_rows
    waitbar(i/n_rows);
    
    for j = 1: n_col
        % Reset hand and obj
        hand =  hand0;
        obj = obj0;
        obj.center(1) = X(i,j);
        obj.center(2) = Y(i,j);
        rot = zeros(3,1);
        obj = SGrebuildObject(obj, obj.center, rot); % Rebuilds a new object

        axisGrasps = ComputePosVariance41Axis(obj, 'y', 5, 5, PGRtypes);
        for type = PGRtypes
            yPosLen.(type)(i,j) = axisGrasps.PosLen.(type);
        end
    end
    close all;
end

%%
for type = PGRtypes
    figure();
    surf(X,Y,yPosLen.(type));
    xlabel('X')
    ylabel('Y');
    zlabel('Maxvar in Yaxis')
    titl = sprintf('(X,Y)-> obj center Pos\n(Z)-> Max Y Var a grasp can resist\n PGR=%s',type);
    title(titl);
end

%% Save workspace
save RobPosXY.mat

%% Computing the square error between Variance of X and Y axis computed with PGR brute force and the other heuristics


PGRHeurTypes = ["H2", "H3", "H4"]; % Name of PGR Heuristics computed

T = [];
for type = PGRHeurTypes
    % X axis
    XErrorMat = (xPosLen.BF - xPosLen.(type)).^2;
    XVarError.(type) = sum(XErrorMat, 'all');
    
    % Y axis
    YErrorMat = (yPosLen.BF - yPosLen.(type)).^2;
    YVarError.(type) = sum(YErrorMat, 'all');
    T2 = table([XVarError.(type);YVarError.(type)]);
    T2.Properties.VariableNames = {char(type)};
    T = [T, T2];
end

T.Properties.RowNames{1} = 'X axis Error';
T.Properties.RowNames{2} = 'Y axis Error';
disp('Sum of error.^2 between Var Pos Mat with BF and the other heuristics:');
disp(T);
