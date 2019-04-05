%    SGparadigmatic
%
%    The function builds the Paradigmatic Hand model
%
%    Usage: hand = SGparadigmatic
%
%    Returns:
%    hand = the Paradigmatic hand model
%
%    References:
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, and M. Malvezzi, 
%    ?On the role of hand synergies in the optimal choice of grasping forces?
%    Autonomous Robots, pp. 1?18.
%
%    See also: SG3Fingered, SGDLRHandII, SGmodularHand

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

function newHand = SGparadigmatic(T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 - P A R A D I G M A T I C   H A N D    P A  R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pre-allocation
DHpars{5} = [];
base{5} = [];
F{5} = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thumb
DHpars{1}=[
    -pi/2 0 0 0 ; 
    0 25 0 0 ;            
    pi/2 15 0 0 ;         
    0 10 0 0 ];          

base{1} = [0 -1 0 -37;
    1 0 0 45;
    0 0 1 0
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index
DHpars{2}=[
    -pi/2 0 0 0 ;             % MCP joint (abduction/adduction)
     0 37 0 0 ;             % MCP joint (flexion/extention)
     0 30 0 0 ;             % PIP joint (flexion/extention)
     0 15 0 0];             % DIP joint (flexion/extention)
base{2} = [0 -1 0 -24;
    1 0 0 73;
    0 0 1 0
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Middle
DHpars{3}=[
    -pi/2 0 0 0;        % MCP joint (abduction/adduction)
    0 40 0 0;         % MCP joint (flexion/extention)
    0 35 0 0;         % PIP joint (flexion/extention)
    0 17 0 0];        % DIP joint (flexion/extention)
base{3} = [0 -1 0 -8;
    1 0 0 73;
    0 0 1 0
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Ring
DHpars{4}=[
    -pi/2 0 0 0;        % MCP joint (abduction/adduction)
    0 37 0 0;         % MCP joint (flexion/extention)
    0 30 0 0;         % PIP joint (flexion/extention)
    0 15 0 0];        % DIP joint (flexion/extention)

base{4} = [0 -1 0 8;
    1 0 0 73;
    0 0 1 0
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Little
DHpars{5}=[
    -pi/2 0 0 0;        % MCP joint (abduction/adduction)
    0 27 0 0;         % MCP joint (flexion/extention)
    0 25 0 0;         % PIP joint (flexion/extention)
    0 10 0 0];        % DIP joint (flexion/extention)

base{5} = [0 -1 0 24;
    1 0 0 73;
    0 0 1 0
    0 0 0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(DHpars)
    % number of joints for each finger
    joints = size(DHpars{i},2);
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
newHand.type = 'Paradigmatic';

