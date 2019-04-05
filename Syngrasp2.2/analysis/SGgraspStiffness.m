%    SGgraspStiffness - Evaluate the grasp stiffness matrix
%
%    Usage: K = SGgraspStiffness(hand, object)
%
%    Arguments:
%    hand, object: structures that contain hand and object grasp properties
%
%    Returns: 
%    K: a 6x6 matrix representing the grasp stiffness matrix
%
%    References
%    M. Malvezzi,D. Prattichizzo, "Evaluation of Grasp Stiffness in 
%    Underactuated Compliant Hands", Proceedings, IEEE International 
%    Conference on Robotics and Automation, Karlsruhe, Germany, 2014. 
%
%    See also:  SGkinManipulability, SGforceManipulability,
%    SGquasistaticHsolution
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
%  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
%  THISG
%  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
function K = SGgraspStiffness(hand,object)

Kc = object.Kc;
Kq = hand.Kq;
Kz = hand.Kz;
J = hand.J;
G = object.G; 
S = hand.S;

Kceq = inv(inv(Kc) + J*inv(Kq)*J' + J*S*inv(Kz)*S'*J');
K = G*Kceq*G';














