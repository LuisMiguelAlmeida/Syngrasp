%    SGCFtau - Cost function that takes into account hand joint torques
%
%    This function returns a cost function that takes into account hand
%    torques applied to the hand joints
%
%    Usage:  cost = SGCFtau(deltaz,hand,w,Kjoint)
%
%    Arguments:
%    deltazr = synergy reference variation
%    hand = the hand structure 
%    object = the object structure
%    w = external load
%    
%    Returns: 
%    cost = cost function value
%
%    References
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force 
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, 
%    Zaragoza, Spain, June 2011. 
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf
%
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. On the role of 
%    hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-published.pdf
% 
%    See also:  SGquasistaticMaps

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

function cost = SGCFtau(deltazr,hand,object,w)

        linMaps = SGquasistaticMaps(hand,object);
        
        ph=linMaps.P*deltazr-w; 
        
        cost=norm(Kjoint*hand.J'*ph);
