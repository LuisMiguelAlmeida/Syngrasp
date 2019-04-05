%    SGplotContactForces - Plot contact points, contact forces and object
%    displacements
%
%
%    Usage: out = SGplotContactForces(object,deltalambda,deltau,scale_u,scale_l)
%    
%    Arguments:
%    object = object structure with contact point info
%    deltalambda (opt) = contact force to plot
%    deltau (opt) = object displacement 
%    scale_u (opt) = scale for the representation of object displacement
%    scale_l (opt) = scale factor for the representation of contact forces
%    
%    Returns:
%    a plot representing contact points, contact forces, object center and
%    displacement
%
%    See also: SGgraspAnalysis, SGquasistatic
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
function out = SGplotContactForces(object,deltalambda,deltau,scale_u,scale_l)

    if(~SGisObject(object))
        error 'object argument is not a valid object-structure' 
    end

    nl = size(object.G,2);
    n_con = size(object.cp,2);
    %%% set default values
    if nargin <5 
    scale_l = 10000;
    end
    if nargin < 4
    scale_u = 0.2;
    end
    if nargin<3
    deltau = zeros(6,1);
    end
    if nargin<2
        deltalambda = zeros(nl,1);
    end
    %%% plot functions
    hold on
    grid on
    for i = 1:n_con
        % assign the contact point to the respective finger
        plot3(object.cp(1,i),object.cp(2,i),object.cp(3,i),'m*','Linewidth',2)
        quiver3(object.cp(1,i),object.cp(2,i),object.cp(3,i),object.normals(1,i),object.normals(2,i),object.normals(3,i),10)
    end
    % object center
    plot3(object.center(1),object.center(2),object.center(3),'bd','LineWidth',3,'MarkerSize',8)

    quiver3(object.center(1),object.center(2),object.center(3), deltau(1), deltau(2), deltau(3),scale_u,'LineWidth',2)
    % only for hard finger contact model
    for i = 1:n_con
        % assign the contact point to the respective finger
        %plot3(cp(1,i),cp(2,i),cp(3,i),'m*','Linewidth',2,'MarkerSize',8)
        quiver3(object.cp(1,i),object.cp(2,i),object.cp(3,i),deltalambda(3*i-2),deltalambda(3*i-1),deltalambda(3*i),scale_l,'b','LineWidth',2)
    end
    out = 1;
    
end

