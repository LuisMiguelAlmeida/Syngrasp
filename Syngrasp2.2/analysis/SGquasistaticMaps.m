%    SGquasistaticMaps - Evaluate input/output maps of grasp problem
%
%    The function allows to evaluate input/output maps, solution of the
%    quasistatic formulation of grasp problem
%
%    Usage: linMaps = SGquasistaticMaps(hand,object)
%
%    Arguments:
%    hand = the hand structure 
%    object = the object structure
%
%    Returns: 
%    linMaps.V  = object motion
%    linMaps.P  = contact forces
%    linMaps.Q  = hand joint displacements
%    linMaps.T  = joint torques
%    linMaps.Y  = synergy actual values
%
%    References
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force 
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, 
%    Zaragoza, Spain, June 2011. 
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf
%
%    See also:  SGquasistatic
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


function linMaps = SGquasistaticMaps(hand,object)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end
if(~SGisObject(object))
    error 'object argument is not a valid object-structure' 
end

G0 = object.G;
J0 = hand.J;
S = hand.S;
Ks = object.Kc;
Kq = hand.Kq;
Kz = hand.Kz;

nq = size(hand.q,1);
nd = 6; %%% 3-dimensional case
nz = size(hand.S,2);
nl = 3*size(object.cp,2);

%if geometric effects are not provided in the hand structure, neglect them
if ~isfield(hand,'Kju')
    Kju0 = zeros(nq,nd);
else
    Kju0 = hand.Kju;
end

if ~isfield(hand,'Kjq')
    Kjq0 = zeros(nq,nq);
else
    Kjq0 = hand.Kjq;
end

if ~isfield(hand,'Ksz')
    Ksz = zeros(nz,nz);
else
    Ksz = hand.Ksz;
end

pinvGk = Ks*G0'*inv(G0*Ks*G0');

Pq = (eye(nl) - pinvGk*G0)*Ks*J0;
Vq = inv(G0*Ks*G0')*G0*Ks*J0;
Uq = J0'*Pq+Kjq0+Kju0*Vq;
X = inv(Uq+Kq)*Kq;
Z = S'*Uq*X*S + Ksz;
Y = inv(Z+Kz)*Kz;

% mapping matrices between synergy reference variation and
% - object motion
linMaps.V = Vq*X*S*Y;
% - contact forces
linMaps.P = Pq*X*S*Y;
% - hand joint displacements
linMaps.Q = X*S*Y;
% - joint torques
linMaps.T = Uq*X*S*Y;
% - synergy actual values
linMaps.Y = Y;
% object displacement without synergies
linMaps.Vq = Vq;
% joint displacement without synergies
linMaps.X = X;
% contact forces without synergies
linMaps.Pq = Pq;


end

