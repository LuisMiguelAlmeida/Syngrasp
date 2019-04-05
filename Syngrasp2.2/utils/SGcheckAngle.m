%    SGcheckAngle - check angles between contact forces and contact normals
%
%    This function evaluates the angles between contact forces and contact
%    normal unit vectors
%
%    Usage:  out = SGcheckAngle(w,y,pG,E,n)
%
%    Arguments:
%    w = external load
%    y = coefficients for the linear combination of E columns
%    pG = grasp matrix pseudoinverse
%    E = controllable internal force subspace
%    n = contact normal (matriz 3xnc)
%
%    Returns: 
%     out.theta = vector containing for each contact the angle between
%       contact force and contact normal
%     out.Theta = sum of contact angles
%
%    References
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force 
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, 
%    Zaragoza, Spain, June 2011. 
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.p
%    df
%
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. On the role of 
%    hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-pu
%    blished.pdf 
%    See also:  SGquasistatic, SGquasistaticMaps, SGcheck_friction    

%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo, A. Bicchi
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    SynGrasp is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SynGrasp is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SynGrasp. If not, see <http://www.gnu.org/licenses/>.


function out = SGcheckAngle(w,y,pG,E,n)


% evaluate the contact forces
lambda = -pG*w + E*y; 

% evaluate the number of contacts
[tmp,nc] = size(n);

theta = zeros(1,nc);
% for each contact
for i = 1:nc
    % extract the contact force relative to the i-th contact from the
    % lambda vector
    lambdai = lambda(3*i-2:3*i); % only for HF contact model!!
    % i-th contact normal
    ni = n(:,i);
    % for each constraint
    theta(i) = asin(norm(cross(lambdai,ni))/norm(lambdai));    
    
end
out.theta = theta;
out.Theta = sum(theta);