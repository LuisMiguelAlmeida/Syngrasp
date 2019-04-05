%    SGplotObject - Plot an object
%
%    The function plots a the object given as input argument
%
%    Usage: SGplotObject(object,radius,nps) 
%    plots the object described in
%    the structure object. The default object is a sphere defined by the
%    radius and the number of pixel nps.
%
%    Arguments:
%    object : the object to be plotted
%    radius : radius for the sphere
%    nps : number of pixels for the sphere
%
%    See also: SGplotHand, SGplotCube, SGplotSphere, SGplotCylinder
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


function SGplotObject(object,radius,nps)

if nargin < 1 || nargin > 3
    error 'wrong number of arguments'
end


switch object.type
    
    case 'auto'
    
        if(~SGisObject(object))
            error 'object argument is not a valid object-structure' 
        end
        if nargin == 1
            % default settings
            radius = 5;
            nps = 5;
        elseif nargin == 2
            nps = 5;
        end
        
        cp = object.cp(1:3,:)';
        % object center
        co = mean(cp);
        
        % number of contact points
        [nc,tmp] = size(cp);
        
        % contact normal unitary vectors
        ncp = zeros(nc,3);
        for i = 1:nc
            ncp(i,:) = (co - cp(i,:))/norm(co - cp(i,:));
        end
        
        
        X = cp;
        
        for i = 1:nc
            [filletx,fillety,filletz] = sphere(nps);
            spherecenter = cp(i,:) + radius*ncp(i,:);
            for j = 1:nps+1
                for k = 1:nps+1
                    fillett = radius*[filletx(j,k) fillety(j,k) filletz(j,k)]+ spherecenter;
                    X = [X;fillett];
                end
            end
        end
        
        k = convhulln(X);
        h = trisurf(k,X(:,1),X(:,2),X(:,3));
        aquamarine = [127/255 1 212/255];
        set(h, 'EdgeColor', aquamarine*.8, 'FaceColor', aquamarine);
        hold on
        plot3(cp(:,1),cp(:,2), cp(:,3),'r*','Markersize', 5);
    
    case 'cube'
        hold on
        SGplotCube(object);
    case 'cyl'
        SGplotCylinder(object);
    case 'sph'
        SGplotSphere(object);
end

axis('equal')

