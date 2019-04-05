%    SGcube - function that calculates cube data organized as a structure.
%                                                      3
%    Faces are ordered as an opened cube , top view: 4 5 2 6
%                                                      1
%
%
%
%    Usage: struct = SGcube(Htr,a,b,c)
%
%    Arguments:
%    Htr = 4x4 homogeneous transformation describing cube position and
%    orientation
%    a,b,c = cube edge lengths
%
%    Returns:
%    struct = a structure containing cube faces, cube vertex, face normals
%    and face mid points
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

function struct = SGcube(Htr,a,b,c)

if nargin < 3
    b = a;
    c = a;
end
if nargin >3 && nargin < 4
    c = b; %arbitrariamente imposto c=b se non specificato
end
struct.type = 'cube';
struct.center = Htr(1:3,4);

%vertices:
Hv1=Htr*SGtransl([a/2,-b/2,-c/2]) ;
v1=Hv1(1:3,4); %vertex 1
Hv2=Htr*SGtransl([a/2,b/2,-c/2]) ;
v2=Hv2(1:3,4); %vertex 2
Hv3=Htr*SGtransl([-a/2,b/2,-c/2]);
v3=Hv3(1:3,4); %vertex 3
Hv4=Htr*SGtransl([-a/2,-b/2,-c/2]);
v4=Hv4(1:3,4); %vertex 4
Hv5=Htr*SGtransl([-a/2,-b/2,c/2]);
v5=Hv5(1:3,4); %vertex 5
Hv6=Htr*SGtransl([a/2,-b/2,c/2]);
v6=Hv6(1:3,4); %vertex 6
Hv7=Htr*SGtransl([a/2,b/2,c/2]);
v7=Hv7(1:3,4); %vertex 7
Hv8=Htr*SGtransl([-a/2,b/2,c/2]);
v8=Hv8(1:3,4); %vertex 8

%faces

struct.Htr = Htr;
struct.dim = [a,b,c];
struct.faces.ver{1}=[v1,v2,v7,v6];
struct.faces.ver{2}=[v2,v3,v8,v7];
struct.faces.ver{3}=[v3,v4,v5,v8];
struct.faces.ver{4}=[v4,v1,v6,v5];
struct.faces.ver{5}=[v1,v4,v3,v2];
struct.faces.ver{6}=[v7,v8,v5,v6];


% normals and mean points

for i = 1:6
    w1 = struct.faces.ver{i}(:,1);
    w2 = struct.faces.ver{i}(:,2);
    w3 = struct.faces.ver{i}(:,3);
    
    m = cross(w1-w2,w3-w2);
    n(:,i) = m/norm(m);
    
    mean1 = mean(struct.faces.ver{i}');
    
    mp(:,i) = mean1';
end

struct.faces.n = n;
struct.faces.mp = mp;

end