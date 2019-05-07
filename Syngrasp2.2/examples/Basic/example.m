%    example - SynGrasp demo concerning the anthropomorphic  hand
%
%    Usage: example
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
%  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

close all
clear all
clc

hand = SGparadigmatic;

[qm, S] = SGsantelloSynergies;
 
hand = SGdefineSynergies(hand,S(:,1:4),qm); 
 
figure(1)
SGplotHand(hand);
hand = SGmoveHand(hand,qm);
grid on  

figure(2)
SGplotHand(hand);
hold on
grid on 
 
hand = SGaddFtipContact(hand,1,1:5);
 
[hand,object] = wwwwwwwwwwwwwwwwwwwwwwww(hand); 
 
SGplotObject(object);

delta_zr = [0 1 0 0]';
variation = SGquasistatic(hand,object,delta_zr);

linMap = SGquasistaticMaps(hand,object);

% object rigid body motions
rbmotion = SGrbMotions(hand,object);


% find the optimal set of contact forces that minimizes SGVcost
E = ima(linMap.P);

ncont = size(E,2);

% contact properties
mu = 0.8;
alpha = 1/sqrt(1+mu^2);
%
fmin = 1;
%
fmax = 30;
%
k = 0.01;
% 
w = zeros(6,1);
% 
pG = pinv(object.G);

y0 = rand(ncont,1);

% options.Display = 'iter';
option.TolX = 1e-3;
option.TolFun = 1e-3;
option.MaxIter = 5000;
option.MaxFunEvals =500;

[yopt,cost_val] = fminsearch(@(y) SGVcost(w,y,pG,E,object.normals,mu, fmin,fmax,k),y0,option);

lambdaopt = E*yopt;

c = SGcheckFriction(w,yopt,pG,E,object.normals,alpha,k);

% solve the quasi static problem in the homogeneous form

Gamma = SGquasistaticHsolution(hand, object);

% evlauate grasp stiffness matrix
Kgrasp = SGgraspStiffness(hand,object);