%    SGplotBase - Plot the hand base or palm
%
%    Usage: SGplotBase(basepoints,radius,nps)
%
%    Arguments:
%    basepoints : 3xn matrix containing the coordinates of the points to be
%    used to plot the palm
%    radius (opt): fillet radius
%    nps (opt): number of points for the fillet approximation 
%
%    See also: SGplotHand, SGplotObject
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
function SGplotBase(basepoints,radius,nps)

%%%%%% basepoints 3xn points

cp = basepoints';
% object center 
co = mean(cp);

% number of reference points
[nc,tmp] = size(cp);

% contact normal unitary vectors
ncp = zeros(nc,size(co,2));
for i = 1:nc 
    ncp(i,:) = (co - cp(i,:))/norm(co - cp(i,:));
end


%%%% fillet radius
%radius = 5;
%%%% number of points to approximate the fillet sphere
%nps = 5;

%%%%% how could the function be called


%%%%%% begin the object evaluation
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
trisurf(k,X(:,1),X(:,2),X(:,3));

