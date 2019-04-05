%    SGDLRHandII
%
%    The function builds a DLR/HIT II Hand model
%
%    Usage: hand = SGDLRHandII
%
%    Returns:
%    hand = the DLRHandII model
%
%    References:
%    J.Butterfass,M.Grebenstein,H.Liu,andG.Hirzinger
%    DLR-handII: next generation of a dextrous robot hand 
%    in Robotics and Automation, 2001. Proceedings 2001 ICRA. 
%    IEEE International Conference on, vol. 1, 2001, pp. 109?114.
%
%    See also: SGParadigmatic, SG3Fingered, SGmodularHand

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

function newHand = SGDLRHandII(T)

H = [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 - DLR/HIT 2   H A N D    P A  R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pre-allocation
DHpars{5} = [];
base{5} = [];
F{5} = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thumb

DHpars{1}=[
    0 0 0 pi/2 ;            
    0 0 55 0 ;         
    0 0 25 0;
    0 0 25 0];        

DHpars{1} = [DHpars{1}(:,4) DHpars{1}(:,3) DHpars{1}(:,2) DHpars{1}(:,1)];

base{1} = H * [ 0.429051 -0.571047 -0.699872 62.569057
0.187173 0.814200 -0.549586 44.544548
0.883675 0.104803 0.456218 80.044647
0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index
DHpars{2}=[
    0 0 0 pi/2 ;            
    0 0 55 0 ;         
    0 0 25 0;
    0 0 25 0];     

DHpars{2} = [DHpars{2}(:,4) DHpars{2}(:,3) DHpars{2}(:,2) DHpars{2}(:,1)];

base{2} = H *  [0 -0.087156 0.996195 -2.529881;
    0 -0.996195 -0.087156 36.800135;
    1 0 0 108.743545;
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Middle
DHpars{3}=[
  0 0 0 pi/2 ;            
    0 0 55 0 ;         
    0 0 25 0;
    0 0 25 0];          

DHpars{3} = [DHpars{3}(:,4) DHpars{3}(:,3) DHpars{3}(:,2) DHpars{3}(:,1)];

base{3} = H * [0 0 1 -003.7;
    0 -1 0 10;
    1 0 0 119.043545;
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Ring
DHpars{4}=[
   0 0 0 pi/2 ;            
    0 0 55 0 ;         
    0 0 25 0;
    0 0 25 0]; 

DHpars{4} = [DHpars{4}(:,4) DHpars{4}(:,3) DHpars{4}(:,2) DHpars{4}(:,1)];

base{4} = H * [0 0.087156 0.996195 -2.529881;
    0 -0.996195 0.087156 -16.800135;
    1 0 0 114.043545;
    0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Pinkie
DHpars{5}=[
   0 0 0 pi/2 ;            
    0 0 55 0 ;         
    0 0 25 0;
    0 0 25 0]; 

DHpars{5} = [DHpars{5}(:,4) DHpars{5}(:,3) DHpars{5}(:,2) DHpars{5}(:,1)];

base{5} = H * [0 0.173648 0.984808 000.971571;
    0 -0.984808 0.173648 -43.396309;
    1 0 0 95.043545;
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

newHand=SGmakeHand(F);
newHand.type = 'DLR';
