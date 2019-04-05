%    SGsynergyStiffness - Defines a stiffness matrix for the
%    synergies of the hand
%    
%    The function allows to define a stiffness matrix for the synergies defined 
%    on the hand given as argument
%    
%    Usage: hand = SGsynergyStiffness(hand,stiffness)
%
%    Arguments:
%    hand = the hand on which the synergy matrix is defined
%    stiffness = the stiffness values. This argument could be a scalar or 
%                a matrix with te following semantics:
%            - scalar: the stiffness matrix will be a diagonal matrix with this
%              value on the main diagonal
%            - matrix: the stiffness matrix will be equal to this matrix
%
%    Returns:
%    newHand = the hand with the desired synergy activation stiffness
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
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-pu
%    blished.pdf   
%
%    See also: SGactivateSynergies
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


function newHand = SGsynergyStiffness(hand,stiffness)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end

newHand = hand;
if (isscalar(stiffness))    
    newHand.Kz = stiffness*eye(size(hand.S,2));
else    
    newHand.Kz = stiffness;
end

end