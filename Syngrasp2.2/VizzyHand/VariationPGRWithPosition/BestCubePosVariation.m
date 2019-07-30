%% Variation of PGR H2 considering the varition of the cube positon
% In this script it is evalated the PGR variation according to the cube
% postion

% Loads initial cube position
load('CubePos.mat');

obj.center = [60 0 27];

%% X position
bestX = bestPos(obj, 'x', 3);

%% Y position
close all;
bestY = bestPos(obj, 'y', 10);

%% Z position (PowerGrasp it does not need to change Z)
% bestZ = bestPos(obj, 'z', 10);


%% Testing how PGR changes to rotation
% Loads initial cube position
load('CubePos.mat');
close all;
rot = zeros(1,3);

%% Rotation around X axis
bestRotX = bestRot(obj, rot, 'x', 0.1, 17);

%% Rotation around Y axis
close all;
bestRotY = bestRot(obj, rot, 'y', 0.1, 17);

%% Rotation around Z axis
close all;
bestRotZ = bestRot(obj, rot, 'z', 0.28, 20);

%%
function bestRotCoor = bestRot(obj, rot, rotCoor, maxVar, n_iter)
    [PGR_BF, PGR_H2, Rot] = PGRwithRotVar(obj, obj.center, rot, [rotCoor,'Rot'], maxVar, n_iter);
    figure();
    plot(Rot, PGR_BF);
    hold on;
    plot(Rot, PGR_H2);
    xlabel([rotCoor,' object rotation']);
    ylabel('Quality metric');
    legend( 'Brute Force', 'H2'); 
    [~,I] = max(PGR_BF);
    bestRotCoor = Rot(I);
end

%%
function [bestPosCoor, varargout] = bestPos(obj, posCoor, n_iter)
    [PGR, Pos] = PGRwithPosVar(obj, obj.center, [0, 0, 0], [posCoor,'Pos'], 10, n_iter, ["BF", "H2"]);
    figure();
    plot(Pos, [PGR.BF]);
    hold on;
    plot(Pos, [PGR.H2]);
    xlabel([posCoor,' object position']);
    ylabel('Quality metric');
    legend( 'Brute Force', 'H2'); 
    [~,I] = max([PGR.BF]);
    bestPosCoor = Pos(I);
    
    varargout{1} = [PGR.BF];
    varargout{2} = [PGR.H2];
    varargout{3} = Pos;
end






