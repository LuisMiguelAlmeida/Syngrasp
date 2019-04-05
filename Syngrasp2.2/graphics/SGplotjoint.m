%    SGplotframe - plot a frame defined by the 4x4 matrix T
%
%
%    Usage: out = SGplotjoint(T,scalef)
%
%    Arguments:
%    T = a 4x4 homogeneous matrix describing the orientation and the origin
%    of a frame
%    scalef = a scale factor for the diagram
%
%    Returns:
%    a plot of the joint (a cylinder) 
%    
%    See also: SGplotjoint, SGhandframes
%
%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo
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
function out = SGplotjoint(T,scalef)

% plot a cylinder corresponding to a joint whose position ia defined by the 
% homogeneous matrix T to T homogeneous transformation matrix
% T is a 4x4 matrix
x = T(1:3,1);
y = T(1:3,2);
z = T(1:3,3);

t= T(1:3,4);

% plot reference frame origin and axis
hold on

[x,y,z] = cylinder(scalef/2,10);



for i = 1:size(x,2)
    pup = [x(1,i),y(1,i),scalef*z(2,i)]';
    puptilde = [pup;1];
    pdown = [x(2,i),y(2,i),-scalef*z(2,i)]';
    pdowntilde = [pdown;1];
    
    puptildenew = T *puptilde;
    pdowntildenew = T *pdowntilde;
    
    xn(1,i) = puptildenew(1);
    yn(1,i) = puptildenew(2);
    zn(1,i) = puptildenew(3);
    
    xn(2,i) = pdowntildenew(1);
    yn(2,i) = pdowntildenew(2);
    zn(2,i) = pdowntildenew(3);

end

surf(xn,yn,zn);
out = 1;