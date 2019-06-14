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
active = 5*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies

objCenter = obj.center;
maxVar = 10; % Maximum variation on x axis
xmin = objCenter(1)- maxVar; % xmin that obj center can have
xmax = objCenter(1)+ maxVar; % xmax that obj center can have

xPos = xmin: maxVar/5: xmax;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(xPos)

    msg = sprintf("%d/%d", i, length(xPos));
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(1) = xPos(i); % slithe a little the object position
    obj.Htr(1,4) = xPos(i);
    obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergies(hand,obj,active, n_syn);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(xPos(i)), 3,i);
    
end

delete(wb); % Deletes waitbar

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
active = 5*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
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
    [hand, obj] = SGcloseHandWithSynergies(hand,obj,active, n_syn);
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
active = 5*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
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
    [hand, obj] = SGcloseHandWithSynergies(hand,obj,active, n_syn);
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
[hand, obj] = SGcloseHandWithSynergies(hand,obj,active, n_syn);
figure;
% Quality metrics
[~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, int2str(zPos(i)), 3);

 %%  PGR computation for the closest obj center of the best grasp (several center points)
% Var = 5;
% len_vec = 2; % Length of bestvector
% bestXmin = bestX - Var;
% bestXmax = bestX + Var;
% bestYmin = bestY - Var;
% bestYmax = bestY + Var;
% bestZmin = bestZ - Var;
% bestZmax = bestZ + Var;
% 
% bestXvec = bestXmin : Var/len_vec: bestXmax;
% bestYvec = bestYmin : Var/len_vec: bestYmax;
% bestZvec = bestZmin : Var/len_vec: bestZmax;
% 
% Compute the combination of 3 point in each axis 
% bestXYZvec = combvec( bestXvec, bestYvec, bestZvec);
% 
% for i = 1: length(bestXYZvec)
%     hand = VizzyHandModel; % Reset Vizzy Hand model
%     obj = obj0; % Reset object
%     obj.center(1:3) = bestXYZvec(:,i)';
%     obj.Htr(1:3,4) = bestXYZvec(:,i);
% 
%     obj=SGsphere(obj.Htr,obj.radius,obj.res); % Creates a new sphere
%     Close the hand
%     [hand, obj] = SGcloseHandWithSynergies(hand,obj,active, n_syn);
%     Quality metrics
%     [PGR__BF(i), ~, ~] = SG_PGRbruteforce(hand, obj);
% end
% 
% %% PGR brute force Graphic for the closest obj center of the best grasp 
% figure();
% markerSize = 100;
% scatter3(bestXYZvec(1,:),bestXYZvec(2,:),bestXYZvec(3,:),markerSize,PGR__BF,'filled')
% colorbar
% xlabel('X');
% ylabel('Y');
% zlabel('Z');

%%


