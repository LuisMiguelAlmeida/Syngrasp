%    SGquasistatic - Performs a quasistatic analysis
%
%    This function performs a quasistatic analysis of a given grasp
%    resulting from the activation of a given subset of synergies. 
%    Results are stored in the output structure
%  
%    Usage: variation = SGquasistatic(hand,object,delta_zr)
%
%    Arguments:
%    hand = the hand grasping the object
%    object = the object grasped by the hand
%    delta_zr = a reference synergy activation vector. If no
%       synergy matrix are defined for the hand (S is an identity matrix), this argument
%       can be seen as a variation of the joint values
%    
%    Returns:
%    variation.delta_u = the obtained object motion
%    variation.delta_lambda = the variation on the contact forces
%    variation.delta_tau = the variation of the joint torques
%    variation.delta_q = the variation of the real joint position
%    variation.delta_sigma = the variation of the contact forces in the synergy
%       space
%    variation.delta_z = the variation of the real joint position in the
%       synergy space
%    variation.delta_qr = the variation of the reference joint position
%
%    References:
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, Zaragoza, Spain, June 2011
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf        
%
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. On the role of
%    hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-pu
%    blished.pdf   
%
%    See also: SGquasistaticMaps, SGgraspAnalysis
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


function variation = SGquasistatic(hand,object,delta_zr)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end
if(~SGisObject(object))
    error 'object argument is not a valid object-structure' 
end
if(isstruct(delta_zr) || size(delta_zr,1) ~= size(hand.S,2))
    error 'delta_zr argument should be a column vector of Rn, where n == size(hand.S,2)'
end

variation = struct('delta_u',[],'delta_lambda',[],'delta_tau',[],'delta_q',[],...
                'delta_sigma',[],'delta_z',[],'delta_qr',[]);

G0 = object.G;
J0 = hand.J;
S = hand.S;
Ks = object.Kc;
Kq = hand.Kq;
Kz = hand.Kz;

nq = size(hand.q,1);
nd = 6; 
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

variation.delta_u = Vq*X*S*Y*delta_zr;  
variation.delta_lambda = Pq*X*S*Y*delta_zr; 
variation.delta_tau = Uq*X*S*Y*delta_zr;
variation.delta_q = X*S*Y*delta_zr;
variation.delta_sigma = Z*Y*delta_zr; 
variation.delta_z = Y*delta_zr; 
variation.delta_qr = S*delta_zr; 

end

