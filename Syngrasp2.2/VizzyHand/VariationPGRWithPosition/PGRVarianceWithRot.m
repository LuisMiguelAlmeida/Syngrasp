% In this script, the variance of PGR is computed when the rotation changes
% a little bit
close all; clear;
% loads a few initial grasps
grasps = dir('CubeRot_InitGrasps/*.mat');


n_iter = 17;
maxVar = 0.1; % 0.1 rad

%% For X axis rotation
rotCoor = 'x';
XRotaxisGrasps = ComputeVariance4eachRotAxis(grasps, rotCoor, maxVar, n_iter);

save('GraspsRotVariance.mat','XRotaxisGrasps'); 

%% For Y axis rotation
rotCoor = 'y';
YRotaxisGrasps = ComputeVariance4eachRotAxis(grasps, rotCoor, maxVar, n_iter);

save('GraspsRotVariance.mat','YRotaxisGrasps','-append'); 


%% For Z axis rotation
rotCoor = 'z';
ZRotaxisGrasps = ComputeVariance4eachRotAxis(grasps, rotCoor, maxVar, n_iter);

save('GraspsRotVariance.mat','ZRotaxisGrasps','-append'); 


%% Plot of initial PGR grasp in function of the rotation variation (where PGR doesn't change with those rotations)

% X axis
InitialPGRvsRotVar(XRotaxisGrasps, 'X');
figure();

% Y axis
InitialPGRvsRotVar(YRotaxisGrasps, 'Y');
figure();

% Z axis
InitialPGRvsRotVar(ZRotaxisGrasps, 'Z');


%% Function to plot the initial PGR grasp in function of the rotation variation (where PGR doesn't change with those rotations)

function InitialPGRvsRotVar(RotaxisGrasps, axis)

    n_grasps = length(RotaxisGrasps); % Number of grasps

    for i = 1:n_grasps

        org = RotaxisGrasps(i).PGR_BF(round(length(RotaxisGrasps(i).PGR_BF)/2));
        % Constant Interval Length (How many degrees the object can rotate and the PGR is almost still the same)
        ConstInterLen = RotaxisGrasps(i).Rot2 - RotaxisGrasps(i).Rot1;
        plot(ConstInterLen,org,'bx'); hold on;

    end

    xlabel('Grasp Number');
    ylabel('PGR (of the initial grasp)');
    title(['How initial PGR influences the max rot (in ', axis, ' axis) variation']);
    
end

%% Function to compute how much radians an object can rotate and the grasp still be stable
function axisGrasps = ComputeVariance4eachRotAxis(grasps, rotCoor, maxVar, n_iter)
  
    n_grasps = length(grasps); % Number of grasps
    rot = zeros(1,3);
    
    for i = 1:n_grasps
        close all;
        load(grasps(i).name); % In each cycle, loads one grasp
        
        axisGrasps(i)= ComputeRotVariance41Axis(obj, rotCoor, maxVar, n_iter, 'auto');
    end
end


