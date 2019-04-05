%    SGmakehand - Create a hand
%
%    The function define a hand structure
%
%    Usage: hand = SGmakehand(F)
%
%    Arguments:
%    F = array of finger structures defined by SGmakeFinger
%
%    Returns:
%    hand = the hand structure
%
%    See also: SGmakeFinger
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

function hand = SGmakeHand(F)

%%% Pre-allocation
hand = struct('F',[],'n',[],'m',[],'q',[],'qin',[],'qinf',[],'ctype',[], ...
            'ftips',[],'S',[],'cp',[],'Kq',[],'Kz',[],'H',[],'J',[],'JS',[],'Wr',[]);

hand.F = F;
hand.n = length(F);   

m=0;
for i = 1:hand.n
    if(~SGisFinger(F{i}))
        error(sprintf('Argument F contains a non-finger struct @ %d',i))
    end
    m = m + F{i}.n;
end

hand.m=m;          % number of degrees of freedom of the hand

for i = 1: hand.n    
    hand.q =[hand.q ; F{i}.q];
    qin = i*ones(size(F{i}.q));  
    hand.qin =[hand.qin ; qin];
    hand.qinf = [hand.qinf; F{i}.qin]; 
end

hand.ctype = 1;

hand.ftips = SGfingertips(hand);
hand.S = eye(size(hand.q,1),size(hand.q,1)); 

nj = length(hand.q);
hand.Kq = eye(nj);
hand.Kz = eye(nj);
hand.Kw = eye(6);

           
hand.limit = zeros(length(hand.q),2);
hand.limit(:,2) = pi/2*ones(length(hand.q),1);

hand.active = ones(length(hand.q),1);

hand.Wr = zeros(6,1);

hand.type = 'User Defined Hand';
hand = SGjoints(hand);

