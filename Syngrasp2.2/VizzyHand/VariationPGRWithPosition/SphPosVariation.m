%% Variation of PGR H2 considering the varition of the sphere positon
% In this script it is evalated the PGR variation according to the sphere
% postion


%% Variation for X axis
clear PGR_BF PGR_H2;
close all;
clc;

% Loads initial sphere position
load('SpherePos.mat');
obj0 = obj; % Auxiliar object

% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies

objCenter = obj.center;

maxVar = 10; % Maximum variation on x axis
xmin = objCenter(1)- maxVar; % xmin that obj center can have
xmax = objCenter(1)+ maxVar; % xmax that obj center can have

xPos = xmin: maxVar/3: xmax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(xPos)

    msg = sprintf("%d/%d", i, length(xPos));
    wb = waitbar(i/length(xPos), wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(1) = xPos(i); % slithe a little the object position
    obj.Htr(1,4) = xPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(xPos(i)), 3,i);
    
end

delete(wb); % Deletes waitbar
figure();
plot(xPos, PGR_BF);
hold on;
plot(xPos, PGR_H2);
xlabel('X object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestX = xPos(I);

%% Variation for Y axis
clear PGR_BF PGR_H2;
close all;
clc

% Loads initial sphere position
load('SpherePos.mat');
obj0 = obj; % Auxiliar object

% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies
obj.center(2) = -20;
objCenter = obj.center;
maxVar = 10; % Maximum variation on x axis
ymin = objCenter(2)- maxVar; % xmin that obj center can have
ymax = objCenter(2)+ maxVar; % xmax that obj center can have

yPos = ymin: maxVar/3: ymax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(yPos)

    msg = sprintf("%d/%d", i, length(yPos));
    wb = waitbar(i/length(yPos),wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(2) = yPos(i); % slithe a little the object position
    obj.Htr(2,4) = yPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(yPos(i)), 3,i);
    
end

delete(wb); % Deletes waitbar

plot(yPos, PGR_BF);
hold on;
plot(yPos, PGR_H2);
xlabel('Y object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestY = yPos(I);

%% Variation for Z axis
clear PGR_BF PGR_H2;
close all;
clc

% Loads initial sphere position
load('SpherePos.mat');

obj0 = obj; % Auxiliar object
% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies
obj.center(3) = 60;
objCenter = obj.center;
maxVar = 10; % Maximum variation on x axis
zmin = objCenter(3)- maxVar; % xmin that obj center can have
zmax = objCenter(3)+ maxVar; % xmax that obj center can have

zPos = zmin: maxVar/3: zmax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(zPos) 
    
    msg = sprintf("%d/%d", i, length(zPos));
    wb = waitbar(i/length(zPos),wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(3) = zPos(i); % slithe a little the object position
    obj.Htr(3,4) = zPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(zPos(i)), 3,i);

end

delete(wb); % Deletes waitbar
figure();
plot(zPos, PGR_BF);
hold on;
plot(zPos, PGR_H2);
xlabel('Z object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 

[M, I] = max(PGR_BF);
bestZ = zPos(I);

%% Best of all combinations (supposedly)

hand = VizzyHandModel; % Reset Vizzy Hand model
obj = obj0; % Reset object
obj.center(1) = bestX;
obj.center(2) = bestY;
obj.center(3) = bestZ;
obj.Htr(1,4) = bestX;
obj.Htr(2,4) = bestY;
obj.Htr(3,4) = bestZ;
obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
% Close the hand
[hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
figure;
% Quality metrics
[~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(zPos(i)), 3);

%% Makes a search for the best sphere's center point through fminsearch

load('SpherePos.mat');
hand = VizzyHandModel; % Reset Vizzy Hand model
hand.step_syn =  90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
hand.n_syn = 3; % Number of synergies

option = optimset('Display','iter','PlotFcns',@optimplotfval);
option.TolX = 1e-1;
option.TolFun = 1e-1;
option.MaxIter = 10; %50000;
option.MaxFunEvals = 5000; % Put to 10000 for nc = 15

center_obj0 = [bestX, bestY, bestZ];
rot0 = zeros(1,3); % angle rotation
pose0 = [center_obj0, rot0];

[center_obj_opt, cost_val] = fminsearch(@(pose) SGBestPosCost(hand,obj, pose, 'BruteForce'),pose0,option); % Search for the 'best' object center

%%
options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
options.MaxIterations = 50;
options.PlotFcn = @optimplotfval;
[x,fval,exitflag,output] = fminunc(@(center_obj) SGBestPosCost(hand,obj, center_obj, 'BruteForce'),center_obj0,options);

 %%  PGR computation for the closest obj center of the best grasp (several center points)
Var = 5;
len_vec = 2; % Length of bestvector
bestXmin = center_obj_opt(1) - Var;
bestXmax = center_obj_opt(1) + Var;
bestYmin = center_obj_opt(2) - Var;
bestYmax = center_obj_opt(2) + Var;
bestZmin = center_obj_opt(3) - Var;
bestZmax = center_obj_opt(3) + Var;

bestXvec = bestXmin : Var/len_vec: bestXmax;
bestYvec = bestYmin : Var/len_vec: bestYmax;
bestZvec = bestZmin : Var/len_vec: bestZmax;

%Compute the combination of 3 point in each axis 
bestXYZvec = combvec( bestXvec, bestYvec, bestZvec);

PGR__BF = zeros(1,length(bestXYZvec)); % Memory allocation
for i = 1: length(bestXYZvec)
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(1:3) = bestXYZvec(:,i)';
    obj.Htr(1:3,4) = bestXYZvec(:,i);

    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    %Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    %Quality metrics
    [PGR__BF(i), ~, ~] = SG_PGRbruteforce(hand, obj);
end

%% PGR brute force Graphic for the closest obj center of the best grasp 
figure();
markerSize = 100;
scatter3(bestXYZvec(1,:),bestXYZvec(2,:),bestXYZvec(3,:),markerSize,PGR__BF,'filled')
colorbar
xlabel('X');
ylabel('Y');
zlabel('Z');



%% See if a power grasp is better than only contact points on the phalanges
% POWER GRASP!!!!!!!!!!!!!!
%
%
%
%% Variation for X axis
clear PGR_BF PGR_H2;
close all;
clc;

% Loads initial sphere position
load('SpherePos.mat');
obj0 = obj; % Auxiliar object

% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies

obj.center(3) = 30; % slithe a little the object position
obj.Htr(3,4) = 30;
obj0 = obj;
objCenter = obj.center;

maxVar = 10; % Maximum variation on x axis
xmin = objCenter(1)- maxVar; % xmin that obj center can have
xmax = objCenter(1)+ maxVar; % xmax that obj center can have

xPos = xmin: maxVar/3: xmax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(xPos)

    msg = sprintf("%d/%d", i, length(xPos));
    wb = waitbar(i/length(xPos), wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(1) = xPos(i); % slithe a little the object position
    obj.Htr(1,4) = xPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(xPos(i)), 3,i);
    
end

delete(wb); % Deletes waitbar
figure();
plot(xPos, PGR_BF);
hold on;
plot(xPos, PGR_H2);
xlabel('X object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestX = xPos(I);

%% Variation for Y axis
clear PGR_BF PGR_H2;
close all;
clc

% Loads initial sphere position
load('SpherePos.mat');
obj0 = obj; % Auxiliar object

obj.center(3) = 30; % slithe a little the object position
obj.Htr(3,4) = 30;
obj0 = obj;

% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies
obj.center(2) = -20;
objCenter = obj.center;
maxVar = 10; % Maximum variation on x axis
ymin = objCenter(2)- maxVar; % xmin that obj center can have
ymax = objCenter(2)+ maxVar; % xmax that obj center can have

yPos = ymin: maxVar/3: ymax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(yPos)

    msg = sprintf("%d/%d", i, length(yPos));
    wb = waitbar(i/length(yPos),wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(2) = yPos(i); % slithe a little the object position
    obj.Htr(2,4) = yPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(yPos(i)), 3,i);
    
end

delete(wb); % Deletes waitbar

plot(yPos, PGR_BF);
hold on;
plot(yPos, PGR_H2);
xlabel('Y object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 
[M, I] = max(PGR_BF);
bestY = yPos(I);


%% Variation for Z axis
clear PGR_BF PGR_H2;
close all;
clc

% Loads initial sphere position
load('SpherePos.mat');


obj.center(3) = 30; % slithe a little the object position
obj.Htr(3,4) = 30;
obj0 = obj;

% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies
obj.center(3) = 60;
objCenter = obj.center;
maxVar = 10; % Maximum variation on x axis
zmin = objCenter(3)- maxVar; % xmin that obj center can have
zmax = objCenter(3)+ maxVar; % xmax that obj center can have

zPos = zmin: maxVar/6: zmax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(zPos) 
    
    msg = sprintf("%d/%d", i, length(zPos));
    wb = waitbar(i/length(zPos),wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(3) = zPos(i); % slithe a little the object position
    obj.Htr(3,4) = zPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(zPos(i)), 3,i);

end

delete(wb); % Deletes waitbar
figure();
plot(zPos, PGR_BF);
hold on;
plot(zPos, PGR_H2);
xlabel('Z object postion');
ylabel('Quality metric');
legend( 'Brute Force', 'H2'); 

[M, I] = max(PGR_BF);
bestZ = zPos(I);
