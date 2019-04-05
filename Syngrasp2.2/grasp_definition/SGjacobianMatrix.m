%    SGjacobianMatrix - Computes the Jacobian matrix
%
%    The function computes the Jaconbian matrix of the given hand
%
%    Usage: J = SGjacobianMatrix(hand)
%
%    Arguments:
%    hand = the hand structure whose Jacobian matrix you want to
%            calculate 
%    
%    Returns:
%    J = the Jacobian matrix
%
%    References:
%    D. Prattichizzo, J. Trinkle. Chapter 28 on Grasping. 
%    In Handbook on Robotics, B. Siciliano, O. Kathib (eds.), Pages 671-700, 2008.
%    http://sirslab.dii.unisi.it/papers/grasping/grasping_chapter_HANDBOOK0
%    8.pdf
%
%    See also: SGselectionMatrix, SGgraspMatrix
%
%    See also: SGquasistaticHsolution, SGforceManipulability
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


function J = SGjacobianMatrix(hand)

[tmp,n_con] = size(hand.cp);
n_q = length(hand.q);
Jtilde = zeros(6*n_con,n_q);

for j = 1:n_con % for each contact
    for i = 1:n_q % for each joint

        fingerIndex = hand.qin(i); % finger index        
        qIndex = hand.qinf(i); % joint index inside each finger        
        handIndex = hand.cp(5,j);
        
        if (hand.cp(4,j) == fingerIndex) && (handIndex >= qIndex)             
            % if the contact point is in the considered finger and the
            % joint is before the contact point --> the joint has effect on
            % the contact point
            
            % let's suppose that all the joints are Revolute
            hom = hand.F{fingerIndex}.base;
            
            for k = 1:qIndex-1                
                % find the homogeneous transform between joint and base
                dhlocal = hand.F{fingerIndex}.DHpars(k,:); % select the k-th row of dh matrix 
                Tlocal = SGDHMatrix(dhlocal); 
                hom = hom*Tlocal;
            end
            
            z_i_1 = hom(1:3,3); % z axis corresponding to the i-th joint
            o_i_1 = hom(1:3,4); % origin of the local ref system corresponding to the i-th joint
            dcontact = hand.cp(1:3,j)-o_i_1; % distance between the contact point and the joint ref system origin
            Scontact = -SGskew(dcontact); % build the skew matrix
            dij = Scontact*z_i_1;
            
            % build the Jacobian rows corresponding to the j-th contact
            % point      
            
            Jtilde(3*j-2:3*j,i)=dij;
            Jtilde(3*n_con+3*j-2:3*n_con+3*j,i)=z_i_1;
             
        end
    end
end
            
       
J = Jtilde;  
        


