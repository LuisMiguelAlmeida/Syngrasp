%   SGdistSingularConfiguration - grasp quality measures
%
%   Quality measures associated with the hand configuration
%   ->Distance to singular configurations
%
%   This group of quality measures includes those that consider
%   the hand configuration to estimate the grasp quality.
%   In order to keep redundant fingers far from singular configurations, 
%   it is desirable to maximize the smallest singular value
%   Smin of the manipulator Jacobian.
%   Therefore, by using SminHO as a quality measure, 
%   maximizing the quality is equivalent to choose a grasp configuration 
%   far away from a singular one. Then:
%   Q =SminHO.
%   Where HO is the hand-object Jacobian.
%
%   Usage: [SminHO] = SGDistanceToSingularConfigurations (G,J)
%    Arguments:
%    G = grasp matrix
%    J = hand jacobian matrix   
%
%    Returns:
%    SminHO = DistanceToSingularConfigurations
%    See also: SGmanipulEllipsoidVol,SGUnifTrans.
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
 
function [SminHO] = SGdistSingularConfiguration(G,J)
 
 Gc=G'*inv(G*G');
 HO=Gc'*J;
 SminHO=sqrt(eigs(HO*(HO'),1,'sm')); 

end