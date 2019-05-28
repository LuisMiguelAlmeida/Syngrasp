close all
clear all
clc

hand = VizzyHandModel;

[qm, S] = SGsantelloSynergies;
S=S(1:13, 1:10); 
hand = SGdefineSynergies(hand,S(:,1:4),qm); 
qm = qm(1:13);
figure(1)
SGplotHand(hand);
hand = SGmoveHand(hand,qm);
grid on  

figure(2)
SGplotHand(hand);
hold on
grid on 
% The fingers on which contact points will be placed -> 4
hand = SGaddFtipContact(hand,1,1:4);
 
[hand,object] = SGmakeObject(hand); 
 
SGplotObject(object);
%Syngrasp_GUI
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