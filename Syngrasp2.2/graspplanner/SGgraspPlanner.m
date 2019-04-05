%    SGgraspPlanner - Synthesis of a grasp for a given couple hand-object
%
%    The function allows to define the best grasp given an object, the 
%    number of 
%    pregrasp positions of the hand and the quality metric to be used for
%    for grasp evaluation. 
%    
%
%    Usage: [hand_c,object,BEST_INDEX] = SGgraspPlanner(hand,obj,N,qmtype)
%
%    Arguments:
%    hand = the hand structure on which the contact points lie
%    obj = the object structure to be grasped
%    N = the number of random pregrasp positions of the hand 
%    qmtype = the quality metric to be used for grasp evaluation
%
%    Returns:
%    hand_c = the best hand configuration
    %    object = the grasped object
    %    BEST_INDEX = the best quality index obtained
%    
%    See also: SGgenerateCloud, SGcloseHand, SGevaluateOffset
%
%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo, A. Bicchi
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
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



function [hand_c,object,BEST_INDEX] = SGgraspPlanner(hand,obj,N,qmtype)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
switch hand.type
    case 'Paradigmatic'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1]';
        q_init = zeros(1,20);
        q_init(1) = pi/3*2;
        q_init(17)=-pi/12;
        hand = SGmoveHand(hand,q_init);
        D = 5;
    case '3Fingered'
        active=[1 1 0 1 1 0 1 1]';
        D = 25;
    case 'DLR'
        active=[0 1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 ]';
        D = 10;
    case 'Modular'
        active= [1 1 1 1 1 1 1 1 1]';
        D = 20;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


hand_init = hand;

P = SGgenerateCloud(obj,D,N);

offset = SGevaluateOffset(hand);
    
Plan=[];

for i=1:size(P,3)
        
    for j=1:hand.n
        T = hand_init.F{1,j}.base; 
        hand.F{1,j}.base = P(:,:,i)*T*SGtransl(offset);
    end
        
    [hand_c,object] = SGcloseHand(hand,obj,active,0.1);
 
    switch qmtype
        case 'mev'
            if(~isempty(object.G))
            Quality = SGmanipEllipsoidVolume(object.G,hand_c.J);
            else
            Quality = Inf;    
            end
        case 'gii'
            if(~isempty(object.G))
            Quality = SGgraspIsotropyIndex(object.G);
            else
            Quality = Inf;    
            end
        case 'msvg'
            if(~isempty(object.G))
            Quality = SGminSVG(object.G);
            else
            Quality = Inf;    
            end
        case 'dtsc'
            if(~isempty(object.G))
            Quality = SGdistSingularConfiguration(object.G,hand_c.J);
            else
            Quality = Inf;    
            end
        case 'uot'
            if(~isempty(object.G))
            Quality = SGunifTransf(object.G,hand_c.J);
            else
            Quality = Inf;    
            end
        otherwise
            error 'bad quality measure type'
    end
    Plan.Object{i} = object;
    Plan.Hands{i} = hand_c;
    Plan.QIndex{i} = Quality; 
    
%% comment the following part if no figures of the trials are necessary
%     figure(i)
%     subplot(1,2,1)
%     grid on
%     SGplotHand(hand)
%     hold on
%     SGplotSolid(obj)
%     figure(i)
%     subplot(1,2,2)
%     grid on
%     SGplotHand(hand_c);
%     hold on
%     SGplotSolid(obj)
%     
end
Splan = mySort(Plan);
BEST_INDEX = Splan.QIndex{size(P,3)};
BEST_HAND = Splan.Hands{size(P,3)};
BEST_OBJECT = Splan.Object{size(P,3)};
hand_c = BEST_HAND;
object = BEST_OBJECT;



 
end
