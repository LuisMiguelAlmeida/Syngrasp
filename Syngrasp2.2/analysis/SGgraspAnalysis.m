%    SGgraspAnalysis - Analyzes the grasp of the hand
%
%    The function analyzes the given grasping configuration in terms of
%    internal forces and object motions. Returns:
%
%    Usage: [E,V,N] = SGgraspAnalysis(hand)
%    
%    Arguments:
%    hand = the hand to analyze
%    
%    Returns:
%    E = matrix of controllable internal forces
%    V = base of internal movements than not generate movements of the
%        object
%    N = matrix of structural forces
%
%    See also: SGgraspMatrix, SGjacobianMatrix
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

function [E,V,N] = SGgraspAnalysis(hand)

% Internal forces
A=null(hand.G);

G=hand.G;
J=hand.J;

% Internal forces of the manipulator
colG=size(G,2);
K=eye(colG);
Q=[A -K*J K*G'];
g=size(A,2);
B=null(Q);          
B1=B(1:g,:);
E=orth(A*B1);       % Active internal forces

% Base of internal movements than not generate movements of the object
V=null(J);

% Structural forces
N=null(J');
