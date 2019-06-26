function [minus_PGR] = SGBestPosCostWithRot(hand,obj, pose ,  PGR_type)
%This function evaluates the minus PGR given a certain hand, object and its
% center coordinates and rotation.
% Basically is the SGBestPosCost considering that the object rotation can
% change
[minus_PGR] = SGBestPosCost(hand,obj, pose(1:3), pose(4:6) ,  PGR_type);
end

