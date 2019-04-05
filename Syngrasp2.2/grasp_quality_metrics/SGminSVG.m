%   SGminSVG - evaluate the minimum singular value of matrix G
%    
%   This function evaluates the minimum singular value of matrix G, this
%   parameter is adopted in the literature to evaluate grasp quality. 
%
%   A full-rank grasp matrix G has d singular values given by the 
%   positive square roots of the eigenvalues of GG' . 
%   When a grasp is in a singular configuration (i.e. when at least one
%   degree of freedom is lost due to hand configuration),
%   at least one of the singular values goes to zero. 
%   The smallest singular value of the grasp matrix G, SminG, 
%   is a quality measure that indicates how far is the grasp configuration 
%   from falling into a singular configuration, this is:
%   Q =SminG.
%   The largest SminG , the better the grasp. 
%   At the same time the largest the SminG the largest the minimum transmission
%   gain from the forces f at the contact points to the net wrench w 
%   on the object, which is also used as grasp optimization criterion.
%   Usage: [SminG] = MinimumSingularValueOfG (G)
%
%    Arguments:
%    G = grasp matrix
%
%    Returns:
%    SminG = Minimum singular value of G
%    See also: SGuniTransf, SGmanipEllipsoidVolume.
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

 
 function [SminG] = SGminSVG(G)
 
 SminG = sqrt(eigs(G*(G'),1,'sm'));
 
 end