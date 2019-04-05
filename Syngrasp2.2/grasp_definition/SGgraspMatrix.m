%    SGgraspMatrix - Computes the Grasp matrix
%
%    The function computes the Grasp matrix of the given object structure
%
%    Usage: G = SGgraspMatrix(object)
%
%    Arguments:
%    object = the object for which the grasp matrix is computed
%    
%    Returns:
%    G = the grasp matrix
%
%    References:
%    D. Prattichizzo, J. Trinkle. Chapter 28 on Grasping. 
%    In Handbook on Robotics, B. Siciliano, O. Kathib (eds.), Pages 671-700, 2008.
%    http://sirslab.dii.unisi.it/papers/grasping/grasping_chapter_HANDBOOK0
%    8.pdf
%
%    See also: SGjacobianMatrix, SGselectionMatrix
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


function [Gtilde,G] = SGgraspMatrix(object)

% contact point location
Cp = object.cp(1:3,:)'; % transpose in order to be compatible with the old version

% selection matrix
H=object.H;

% object center coordinate
ob=object.base(1:3,4);

% build G matrix
Gtilde=SGgTildeMatrix(Cp,ob);

if (isfield(object,'H'))
    
    G=(H*Gtilde')';

else
    
    G = Gtilde;
    
end
end