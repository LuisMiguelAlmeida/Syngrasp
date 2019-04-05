%    SG3Fingered
%
%    The function builds the three fingered hand model inspired by the
%    Barrett Hand
%
%    Usage: hand = SG3Fingered
%
%    Returns:
%    hand = the three finfered hand model
%
%    See also: SGParadigmatic, SGDLRHandII, SGmodularHand

%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo, A. Bicchi
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    SynGrasp is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SynGrasp is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SynGrasp. If not, see <http://www.gnu.org/licenses/>.

function newHand = SG3Fingered(T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 - 3 F I N G E R E D   H A N D    P A  R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a10 = 50;
a20 = 50;
a30 = 50;
a11 = 50;
a21 = 50;
a31 = 50;
a12 = 50;
a22 = 50;
a32 = 50;

%%% Pre-allocation
DHpars{3} = [];
base{3} = [];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 1
% DHpars{1}=[
%     0 a11 0 0 ; 
%     0 a12 0 0 ];  
% 
% base{1} = [1 0 0 a10;
%     0 0 -1 0;
%     0 1 0 0
%     0 0 0 1];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 2
% DHpars{2}=[
%     pi/2 a20 0 0 ;             
%      0 a21 0 0 ;
%      0 a22 0 0];             
%  
% base{2} = [cos(2/3*pi) -sin(2/3*pi) 0 0;
%     sin(2/3*pi) cos(2/3*pi) 0 0;
%     0 0 1 0;
%     0 0 0 1;];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 3
% DHpars{3}=[
%     pi/2 a30 0 0 ;             
%      0 a31 0 0 ;
%      0 a32 0 0];             
%  
% base{3} = [cos(-2/3*pi) -sin(-2/3*pi) 0 0;
%     sin(-2/3*pi) cos(-2/3*pi) 0 0;
%     0 0 1 0;
%     0 0 0 1;];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 1
DHpars{1}=[
    0 a11 0 0 ; 
    0 a12 0 0 ];  

base{1} = [1 0 0 a10;
    0 0 1 0;
    0 -1 0 0
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 2
DHpars{2}=[
    pi/2 a20 0 0 ;             
     0 a21 0 0 ;
     0 a22 0 0];             
 
base{2} = [cos(2/3*pi) -sin(2/3*pi) 0 0;
    sin(2/3*pi) cos(2/3*pi) 0 0;
    0 0 -1 0;
    0 0 0 1;];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finger 3
DHpars{3}=[
    pi/2 a30 0 0 ;             
     0 a31 0 0 ;
     0 a32 0 0];             
 
base{3} = [cos(-2/3*pi) -sin(-2/3*pi) 0 0;
    sin(-2/3*pi) cos(-2/3*pi) 0 0;
    0 0 -1 0;
    0 0 0 1;];

%%% Pre-allocation
F{3} = [];
for i = 1:length(DHpars)
    % number of joints for each finger
    joints = size(DHpars{i},1);
    % initialize joint variables
    q = zeros(joints,1);
    % make the finger
    if (nargin == 1)
        F{i} = SGmakeFinger(DHpars{i},T*base{i},q);
    else
        F{i} = SGmakeFinger(DHpars{i},base{i},q);
    end
end

newHand = SGmakeHand(F);
newHand.type = '3Fingered';
