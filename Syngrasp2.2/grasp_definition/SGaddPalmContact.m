%    SGaddPalmContact - Add a contact point on the hand
%
%    The function allows to define a contact point on the hand's palm givent
%
%    Usage: hand = SGaddPalmContact(hand,type,cwhere,link,alpha)
%
%    Arguments:
%    hand = the hand structure on which the contact points lie
%    type = a flag indicating the contact type with the following semantics:
%       1: hard finger (2D or 3D);
%       2: soft finger (2D or 3D);
%       3: complete constraint (2D or 3D);
%    cwhere = the metacarpal bone on which the contact point lies
%    alpha = an argument that parameterize the position of the contact
%       point on the metacarpal bone (0 = link base; 1 = link end)
%
%    Returns:
%    newHand = the hand with the new contact point on the palm
%
%    See also: SGaddContact, SGmakehand, SGmakeFinger
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

function newHand = SGaddPalmContact(hand,type,cwhere,alpha)

    if(~SGisHand(hand))
        error 'hand argument is not a valid hand-structure' 
    end
    if(type ~= 1 && type ~= 2 && type ~= 3)
       error 'argument type should be 1 (hard finger), 2 (soft finger) or 3 (complete constraint)' 
    end
    if(~isscalar(alpha) || alpha < 0 || alpha > 1)
       error 'argument alpha should be a double such that alpha >= 0(link base) && alpha <= 1(link end)' 
    end
    if(~isscalar(cwhere))
        error 'cwhere should be an index of finger-structure-array hand.F'
    end

    try
        hand.F{cwhere};
    catch
        error(sprintf('cwhere = %d causes an out-of-range access in vector of structs hand.F',cwhere));
    end
    if(cwhere > length(hand.F))
        error(sprintf('Argument cwhere should be a valid metacarpal bone index hand.base{%d} (cwhere >= 1 && cwhere <= length(hand.base{%d}))',cwhere,cwhere));
    end


    newHand = hand;
    
    % calculate the position of the contact point with respect to the base
    % reference system    
    referenceJoint = hand.F{cwhere}.base;
    
  
    
    % the contact point is defined on the tip of each finger
    ncp = size(hand.cp,2);
    
    newContact = zeros(1,7);   
    newContact(1:3) = alpha*referenceJoint(1:3,4); % Contact Point in space
    
    % the following numbers will be necessary when the position of the
    % contact point will be set arbitrarily on a generic link
    
    % fourth row: metacarpal bone number where the contact point is 
    newContact(4) = cwhere;
    
    % fifth row: link number where the contact point is (by default the
    % last one)
    newContact(5) = 0;
    
    % sixth row: a scalar value that parameterize the position of the
    % contact point on the specified link
    newContact(6) = alpha;
   
    % seventh row: the contact type
    newContact(7) = type;
    
    %check for existing contact points in the same position
    found = 0;
    for i=1:size(hand.cp,2)    
        if(hand.cp(:,i) == newContact')
            found = 1; 
            break;
        end
    end
    
    if (found == 0)    
        newHand.cp(:,ncp+1) = newContact';        
    end
       
    newHand.Jtilde = SGjacobianMatrix(newHand);
    
 