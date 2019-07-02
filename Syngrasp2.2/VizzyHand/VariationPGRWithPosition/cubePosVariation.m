%% Variation of PGR H2 considering the varition of the cube positon
% In this script it is evalated the PGR variation according to the cube
% postion

% Loads initial cube position
load('CubePos.mat');

%% X position
obj.center = [60 0 27];
[PGR_BF, PGR_H2, xPos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], 'xPos', 10,3);

figure();
plot(xPos, PGR_BF);
hold on;
plot(xPos, PGR_H2);
xlabel('X object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestX = xPos(I);

%% Y position
close all
[PGR_BF, PGR_H2, yPos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], 'yPos', 10, 10);

figure();
plot(yPos, PGR_BF);
hold on;
plot(yPos, PGR_H2);
xlabel('Y object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestY = yPos(I);

%% Z position (PowerGrasp it does not need to change Z)
% [PGR_BF, PGR_H2, zPos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], 'zPos', 10, 10);
% 
% figure();
% plot(zPos, PGR_BF);
% hold on;
% plot(zPos, PGR_H2);
% xlabel('Z object postion');
% ylabel('Quality metric');
% legend( 'Brute Force', 'H2'); 
% [M, I] = max(PGR_BF);
% bestZ = zPos(I);

%% Find best position
hand = VizzyHandModel; % Reset Vizzy Hand model
hand.step_syn =  90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
hand.n_syn = 3; % Number of synergies

option = optimset('Display','iter','PlotFcns',@optimplotfval);
option.TolX = 1e-1;
option.TolFun = 1e-1;
option.MaxIter = 25; %50000;
option.MaxFunEvals = 5000; % Put to 10000 for nc = 15

center_obj0 = [bestX, bestY, bestZ];
rot0 =[-0.39 0 0]; % Rotation
pose0 = [center_obj0, rot0];
%%
%[center_obj_opt, cost_val] = fminsearch(@(center_obj) SGBestPosCost(hand,obj,center_obj,rot0, 'BruteForce'),center_obj0,option); % Search for the 'best' object center

[center_obj_opt, cost_val] = fminsearch(@(pose) SGBestPosCostWithRot(hand,obj,pose, 'BruteForce'),pose0,option); % Search for the 'best' object center

%% Testing how PGR changes to rotation

%% Rotation around X axis

% Loads initial cube position
load('CubePos.mat');
close all;
rot = zeros(1,3);
%%
[PGR_BF, PGR_H2, xRot] = PGRwithRotVar(obj, obj.center, rot, 'xRot',0.1, 17);

figure();
plot(xRot, PGR_BF);
hold on;
plot(xRot, PGR_H2);
xlabel('X object rotation');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestRotX = xRot(I);

%% Rotation around Y axis
close all;
[PGR_BF, PGR_H2, yRot] = PGRwithRotVar(obj, obj.center, rot, 'yRot', 0.1, 17);
figure();
plot(yRot, PGR_BF);
hold on;
plot(yRot, PGR_H2);
xlabel('Y object rotation');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestRotY = yRot(I);

%% Rotation around Z axis
close all;
[PGR_BF, PGR_H2, zRot] = PGRwithRotVar(obj, obj.center, rot, 'zRot', 0.28, 20);
figure();
plot(zRot, PGR_BF);
hold on;
plot(zRot, PGR_H2);
xlabel('Z object rotation');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestRotZ = zRot(I);










