% In this script, the variance of PGR is computed when the position changes
% a little bit
close all; clear;
% loads a few initial grasps
grasps = dir('CubePos_InitGrasps/*.mat');


n_iter = 11;
maxVar = 10; % 5mm

%% For X position
posCoor = 'x';
XaxisGrasps = ComputePosVariance4eachGrasp(grasps, posCoor, maxVar, n_iter,'man');

%save('GraspsPosVariance.mat','XPosaxisGrasps','-append'); 

%% For Y position
posCoor = 'y';
YaxisGrasps = ComputePosVariance4eachGrasp(grasps, posCoor, maxVar, n_iter,'man');

save('GraspsPosVariance.mat','YPosaxisGrasps','-append'); 

%% Plot of initial PGR grasp in function of the rotation variation (where PGR doesn't change with those rotations)

% X axis
InitialPGRvsPosVar(XPosaxisGrasps, 'X');
figure();

% Y axis
InitialPGRvsPosVar(YPosaxisGrasps, 'Y');


%% Function to plot the initial PGR grasp in function of the rotation variation (where PGR doesn't change with those rotations)

function InitialPGRvsPosVar(PosaxisGrasps, axis)

    n_grasps = length(PosaxisGrasps); % Number of grasps

    for i = 1:n_grasps

        org = PosaxisGrasps(i).PGR_BF(round(length(PosaxisGrasps(i).PGR_BF)/2));
        % Constant Interval Length (How many degrees the object can rotate and the PGR is almost still the same)
        ConstInterLen = PosaxisGrasps(i).Pos2 - PosaxisGrasps(i).Pos1;
        plot(ConstInterLen,org,'bx'); hold on;

    end

    xlabel('Grasp Number');
    ylabel('PGR (of the initial grasp)');
    title(['How initial PGR influences the max pos (in ', axis, ' axis) variation']);
    
end

%%
% Given an initial grasp, this fuction computes the PGR for a given
% variance in X or Y axis
function axisGrasps = ComputePosVariance4eachGrasp(grasps, posCoor, maxVar, n_iter, mode)

    n_grasps = length(grasps); % Number of grasps

    for i = 1:n_grasps
        close all;
        load(grasps(i).name); % In each cycle, loads one grasp
        
        axisGrasps = ComputePosVariance41Axis(obj, posCoor, maxVar, n_iter, mode);
    end
end




