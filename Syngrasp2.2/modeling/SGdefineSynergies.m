%    SGdefineSynergies - Defines a Synergy matrix for the hand
%
%    The function allows to define a synergy matrix for the hand structure
%    given as input argument. It creates the hand strucures fields hand.S
%    and hand.JS that are  respectively the synergy matrix and the underactuated Jacobian
%    matrix.
%
%    Usage: hand = SGdefineSynergies(hand,S,qm)
%
%    Arguments:
%    hand = the hand structure on which the user is defining the synergy matrix
%    S = the synergy matrix
%    qm = avarage position of the hand
%
%    Returns:
%    newHand = the hand embedding the desired Synergy matrix
%
%    References:
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, Zaragoza, Spain, June 2011
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf        
%
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. On the role of
%    hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-published.pdf   
%
%    See also: SGactivateSynergies
%
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%  Copyright (c) 2013, M. Malvezzi, G. Gioioso, G. Salvietti, D.
%     Prattichizzo,
%  All rights reserved.
% 
%  Redistribution and use with or without
%  modification, are permitted provided that the following conditions are met:
%      * Redistributions of source code must retain the above copyright
%        notice, this list of conditions and the following disclaimer.
%      * Redistributions in binary form must reproduce the above copyright
%        notice, this list of conditions and the following disclaimer in the
%        documentation and/or other materials provided with the distribution.
%      * Neither the name of the <organization> nor the
%        names of its contributors may be used to endorse or promote products
%        derived from this software without specific prior written permission.
% 
%  THIS SOFTWARE IS PROVIDED BY M. Malvezzi, G. Gioioso, G. Salvietti, D.
%  Prattichizzo, ``AS IS'' AND ANY
%  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%  DISCLAIMED. IN NO EVENT SHALL M. Malvezzi, G. Gioioso, G. Salvietti, D.
%  Prattichizzo BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
%  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
%  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


function newHand = SGdefineSynergies(hand,S,qm)

if(~SGisHand(hand))
   error 'hand argument is not a valid hand-structure' 
end

if(size(qm,1) == 1)
    qm = qm';
end

newHand = hand;

newHand.S = S;        
   

% check performed inside SGisHand function
%if isfield(hand,'J')
    if(size(hand.J,2) == size(newHand.S,1))
        newHand.JS = hand.J * newHand.S;
    end
%end

newHand.Kz = eye(size(newHand.S,2));
newHand.qm = qm;

end