%  SGmakeObject - create an object structure for a given hand
% 
%  This function defines a structure object, given the contact points on
%  the hand, the object center (opt) and the contact normal directions. 
% 
%  Usage: [newHand,object] = SGmakeObject(hand,center,normals)
%  Arguments: 
%        hand: a structure defining the hand structure
%        center(opt): object center coordinates
%        normals: directions normal to the contact surface in the contact
%        points
% 
%  Returns:
%        newhand: an updated structure of the hand
%        object: a structure containing object data
% 
%  See also: SGmakeHand, SGgraspMatrix, SGselectionMatrix
%
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




function [newHand,object] = SGmakeObject(hand,center,normals)
 object.cp = hand.cp(1:3,:);
    object.cp(4,:) = hand.cp(7,:);
    ncp = size(object.cp,2);
    
    switch nargin        
        case 1            
            object.center = mean(object.cp(1:3,:),2);
            object.normals = zeros(3,ncp);            
            for i=1:ncp                
                tmp = object.center - object.cp(1:3,i);
                object.normals(:,i) = tmp/norm(tmp);                
            end
        case 2
            sc = size(center);
            if(~(sc(1) == 1 && sc(2) == 3) && ~(sc(1) == 3 && sc(2) == 1))
                error 'argument center should be an R3 vector'
            end
            
            if(size(center,2) == 1)
                object.center = center;                
                object.normals = zeros(3,ncp);                
                for i=1:ncp                    
                    tmp = center - object.cp(1:3,i);
                    object.normals(:,i) = tmp/norm(tmp);
                end
            else
                object.center = mean(object.cp(1:3,:),2);
                if(size(normals,2) == ncp)
                    for i=1:ncp
                        object.normals(:,i) = normals(:,i)/norm(normals(:,i));
                    end
                else
                    error('SG: Size of input matrix of normals is incorrect')
                end
            end
        case 3
            sc = size(center);
            if(~(sc(1) == 1 && sc(2) == 3) && ~(sc(1) == 3 && sc(2) == 1))
                error 'argument center should be an R3 vector'
            end
            
            object.center = center;
            if(size(normals,2) == ncp)
                for i=1:ncp
                    object.normals(:,i) = normals(:,i)/norm(normals(:,i));
                end
            else
                error('SG: Size of input matrix of normals is incorrect')
            end
        otherwise
            error('SG: The number of input arguments is incorrect.');
    end
    
    newHand = hand;
    object.base = [eye(3) object.center; zeros(1,3) 1];
    newHand.base = object.base;
    object.Kc = eye(3*size(object.cp,2));
    object.H = SGselectionMatrix(object);
    [object.Gtilde,object.G] = SGgraspMatrix(object);
    object.type = 'auto';
    newHand.H = object.H;
    newHand.Jtilde = SGjacobianMatrixV2(newHand);
    newHand.J = newHand.H * newHand.Jtilde;
    newHand.JS = newHand.J * newHand.S;
end