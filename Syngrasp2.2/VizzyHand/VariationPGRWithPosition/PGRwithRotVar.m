%   PGRwithRotVar - Computes the PGR of an object centered in "center" and 
%   where the object rotation changes.
%   The rotation around a certain axis can be defined in the variable
%   "axisVar".
%
%    Usage: [PGR_BF, PGR_H2] = PGRwithRotVar(obj0, center, rot,axisVar, maxVar, n_iter)
%    Arguments:
%    obj0 = the object structure in the initial grasp configuration
%    center = object center
%    rot = 3D vector that contains the axis rotation angles
%    rot(1) = theta
%    rot(2) = phi
%    rot(3) = psi
%    axisVar = string that defines the axis where the Rotition changes
%    maxVar = center maximum variation in one axis direction
%    n_iter = is the integer of (number of total Rotitions -1)/2
%
%    Returns:
%    PGR_BF = PGR brute force
%    PGR_H2 = PGR Heuristic 2
%    Rot = Vector that contains the Rottion variation

function [PGR_BF, PGR_H2, Rot] = PGRwithRotVar(obj0, center, rot, axisVar, maxVar, n_iter)

switch axisVar
    case 'xRot'
        axis = 1;
    case 'yRot'
        axis = 2;
    case 'zRot'
        axis = 3;
    otherwise
        error('axisVar must contain one of the following strings : xRot, yRot, zRot');
end
% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies

obj0.center = center; 

minRot = rot(axis)- maxVar; % minRot that obj center can have
maxRot = rot(axis)+ maxVar; % maxRot that obj center can have

Rot = minRot: maxVar/n_iter : maxRot; % Vector with Rotition

%Rot = round(Rot, 4);
% Pre-allocate memory
PGR_BF = zeros(1, length(Rot));
PGR_H2 = zeros(1, length(Rot));
n_cp =  zeros(1, length(Rot));

wb = waitbar(0,'PGR Var with Rot Var');
for i = 1 : length(Rot)
    msg = sprintf("%d/%d", i, length(Rot));
    wb = waitbar(i/length(Rot), wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    if axis == 1 || axis == 2
        
        % Rising a little the cube position, so it doesn't touch the palm
        h_dim = obj.dim/2; % Half of cube dimentions
        zmin(1) = h_dim(1)*sin(Rot(i)) - cos(Rot(i))*h_dim(3); % Rotation matrix (2nd row) 
        zmin(2) = -h_dim(1)*sin(Rot(i)) - cos(Rot(i))*h_dim(3); % Covers the others rotation angles
        zMin = min(zmin);
        zMin = obj.dim(3)/2+zMin;
        obj.center(3) = obj.center(3) - zMin;
     
    end
    rot(axis) = Rot(i); % Updates rotation
    obj = SGrebuildObject(obj, obj.center, rot); % Rebuilds a new object
    if i == 18
        disp('hi')
    end
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    %[hand, obj] = SGcloseHandWithSynergies(hand,obj);
    % Quality metrics
    [~,PGR_BF(i),~, PGR_H2(i)] = Plot1Hand_Object(hand, obj, num2str(Rot(i),4), 3,i);
    hold off;
    n_cp(i)= size(hand.cp,2);
end

delete(wb); % Deletes waitbar
figure();
plot(Rot, n_cp);
end