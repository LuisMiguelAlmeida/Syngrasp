%    SGplotHand - Plot a hand
%
%    The function plots a hand given as argument 
%
%    Usage: SGplotHand(hand,transp)
%
%    Arguments:
%    hand = the hand structure to plot
%    transp = numerical parameter that represents surface transparency
%
%    See also: SGplotSyn, SGmakehand, SGmakeFinger, 
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

function SGplotHand(hand,transp)

if(~SGisHand(hand))
   error 'hand argument is not a valid hand-structure' 
end

if(nargin == 1)
    transp = 1;
end
    
xlabel('x')
ylabel('y')
zlabel('z')

for j=1:hand.n % for each finger
    
    % plot the finger base
    plot3(hand.F{j}.base(1,4),hand.F{j}.base(2,4),hand.F{j}.base(3,4),'r*');
    if(j == 1)         
        hold on        
    end
    
    % plot the joints and the end tip
    referenceJoint = hand.F{j}.base;
    for i=2:hand.F{j}.n+1
       localTransf = SGDHMatrix(hand.F{j}.DHpars(i-1,:));
       refOld = referenceJoint(1:3,4);
       referenceJoint = referenceJoint*localTransf;
       % plot the link
      
       p1 = [refOld(1),refOld(2),refOld(3)]';
       p2 = [referenceJoint(1,4),referenceJoint(2,4),referenceJoint(3,4)]';
       SGplotLink(p1,p2,5,transp);
       
       % plot the joint location
       if i < hand.F{j}.n+1
           h = plot3(referenceJoint(1,4),referenceJoint(2,4),referenceJoint(3,4),'ro');          
           set(h,'MarkerSize',8);
           set(h,'LineWidth',3);
       end
    end

end
SGplotPalm(hand);

hold off