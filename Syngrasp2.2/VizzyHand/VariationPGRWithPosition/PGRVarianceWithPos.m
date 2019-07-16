% In this script, the variance of PGR is computed when the position changes
% a little bit
close all; clear;
% loads a few initial grasps
grasps = dir('CubePos_InitGrasps/*.mat');


n_iter = 11;
maxVar = 10; % 5mm

%% For X position
posCoor = 'x';
XaxisGrasps = ComputeVariance4eachAxis(grasps, posCoor, maxVar, n_iter);

save('GraspsPosVariance.mat','XPosaxisGrasps','-append'); 

%% For Y position
posCoor = 'y';
YaxisGrasps = ComputeVariance4eachAxis(grasps, posCoor, maxVar, n_iter);

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
function axisGrasps = ComputeVariance4eachAxis(grasps, posCoor, maxVar, n_iter)
  
    n_grasps = length(grasps); % Number of grasps

    for i = 1:n_grasps
        close all;
        load(grasps(i).name); % In each cycle, loads one grasp
        % Compute PGR for each position variance
        [PGR_BF, PGR_H2, Pos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], [posCoor,'Pos'], maxVar, n_iter);
        f=figure();
        plot(Pos, PGR_BF);
        hold on;
        plot(Pos, PGR_H2);
        xlabel([posCoor,' object position']);
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
        axisGrasps(i).Pos = Pos;
        axisGrasps(i).Variance = var(PGR_BF(ind1:ind2));
        axisGrasps(i).Mean = mean(PGR_BF(ind1:ind2));
        axisGrasps(i).ind1 = ind1;
        axisGrasps(i).ind2 = ind2;
        axisGrasps(i).Pos1 = Pos(ind1);
        axisGrasps(i).Pos2 = Pos(ind2);
    end
end


