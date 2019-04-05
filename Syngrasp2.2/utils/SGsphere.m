%    SGsphere - Generates a spherical object
%    
%    This function calculates main data of a sphere used by 
%    grasping-related applications.  
%
%    Usage: struct = SGsphere(Htr,rad,res)
%
%    Arguments:
%    H = homogeneous transformation
%    rad = radius
%    res = number of points on the external surface
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




function struct = SGsphere(Htr,rad,res)
struct.type = 'sph';
struct.res = res;
struct.Htr = Htr;
struct.center = Htr(1:3,4);
struct.radius = rad;
[X,Y,Z] = sphere(res); %creates a unit sphere mesh

struct.p = zeros(3,size(X,2),size(X,1));
for k=1:size(X,1)
    for j=1:size(X,2)
        p = (rad)*[X(k,j);Y(k,j);Z(k,j)];
        p = [p;1];
        v = Htr*p;
        struct.p(:,j,k) = v(1:3);
    end
end

for i=1:size(X,1)
    for j=1:size(X,2)
        struct.X(i,j) = struct.p(1,j,i);
        struct.Y(i,j) = struct.p(2,j,i);
        struct.Z(i,j) = struct.p(3,j,i);
    end
end
end