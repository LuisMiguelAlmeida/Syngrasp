%    SGplotframe - plot a frame defined by the 4x4 matrix T
%
%
%    Usage: out = SGplotframe(T,scalef)
%
%    Arguments:
%    T = a 4x4 homogeneous matrix describing the orientation and the origin
%    of a frame
%    scalef = a scale factor for the diagram
%
%    Returns:
%    a plot of the frame 
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
function out = SGplotframe(T,scalef)

% plot the frame corresponding to T homogeneous transformation matrix
% T is a 4x4 matrix
% extract the rotation part and define the frame unit vectors
x = T(1:3,1);
y = T(1:3,2);
z = T(1:3,3);

% extract the rotation part
t= T(1:3,4);

% plot reference frame origin and axis
hold on

plot3(t(1),t(2),t(3),'ko')

quiver3(t(1),t(2),t(3),x(1),x(2),x(3),scalef,'r','LineWidth',2)
quiver3(t(1),t(2),t(3),y(1),y(2),y(3),scalef,'g','LineWidth',2)
quiver3(t(1),t(2),t(3),z(1),z(2),z(3),scalef,'b','LineWidth',2)
hold off
out = 1;
