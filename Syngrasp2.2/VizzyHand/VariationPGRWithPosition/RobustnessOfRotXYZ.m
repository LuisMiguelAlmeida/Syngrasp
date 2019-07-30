% In this script, it is evaluated how PGR behave when a Rotition in x and y
% axis changes a little bit of its initial Rotition. The initial grasp is a
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


%% Variation in the X Rot axis

% How much rads can an object rotate and the grasp is still be considered stable

% Pre allocation of memory
for type = PGRtypes
    xRotLen.(type) = zeros(n_rows, n_col);
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

        axisGrasps = ComputeRotVariance41Axis(obj, 'x', deg2rad(5), 5, PGRtypes);
        for type = PGRtypes
            xRotLen.(type)(i,j) = axisGrasps.RotLen.(type);
        end
    end
    close all;
end

%%
for type = PGRtypes
    figure();
    surf(X,Y,xRotLen.(type));
    xlabel('X')
    ylabel('Y');
    zlabel('Maxvar in Xaxis')
    titl = sprintf('(X,Y)-> obj center Pos\n(Z)-> Max X Var a grasp can resist\n PGR=%s',type);
    title(titl);
end

%% Variation in the Y Rot axis

% How much rads can an object rotate and the grasp is still be considered stable

% Pre allocation of memory
for type = PGRtypes
    yRotLen.(type) = zeros(n_rows, n_col);
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

        axisGrasps = ComputeRotVariance41Axis(obj, 'y', deg2rad(5), 5, PGRtypes);
        for type = PGRtypes
            yRotLen.(type)(i,j) = axisGrasps.RotLen.(type);
        end

    end
    close all;
end
%%
for type = PGRtypes
    figure();
    surf(X,Y,yRotLen.(type));
    xlabel('X')
    ylabel('Y');
    zlabel('Maxvar in Yaxis')
    titl = sprintf('(X,Y)-> obj center Pos\n(Z)-> Max Y Var a grasp can resist\n PGR=%s',type);
    title(titl);
end

%% Variation in the Z Rot axis

% How much rads can an object rotate and the grasp is still be considered stable


% Pre allocation of memory
for type = PGRtypes
    zRotLen.(type) = zeros(n_rows, n_col);
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

        axisGrasps = ComputeRotVariance41Axis(obj, 'z', deg2rad(5), 5, PGRtypes);
        for type = PGRtypes
            zRotLen.(type)(i,j) = axisGrasps.RotLen.(type);
        end
    end
    close all;
end
%%
for type = PGRtypes
    figure();
    surf(X,Y,zRotLen.(type));
    xlabel('X')
    ylabel('Y');
    zlabel('Maxvar in Zaxis')
    titl = sprintf('(X,Y)-> obj center Pos\n(Z)-> Max Z Var a grasp can resist\n PGR=%s',type);
    title(titl);
end
%%
save RobRotXYZ.mat

%%
%% Computing the square error between Variance of X and Y axis computed with PGR brute force and the other heuristics


PGRHeurTypes = ["H2", "H3", "H4"]; % Name of PGR Heuristics computed

T = [];
for type = PGRHeurTypes
    % X axis
    XErrorMat = (xRotLen.BF - xRotLen.(type)).^2;
    XVarError.(type) = sum(XErrorMat, 'all');
    
    % Y axis
    YErrorMat = (yRotLen.BF - yRotLen.(type)).^2;
    YVarError.(type) = sum(YErrorMat, 'all');
    
    % Z axis
    ZErrorMat = (zRotLen.BF - zRotLen.(type)).^2;
    ZVarError.(type) = sum(ZErrorMat, 'all');
    T2 = table([XVarError.(type); YVarError.(type); ZVarError.(type)]);
    T2.Properties.VariableNames = {char(type)};
    T = [T, T2];
end

T.Properties.RowNames{1} = 'X axis Error';
T.Properties.RowNames{2} = 'Y axis Error';
T.Properties.RowNames{3} = 'Z axis Error';
disp('Sum of error.^2 between Var Rot Mat with BF and the other heuristics ');
disp(T);