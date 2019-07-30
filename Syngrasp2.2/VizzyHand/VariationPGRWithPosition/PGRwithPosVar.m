%   PGRwithPosVar - Computes the PGR of an object centered in "center" and 
%   where the position of a coordinate changes.
%   The coordinate can be defined in the variable "axisVar"
%   choosen.
%
%    Usage: [PGR] = PGRwithPosVar(obj0, center, rot,axisVar, maxVar, n_iter,PGRtypes)
%    Arguments:
%    obj0 = the object structure in the initial grasp configuration
%    center = object center
%    rot = 3D vector that contains the axis rotation angles
%    rot(1) = theta
%    rot(2) = phi
%    rot(3) = psi
%    axisVar = string that defines the axis where the position changes
%    maxVar = center maximum variation in one axis direction
%    n_iter = is the integer of (number of total positions -1)/2
%    PGRtypes = string array containing the method of how PGR should be
%    computed. ( By brute force, heuristic 1,2,3,4 ...) Example: PGRtypes = ["BF", "H2"];
%
%    Returns:
%    PGR = PGR structure that contains PGR computed by the different
%    methods specified in PGRtypes
%    Pos = Vector that contains the postion variation

function [PGR, Pos] = PGRwithPosVar(obj0, center, rot, axisVar, maxVar, n_iter, PGRtypes)

switch axisVar
    case 'xPos'
        axis = 1;
    case 'yPos'
        axis = 2;
    case 'zPos'
        axis = 3;
    otherwise
        error('axisVar must contain one of the following strings : xPos, yPos, zPos');
end
% Synergies step size
active = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
n_syn = 3; % Number of synergies

obj0.center = center; 

minPos = center(axis)- maxVar; % minPos that obj center can have
maxPos = center(axis)+ maxVar; % maxPos that obj center can have

Pos = minPos: maxVar/n_iter : maxPos; % Vector with position

% Pre-allocate memory
for i = 1: length(PGRtypes)
    auxPGR.(PGRtypes(i)) = 0;
end
PGR(1:length(Pos))= auxPGR;

wb = waitbar(0,'PGR Var with Pos Var');
for i = 1 : length(Pos)
    msg = sprintf("%d/%d", i, length(Pos));
    wb = waitbar(i/length(Pos), wb, msg);
    hand = VizzyHandModel; % Reset Vizzy Hand model
    obj = obj0; % Reset object
    obj.center(axis) = Pos(i); % slithe a little the object position
    obj.Htr(axis,4) = Pos(i);
    obj = SGrebuildObject(obj, obj.center, rot); % Rebuilds a new object
    
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,active, n_syn);
    
    % Quality metrics
    PGR(i) = ComputePGRWithBFandHeur(hand, obj, PGRtypes);
    %Plot1Hand_ObjectWithPGR(hand, obj, num2str(Pos(i),4), PGR,i); % <--DEGUB !!

end

delete(wb); % Deletes waitbar

end

