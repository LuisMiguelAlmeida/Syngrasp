% SGhuman24DoF
%
% Author: Maria Pozzi
%
% The function builds the hand model with 24 degrees of freedom.
% 
%      Usage: hand = SGhuman24DoF
%
%      Returns:
%      hand = the 24 DoFs hand model.
%
%      References:
%      S. Cobos, M. Ferre, M. A. Sanchez-Urun, J. Ortego and R. Aracil.
%      "Human hand descriptions and gesture recognition for object 
%      manipulation". Computer Methods in Biomechanics and Biomedical 
%      Engineering , Vol. 13, No. 3, pp. 305 - 317, 2009.
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
  

function [ new_hand ] = Model_Hand_24_dofs

% uIM, uMR, uRL: distances between two consecutive carpus joints:
uIM=3;
uMR=3;
uRL=4;

% Vector u[]: distances between the fingers and the wrist
% Order: T I M R L
u=[15 15 12.5 15 17.5];

% Vector fingers_angles: angles between the y axis of the wrist reference 
% frame and each finger.
fingers_angles = [pi/6 asin(uIM/u(2)) 0 -asin(uMR/u(4)) -(atan(uRL/u(5))+atan(uMR/u(4)))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 -  H A N D    P A  R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thumb
% Links' lengths:
Ltm=45;
Ltp=15;
Ltd=10;
Lt=[Ltm, Ltp, Ltd];

%   al  a   th   d
dhpar{1}=[
     -pi/2 0 0 0 ;           % TM joint (abduction/adduction)
       0 Ltm 0 0 ;           % TM joint (flexion/extension)
      pi/2 Ltp 0 0 ;         % MCP joint (flexion/extension)
       0 Ltd 0 0 ];          % IP joint (flexion/extension)

base{1}=[SGrotz(pi/2+fingers_angles(1)) [0 0 0]'; 0 0 0 1 ]*[SGrotx(0) [u(1) 0 0]'; 0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index
% Links' lengths:
LiMe=45;
LiP=37;
LiMi=30;
LiD=15;
Li=[LiMe LiP LiMi LiD];

%      al  a   th   d
dhpar{2}=[
      pi/2 LiMe 0 0;          % CMC joint
     -pi/2 0 0 0 ;            % MCP joint (abduction/adduction)
       0 LiP 0 0 ;            % MCP joint (flexion/extension)
       0 LiMi 0 0 ;           % PIP joint (flexion/extension)
       0 LiD 0 0];            % DIP joint (flexion/extension) 

base{2}=[SGrotz(pi/2+fingers_angles(2)) [0 0 0]'; 0 0 0 1 ]*[SGrotx(-pi/2) [u(2) 0 0]'; 0 0 0 1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Middle
% Links' lengths:
LmMe=48;
LmP=40;
LmMi=35;
LmD=17;
Lm=[LmMe LmP LmMi LmD];

%      al  a   th   d
dhpar{3}=[
      pi/2 LmMe 0 0;          % CMC joint
     -pi/2 0 0 0 ;            % MCP joint (abduction/adduction)
       0 LmP 0 0 ;            % MCP joint (flexion/extension)
       0 LmMi 0 0 ;           % PIP joint (flexion/extension)
       0 LmD 0 0];            % DIP joint (flexion/extension)

base{3}=[SGrotz(pi/2+fingers_angles(3)) [0 0 0]'; 0 0 0 1 ]*[SGrotx(-pi/2) [u(3) 0 0]'; 0 0 0 1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Ring
% Links' lengths:
LrMe=45;
LrP=37;
LrMi=30;
LrD=15;
Lr=[LrMe LrP LrMi LrD];

%      al  a   th   d
dhpar{4}=[
      pi/2 LrMe 0 0;          % CMC joint
     -pi/2 0 0 0 ;            % MCP joint (abduction/adduction)
       0 LrP 0 0 ;            % MCP joint (flexion/extension)
       0 LrMi 0 0 ;           % PIP joint (flexion/extension)
       0 LrD 0 0];            % DIP joint (flexion/extension)

base{4}=[SGrotz(pi/2+fingers_angles(4)) [0 0 0]'; 0 0 0 1 ]*[SGrotx(-pi/2) [u(4) 0 0]'; 0 0 0 1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Little
% Links' lengths:
LlMe=40;
LlP=27;
LlMi=25;
LlD=10;
Ll=[LlMe LlP LlMi LlD];

%      al  a   th   d
dhpar{5}=[
      pi/2 LlMe 0 0;          % CMC joint
     -pi/2 0 0 0 ;            % MCP joint (abduction/adduction)
       0 LlP 0 0 ;            % MCP joint (flexion/extension)
       0 LlMi 0 0 ;           % PIP joint (flexion/extension)
       0 LlD 0 0];            % DIP joint (flexion/extension)

base{5}=[SGrotz(pi/2+fingers_angles(5)) [0 0 0]'; 0 0 0 1 ]*[SGrotx(-pi/2) [u(5) 0 0]'; 0 0 0 1 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    2 -  BUILT OF THE FINGERS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(dhpar)
    % number of joints for each finger
    joints = size(dhpar{i},1);
    % initialize joint variables
    q = zeros(joints,1);
    % make the finger
    F{i} = SGmakefinger(dhpar{i},base{i},q);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    3 -  BUILT OF THE HAND:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

new_hand=SGmakehand(F);
new_hand.qmin = [0 -15 0 -10 0 0 -40 0 -5 0 0 -40 0 -5 0 0 -40 0 -5 0 0 -40 0 -5 ]'*(pi/180);
new_hand.qmax = [30 40 80 80 5 20 90 110 90 5 0 90 110 90 10 -30 90 120 90 15 -30 90 135 90]'*(pi/180);
new_hand.limit = [new_hand.qmin new_hand.qmax];
new_hand.type = 'Hand with 24 DoFs';

new_hand.Links = {Lt, Li, Lm, Lr, Ll};% cell array containing the lengths  
                                      % of the links

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    4 -  PLOT OF THE HAND:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
SGplotHand(new_hand)
axis('equal')

end
