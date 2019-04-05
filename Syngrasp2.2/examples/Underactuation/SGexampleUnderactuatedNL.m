%    SGexampleUnderactuation - SynGrasp demo concerning the modeling and analysis of an
%    underactuated hand
%    
%    Usage: SGexampleUnderactuatedNL
%
%    The demo includes
%    underactuated hand model, contact point definition, stiffness and 
%    synergy matrices definition, grasp analysis
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
%  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.close all

close all
clear all
clc

hand = SGunderActuated1;

% definition of geometrical parameters
% 
a1 = 38;
a3 = 35;
a2 = 20;
a4 = 15;

alpha = 3/4*pi;

% definition of the initial configuration
za = pi/10;
zp = 3/4*pi;

% evaluate q2
q2 = alpha +zp - pi;

% evaluate q1
d = sqrt(a1^2+ a4^2 -2*a1*a4*cos(zp));

gamma1 = acos((a1^2+d^2-a4^2)/(2*a1*d));

gamma2 = acos((a2^2+d^2-a3^2)/(2*a2*d));

q1 = za+gamma1+gamma2;

% evaluate the non linear part of the synergy matrix 
S12 = - ((a4*sin(zp))/(a1^2 - 2*cos(zp)*a1*a4 + a4^2)^(1/2) ...
    - (a4*sin(zp)*(2*a1^2 - 2*a1*a4*cos(zp)))/(2*(a1^2 - 2*cos(zp)*a1*a4 ...
    + a4^2)^(3/2)))/(1 - (2*a1^2 - 2*a1*a4*cos(zp))^2/(4*a1^2*(a1^2 ...
    - 2*cos(zp)*a1*a4 + a4^2)))^(1/2) - ((a1*a4*sin(zp))/(a2*(a1^2 - ...
    2*cos(zp)*a1*a4 + a4^2)^(1/2)) - (a1*a4*sin(zp)*(a1^2 - 2*cos(zp)*a1*a4...
    + a2^2 - a3^2 + a4^2))/(2*a2*(a1^2 - 2*cos(zp)*a1*a4 + a4^2)^(3/2)))...
    /(1 - (a1^2 - 2*cos(zp)*a1*a4 + a2^2 - a3^2 + a4^2)^2/(4*a2^2*...
    (a1^2 - 2*cos(zp)*a1*a4 + a4^2)))^(1/2);


% hand configuration (symmetric for the sake of simplicity)
qm = [q1 q2 q1 q2 q1 q2];

% configuration dependent synergy matrix
Si = [1 S12;
    0 1];

S = [Si zeros(2,4);
    zeros(2,2), Si, zeros(2,2);
    zeros(2,4), Si];

hand = SGdefineSynergies(hand,S(:,1:6),qm); 
 
figure(1)
SGplotHand(hand);
hand = SGmoveHand(hand,qm);
grid on 

figure(2)
SGplotHand(hand);
hold on
grid on
 

% grasp analysis
hand = SGaddFtipContact(hand,1,1:3);
[hand,object] = SGmakeObject(hand); 
kc = 1;
kq = 100;
ka = 1;
kp = 100;
Kq = kq*eye(6);
Kc = kc*eye(9);
Kz = diag([ka ka ka kp kp kp]);
hand = SGjointStiffness(hand,Kq);
hand = SGsynergyStiffness(hand,Kz);
object = SGcontactStiffness(object,Kc); 
 
SGplotObject(object);

% grasp stiffness

K = object.G*inv(inv(object.Kc)+ hand.J*inv(hand.Kq)*hand.J'+hand.J*hand.S*inv(hand.Kz)*hand.S'*hand.J')*object.G';

Kt = K(1:3,1:3);
Kr = K(4:6,4:6);

% controllable internal forces, object displacement
linMap = SGquasistaticMaps(hand,object);

lambdaC = linMap.P(:,1:3);

deltaQ = linMap.Q(:,1:3);

