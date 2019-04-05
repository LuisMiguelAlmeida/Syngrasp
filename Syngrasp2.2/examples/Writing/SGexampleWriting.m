%    SGexampleWriting - SynGrasp demo concerning the anthropomorphic  hand
%    writing
%
%    Usage: SGexampleWriting
%
%    The demo includes
%    hand model, contact point definition, synergy and stiffness matrices
%    definition, grasp analysis and computation of manipulability
%    ellipsoids 
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

close all
clear all
clc
    
hand = SGparadigmatic;

[qm, S] = SGsantelloSynergies;
 
hand = SGdefineSynergies(hand,S,1:15); 


%%%% choose the writing configuration
hand = SGhumanWritingConf(hand);

  
%%%% contact points
% 
% thumb and index fingertip
hand = SGaddFtipContact(hand,1,1:2);
% DP joint of the middle finger
hand = SGaddContact(hand,1,3,3,1);

% define the pencil
[hand,object] = SGmakeObject(hand);

object.center(1) = object.center(1)+12;
object.center(3) = object.center(3)-30;
object.center(2) = object.center(2)+10;
% % 
%%%%% plot the hand, contact points and contact normals
figure(2)
view([-144 10]);

hold on
% plot the contact points and contact normals
plot3(object.center(1),object.center(2),object.center(3),'rd','LineWidth',3,'MarkerSize',8)
hold on
grid on
for i = 1:size(hand.cp,2)
    % assign the contact point to the respective finger
    plot3(hand.cp(1,i),hand.cp(2,i),hand.cp(3,i),'m*','Linewidth',2,'MarkerSize',8)
    quiver3(hand.cp(1,i),hand.cp(2,i),hand.cp(3,i),object.normals(1,i),object.normals(2,i),object.normals(3,i),10,'LineWidth',2)
end
axis('equal')
out = SGdefinePencil(object);
SGplotHand(hand)
 
% 
% re - define hand Jacobian and grasp matrix in the new configuration
hand.Jtilde = SGjacobianMatrix(hand);
H = SGselectionMatrix(object);
object.H = H;
hand.H = H;
hand.J = H*hand.Jtilde;
object.Gtilde = SGgraspMatrix(object);
object.G = object.Gtilde*hand.H';

[nl,nq]= size(hand.J);
[nd]= size(object.G,1);
% 
% choose the synergy indexes
 syn_index = 1:6;
% 
% 
% choose the corresponding columns
 S_rid = S(:,syn_index);
 hand.S = S_rid;
 nz = size(hand.S,2);

 
% define the stiffness matrices
% 
 Ks = eye(nl);
 Kq = eye(nq);
 Kz = eye(nz);
 
object = SGcontactStiffness(object,Ks);
hand = SGjointStiffness(hand,Kq);
hand = SGsynergyStiffness(hand,Kz);
  
% 
 %%%%% constant synergy matrix
 Ksz = zeros(nz,nz);
 Kjq = zeros(nq,nq);
 Kju = zeros(nq,nd);

% evaluate the homogeneous quasi static solution
Gamma = SGquasistaticHsolution(hand,object);


% evaluate the kinematic manipulability ellipsoid
kinmanipulability = SGkinManipulability(Gamma);

% translate the kinematic ellipsoid on the pen tip
% 
kinellips = kinmanipulability.kinellips;
[r,c] = size(kinellips.u1);
for i = 1:r
    for j = 1:c

        u1t(i,j) = kinellips.u1(i,j)+object.center(1);
        u2t(i,j) = kinellips.u2(i,j)+object.center(2);
        u3t(i,j) = kinellips.u3(i,j)+object.center(3);
    end
end
% 
% draw the kinematic manipulability ellipsoid in the workspace
% 
 figure(2)
 hold on
 axis([-60 30 40 120 -100 50])
 mesh(u1t,u2t,u3t)
