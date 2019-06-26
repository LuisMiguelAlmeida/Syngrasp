function base = SGrotate(base,theta,phi,psi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotations                                                  %
%                                                                         %
% J.Acquarelli, D.Conti                                                   %
% December 2012                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base=[SGrotx(theta) [0 0 0]'; [0 0 0 1]]*[SGroty(phi) [0 0 0]'; [0 0 0 1]]*[SGrotz(psi) [0 0 0]'; [0 0 0 1]]*base;

end

