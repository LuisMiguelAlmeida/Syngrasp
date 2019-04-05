%    SGaddFtipContact - Add contact points on the fingertips
%
%    The function allows to easily place contact points on the fingertips
%    of the specified hand
%
%    Usage: newHand = SGaddFtipContact(hand,type,cwhere)
%
%    Arguments:
%    hand = the hand structure on which the user wants to place the
%       contact points
%    type = a flag indicating the contact type with the following semantics:
%       1: hard finger (2D or 3D);
%       2: soft finger (2D or 3D);
%       3: complete constraint (2D or 3D);
%    cwhere (optional) = the fingers on which contact points will be placed
%       (5 by default)
%
%    Returns:
%    newHand = the hand with the new contact points
%
%    See also: SGaddcontacontact
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

function newHand = SGaddFtipContact(hand,type,cwhere)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end
if(type ~= 1 && type ~= 2 && type ~= 3)
   error 'argument type should 1 (hard finger), 2 (soft finger) or 3 (complete constraint)' 
end
if ~(isscalar(cwhere) || SGisVector(cwhere))
    error 'argument cwhere should be a vector of indexes of finger-structure-array hand.F'
end

for i=1:length(cwhere)
   try
       hand.F{cwhere(i)};
   catch
       error(sprintf('cwhere(%d) = %d causes an out-of-range access in vector of structs hand.F',i,cwhere(i)));
   end
end

tmpHand = hand;

switch nargin
    case 2    
        cwhere = 1:hand.n;
    case 3
    otherwise
        error('SG: The number of input arguments is incorrect.');
end

for i = 1:length(cwhere)
    j = cwhere(i);
    tmpHand = SGaddContact(tmpHand,type,j,tmpHand.F{j}.n,1);
end

newHand = tmpHand;

