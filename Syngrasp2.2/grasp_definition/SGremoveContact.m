%    SGremoveContact - Remove a contact point on the hand
%
%    The function allows to remove a contact point on the hand given as
%    argument
%
%    Usage: hand = SGaddContact(hand,finger,link,alpha)
%
%    Arguments:
%    hand = the hand structure on which the contact points lie
%    object = the object structure where the contact points lie
%    finger = the finger on which the contact point lies
%    link = the link where the contact point lies
%    alpha = an argument that parameterize the position of the contact
%       point on the link (0 = link base; 1 = link end)
%
%    Returns:
%    newHand = the hand without the specified contact point
%
%    See also: SGmakehand, SGmakeFinger, SGaddContact
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

function [new_hand, object] = SGremoveContact(hand,object,finger,link,alpha)

new_hand = hand;
index = 0;
nc = size(hand.cp,2);

for i=1:nc
    if(hand.cp(4,i) == finger && hand.cp(5,i) == link && hand.cp(6,i) == alpha)
        index = i;
    end
end

new_hand.cp = [hand.cp(:,1:index-1) hand.cp(:,index+1:nc)];
object.normals = [object.normals(:,1:index-1) object.normals(:,index+1:nc)];
object.cp = [object.cp(:,1:index-1) object.cp(:,index+1:nc)];
%newHand.Jtilde = SGjacobianMatrix(hand);
newHand.Jtilde = SGjacobianMatrixV2(hand);

