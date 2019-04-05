%    SGevaluateOffset - Used by SGgraspPlanner
%
%    The function allows to compute the initial positions of the hands in
%    the grasp planning. 
%
%    Usage: offset = SGevaluateOffset(hand)
%
%    Arguments:
%    hand = the hand structure on which the contact points lie
%
%    Returns:
%    offeser = the offeset need to correctly place the hand
%
%    See also: SGgraspPlanner
%
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


function offset = SGevaluateOffset(hand)

offset = [0 0 0]';

for i = 1:hand.n
offset = offset + hand.F{i}.base(1:3,1:3)*hand.F{i}.base(1:3,4);
end
offset = offset / hand.n;

end

