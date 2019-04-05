%    SGcontact - Define the contact point on the object
%    This function is used by grasp planner procedure and is called by
%    SGcloseHand to define the contact points on the object
%
%    This function defines the contact points on the grasped object
%
%    Usage: [newHand,object] = SGcontact(hand,obj)
%
%    Arguments:
%    hand = the hand structure on which the contact points are defined
%    obj = the grasped object
%
%    Returns:
%    newHand = the hand in contact with the object
%    object = the grasped object structure enriched with the matrices
%    relevant to grasp analysis
%
%    See also: SGcloseHand, SGgraspPlanner, SGmakeObject
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

function [newHand,object] = SGcontact(hand,obj)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure'
end

object = obj;
newHand = hand;
if (size(hand.cp,2) == 0)
    
    object.H = [];
    object.G = [];
    object.Kc = [];
    object.Gtilde = [];
    newHand.H = [];
    newHand.J = [];
    newHand.JS = [];
    
    
else
    switch obj.type
        case 'sph'
            center = obj.center;
            CPs = hand.cp(1:3,:);
            normals = zeros(size(CPs));
            for cont=1:size(CPs,2)
                normals(:,cont) = (obj.center - CPs(:,cont))/norm(obj.center - CPs(:,cont));
            end
            [newHand,tmp_object] = SGmakeObject(hand,center,normals);
            object.cp = tmp_object.cp;
            object.H = tmp_object.H;
            object.G = tmp_object.G;
            object.Gtilde = tmp_object.Gtilde;
            object.Kc = tmp_object.Kc;
            object.normals = tmp_object.normals;
        case 'cyl'
            center = obj.center;
            CPs = hand.cp(1:3,:);
            normals = zeros(size(CPs));
            axis = obj.axis;
            for cont=1:size(CPs,2)
                proj = ((CPs(:,cont)'*axis)/(axis'*axis))*axis;
                normals(:,cont) = (proj-CPs(:,cont))/(norm(proj-CPs(:,cont)));
            end
            [newHand,tmp_object] = SGmakeObject(hand,center,normals);
            object.cp = tmp_object.cp;
            object.H = tmp_object.H;
            object.G = tmp_object.G;
            object.Gtilde = tmp_object.Gtilde;
            object.Kc = tmp_object.Kc;
            object.normals = tmp_object.normals;
        case 'cube'
            center = obj.center;
            CPs = hand.cp(1:3,:);
            normals = zeros(size(CPs));
 
            for cont=1:size(CPs,2)
                face = SGfaceDetector(CPs(:,cont),obj);
                normals(:,cont) = object.faces.n(:,face);
            end
            [newHand,tmp_object] = SGmakeObject(hand,center,normals);
            object.cp = tmp_object.cp;
            object.H = tmp_object.H;
            object.G = tmp_object.G;
            object.Gtilde = tmp_object.Gtilde;
            object.Kc = tmp_object.Kc;
            object.normals = tmp_object.normals;
        otherwise
            error 'invalid object type: it should be sph, cyl or cube'
    end
    
    
    
    object.base = [eye(3) object.center; zeros(1,3) 1];
    newHand.objectbase = object.base;
    object.Kc = eye(3*size(object.cp,2));
    object.H = SGselectionMatrix(object);
    [object.Gtilde,object.G] = SGgraspMatrix(object);
    newHand.H = object.H;
    newHand.J = newHand.H * newHand.Jtilde;
    newHand.JS = newHand.J * newHand.S;
end
end
