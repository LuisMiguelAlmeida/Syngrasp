%    SGplotSyn - Plot the synergistic movement starting from a given
%    configuration
%
%    The function plots the movement of the given hand due to the selected 
%    synergy, starting from a given configuration qm 
%    
%    Usage: SGplotSyn(hand,z,qm)
%
%    Arguments:
%    hand = the hand to move
%    z = the synergy activation vector
%    qm (optional) = starting configuration (the current hand configuration by default)
%
%    See also: SGplotHand
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    Reference: 
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. 
%    On the role of hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
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


function SGplotSyn(hand,z,qm)

figure
hold on
SGplotHand(hand, .2);
switch nargin
    case 2
        tmpHand = SGmoveHand(hand, hand.q + hand.S * z);
    case 3
        tmpHand = SGmoveHand(hand, qm     + hand.S * z);
    otherwise
        error 'bad number of input arguments';
end
SGplotHand(tmpHand);
hold off

end


