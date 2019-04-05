% SGdefinePencil define the pencil reference frame
%
% this function defines an object whose shape and dimesions corresponds to
% a pencil or a stylus, to be used in handwriting tasks.
% 
% Usage: out = SGdefinePencil(object)
%
% Arguments: 
%  Object: a structure containing the contact points on the hand 
%
% Reference: D. Prattichizzo, M. Malvezzi, Evaluating human hand  
%            manipulability performance during handwriting tasks, presented
%            at the workshop "Hand Synergies: how to tame the complexity of
%            grasping", ICRA 2013
%
% See also: SGhumanHand, SGhumanWriting
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

function out = SGdefinePencil(object); 


%%%%%% draw the tool (manually)
theta = [0:pi/3.001:2*pi];
r = 5;

xpencil = r*cos(theta);
ypencil = r*sin(theta);
zpencil1= 15*ones(size(ypencil));
zpencil2=120*ones(size(ypencil));
punta = [0 0 0];


puntipencil0 = [xpencil xpencil  punta(1);
    ypencil ypencil   punta(2);
    zpencil1 zpencil2 punta(3)  ]';

trasla = object.center';

alfa = pi/15;
beta = -pi/10;
gamma = 0;

Ruota = SGrotx(alfa)*SGroty(beta)*SGrotz(gamma);
Ruota = Ruota(1:3,1:3);
for i = 1:size(puntipencil0,1)
    puntipencil(i,:)= (Ruota*puntipencil0(i,:)')'+ trasla;
end
    
    
dt = DelaunayTri(puntipencil);
[ch v] = convexHull(dt);
trisurf(ch, puntipencil(:,1),puntipencil(:,2),puntipencil(:,3), 'FaceColor','interp')
%axis('equal')
% % 
out =1;