%    SGgTildeMatrix - Computes the Gtilde matrix
%
%    The function computes the Gtilde matrix for the given contact points
%    and object center
%
%    Usage: Gtilde = SGgTildeMatrix(cp,ob)
%
%    Arguments:
%    cp = the matrix containing the contac points locations
%    ob = the center coordinates of the object to grasp
%    References:
%    http://www.centropiaggio.unipi.it/sites/default/files/grasp-RAS94.pdf
%
%    See also: SGjacobianMatrix, SGselectionMatrix, SGgraspMatrix

%    Copyright (c) 2011 SIRSLab
%    Department of Information Engineering
%    University of Siena
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


function Gtilde = SGgTildeMatrix(Cp,ob)
% Builds the grasp matrix G for a configuration
% with n contact point c_i and normals n_i.
% Contact point coordinates in base frame are passed
% as rows of argument Cp (nx3). 
% ob is the center of mass vetor.

[n ndim] = size(Cp);
G = zeros(ndim, n*ndim);
I = eye(ndim);
k = 1; % first column index
for i = 1:n
    % Same as G = []; G = [G I]; - dimensions statically determined
    G(:,k:(k+ndim-1)) = I;
    k = k + ndim;
end

if ndim == 3
    Gl = zeros(ndim, n*ndim);
    k = 1;
    for i=1:n        
        Cx = [ 0 -(Cp(i,3)-ob(3)) (Cp(i,2)-ob(2));
               (Cp(i,3)-ob(3)) 0 -(Cp(i,1)-ob(1));
              -(Cp(i,2)-ob(2)) (Cp(i,1)-ob(1)) 0];
        Gl(:,k:(k+ndim-1)) = Cx;    
    k = k + ndim;
    end
    
elseif ndim == 2
    Gl = zeros(1, n*ndim);
    k = 1;
    for i=1:n        
        Cx = [-(Cp(i,2)-ob(2)) (Cp(i,1)-ob(1))]; 
        Gl(:,k:(k+ndim-1)) = Cx;        
    k = k + ndim;
    end    
end

if ndim==3
    Gtilde = [G zeros(ndim,ndim*n);Gl G];
else
    Gtilde = [G zeros(ndim,n);Gl ones(1,n)];
end
