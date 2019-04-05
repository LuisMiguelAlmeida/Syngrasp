%    SGrotx - Rotation matrix along x axis
%
%    The function returns the rotation matrix along x axis 
%
%    Usage: [R] = SGrotx(x)
%
%
%    Arguments: x = the rotation angle
%    
%
%    See also: SGroty, SGrotz
%
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

function [R] = SGrotx(x)

R=[
   1  0       0;
   0  cos(x)  -sin(x);
   0  sin(x)  cos(x)
   ];