%   SGgraspIsotropyIndex - grasp quality measures
%
%   Quality measures associated with the position of the contact points.
%   ->a)Measures based on algebraic properties of the grasp matrix G.
%   ->a3)Grasp isotropy index.
%
%   This criterion looks for an uniform contribution of the contact forces 
%   to the total wrench exerted on the object, 
%   i.e. tries to obtain an isotropic grasp where the magnitudes of the
%   internal forces are similar.
%   The quality measure, called grasp isotropy index, is defined as:
%   Q=SminG/SmaxG
%   with SmaxG and SminG being the maximum and minimum singular value of G.
%   This index approaches to 1 when the grasp is isotropic (optimal case),
%   and falls to zero when the grasp is close to a singular configuration.
%
%
%   Usage: [Ii] = SGgraspIsotropyIndex (G)
%    Arguments:
%    G = grasp matrix
%
%    Returns:
%    Ii = Grasp isotropy index.
%
%
%    See also:
%    SGminSVG, SGwrenchEllips.
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
 
function [Ii] = SGgraspIsotropyIndex (G)

 SmaxG=sqrt(eigs(G*(G'),1,'lm'));
 SminG = sqrt(eigs(G*(G'),1,'sm'));
 Ii=SminG/SmaxG;

end