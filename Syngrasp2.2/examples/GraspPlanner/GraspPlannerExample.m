%    GraspPlannerExample - SynGrasp demo concerning the grasp planner
%
%    Usage: GraspPlannerExample
%
%    The demo includes
%    Grasp planner, grasp quality evaluation.
% 
%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo, A. Bicchi
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

close all
clear all
clc

%% Select a hand

disp('Select a hand:')
type = input('(paradigmatic,3fingered,modular):  ','s');
%type = 'cylinder';
%type = 'cube';
switch type
    case 'paradigmatic'
       hand = SGparadigmatic;
    case '3fingered'
        hand = SG3Fingered;
    case 'modular'
        hand = SGmodularHand;
    otherwise
        error('bad hand definition');
end


%% Initial definition
R = SGroty(-pi/6);
H = [R,zeros(3,1);zeros(1,3),1];
H(1:3,4) = [-10,60,-40];

%% Define the number of possible starting configuration and the object to grasp (sphere, cube or cylinder)

N = input('set number of grasps:  ');

disp('set type of the object:')
type = input('(sphere,cylinder,cube):  ','s');

switch type
    case 'sphere'
        obj = SGsphere(H,50,40);
    case 'cylinder'
        obj = SGcylinder(H,80,40,50);
    case 'cube'
        obj = SGcube(H,60,60,60);
    otherwise
        error('bad object definition');
end

%% Select quality measure

disp('select the quality measure for the grasp planner')
type = input('(mev,gii,msvg,dtsc,uot):  ','s');



%% Grasp planning

[hand_c,object,index] = SGgraspPlanner(hand,obj,N,type);


%% Plot of the best grasp
figure()
SGplotHand(hand_c);
axis auto
hold on
SGplotSolid(obj);
title('best obtained grasp')
hold on
SGplotContactPoints(hand_c,10,'o')
