function [Hmatrix] = SGrotAndTransl(Hmatrix,translation, theta, phi, psi)
% SGROTANDTRANSL Rotates the  Hmatrix by theta, phi and psi
% theta = angle around X axis
% phi = angle around Y axis
% psi = angle around Z axis
% translation = 3D vector that describes the translation 

% Checking vector and matrix dimenstions
if size(translation, 1) == 1 && size(translation, 2) == 3
    translation = translation'; % transforms into column vector
elseif size(translation, 1) ~= 3 && size(translation, 2) ~= 1
    error('Translation must be a 3x1 vector');
end

if size(Hmatrix,1) ~= 4 || size(Hmatrix,2) ~=4
    error('Hmatrix must be a 4x4 matrix');
end

Hmatrix = SGrotate(Hmatrix, theta, phi, psi); % Rotate Hmatrix by theta,phi and psi
Hmatrix= Hmatrix + [zeros(3) translation; [0 0 0 0]]; % Add translation to Hmatrix

end

