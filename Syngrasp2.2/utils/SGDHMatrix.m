%    SGDHMatrix - Computes the Denavitt-Hartenberg homogeneous transformation matrix
%
%    The function computes the D-H homogeneous transformation matrix 
%    following the classical D-H convention
%
%    Usage: [H] = SGDHMatrix(v)
%
%    Arguments:
%    v = a row of the matrix DHpars of a finger structure containing the D-H parameters 
%   
%
%    See also: SGcontact_points, SGmakeFinger

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


function [H] = SGDHMatrix(v)

alpha= v(1);
A = v(2);
theta = v(3);
D = v(4);
% alpha,theta -> radians
% Denavit-Hartenberg homogeneous transformation matrix
H = [ cos(theta)  -sin(theta)*cos(alpha)   sin(theta)*sin(alpha)   A*cos(theta);
      sin(theta)   cos(theta)*cos(alpha)  -cos(theta)*sin(alpha)   A*sin(theta);
      0            sin(alpha)              cos(alpha)              D;
      0            0                       0                       1];
  