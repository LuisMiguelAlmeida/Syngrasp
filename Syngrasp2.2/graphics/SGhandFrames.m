%    SGhandframe - plot the joint and the frame on a hand
%
%
%    Usage: out = SGhandframe(hand,scale)
%
%    Arguments:
%    hand = a hand structure
%    scale = a scale factor for the plot
%
%    Returns:
%    a plot of the hand frames 
%    
%    See also: SGplotjoint, SGplotframeframe
%
%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
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
function out = SGhandFrames(hand,scalef)

% draw the hand joint reference frames

T0 = eye(4);

hold on
% plot the reference frame on the origin
SGplotframe(T0,scalef);
hold on
for i = 1: length(hand.F)
    % plot the frame at the base of the fingers
    SGplotframe(hand.F{i}.base,scalef);
    hold on
    Thand = hand.F{i}.base;
    % plot a link from the wrist origin to the finger base
    plot3([0 Thand(1,4)],[0 Thand(2,4)],[0 Thand(3,4)],'k','LineWidth', 2)
    for j = 1:size(hand.F{i}.DHpars,1)
        % plot the joint
        SGplotjoint(Thand,scalef/2);
        % extract the homogeneous transformation matrix for each link
        Ttr = SGDHmatrix(hand.F{i}.DHpars(j,:));
        pold = Thand(1:3,4);
        Thand = Thand*Ttr;
        pnew = Thand(1:3,4);
        hold on
        SGplotframe(Thand,scalef);
        hold on
        % plit the link
        plot3([pold(1) pnew(1)],[pold(2) pnew(2)],[pold(3) pnew(3)],'k','LineWidth', 2)
    end
end

axis('equal')
hold off

out = 1;