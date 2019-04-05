%    SGfingertips - evaluates fingertip positions
%
%    This function, for a given hand, evaluates the fingertips coordinates  
%
%    Usage: cp = SGfingertips(hand)
%
%    Arguments:
%    hand = the hand structure which fingertip positions are computed
%    Returns: 
%    cp = a matrix whose columns represent the coordinates of the contact points
% 
%
%    See also: SGmakehand, SGmakeFinger
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

function cp = SGfingertips(hand)

cwhere = 1:hand.n;
cp = zeros(3,hand.n);

for j=1:length(cwhere) % for each finger
    % calculate the position of the contact point with respect to the base
    % reference system
    referenceJoint = hand.F{cwhere(j)}.base;
    for i=2:hand.F{cwhere(j)}.n+1
       localTransf = SGDHMatrix(hand.F{cwhere(j)}.DHpars(i-1,:));
       referenceJoint = referenceJoint*localTransf;       
    end
    % the contact point is defined on the tip of each finger
    cp(1:3,j) = referenceJoint(1:3,4);
    % the following numbers will be necessary when the position of the
    % contact point will be set arbitrarily on a generic link
    % fourth row: finger number where the contact point is 
end
