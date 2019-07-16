% In this script, the variance of PGR is computed when the rotation changes
% a little bit
close all; clear;
% loads a few initial grasps
grasps = dir('CubePos_InitGrasps/*.mat');


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
        % Compute PGR for each position variance
        [PGR_BF, PGR_H2, Rot] = PGRwithRotVar(obj, obj.center, rot, [rotCoor,'Rot'], maxVar, n_iter);
        f=figure();
        plot(Rot, PGR_BF);
        hold on;
        plot(Rot, PGR_H2);
        xlabel([rotCoor,' object Rotation']);
        ylabel('Quality metric');
        legend( 'Brute Force', 'H2');

        % Choose two points from the plot to compute the PGR variance
        d = datacursormode(f);
        input('Put 2 datatips to limit the samples that will be used to compute the variance\n');
        vals = getCursorInfo(d);
        ind1 = min(vals.DataIndex);
        ind2 = max(vals.DataIndex);
        % Saves quality measures
        axisGrasps(i).PGR_BF = PGR_BF;
        axisGrasps(i).PGR_H2 =  PGR_H2;
        axisGrasps(i).Rot = Rot;
        axisGrasps(i).Variance = var(PGR_BF(ind1:ind2));
        axisGrasps(i).Mean = mean(PGR_BF(ind1:ind2));
        axisGrasps(i).ind1 = ind1;
        axisGrasps(i).ind2 = ind2;
        axisGrasps(i).Rot1 = Rot(ind1);
        axisGrasps(i).Rot2 = Rot(ind2);
    end
end


