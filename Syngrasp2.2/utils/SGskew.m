%    SGskew - Computes the Skew matrix
%
%    The function computes the Skew matrix of a given vector
%
%    Usage: S = SGskew(t)
%
%    Arguments:
%    t = 3 x 1 or 1 x 3 vector 
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

function S = SGskew(t)

S = [
     0      -t(3)  t(2);
     t(3)   0      -t(1);
     -t(2)  t(1)   0
     ];