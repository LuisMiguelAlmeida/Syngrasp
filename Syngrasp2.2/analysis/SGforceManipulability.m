%    SGforceManipulability - Evaluate the force manipulability principal
%    directions
%
%    Usage: SGforceManipulability(Gamma,in_col,Ww,Ws)
%
%    Arguments:
%    Gamma = matrix of the homogeneous solution of grasp problem obtained
%    with the function SGquasistaticHsolution
%    in_col = the index indicating the columns of Gamma to consider in the
%    evaluation
%    Ww,Ws: weights matrices for the external wrench and the synergy
%    forces, respectively 
%
%    Returns: 
%    forceManipulability.V principal directions in the x space
%    forceManipulability.D eigenvalues of the manipulability problem
%    forceManipulability.weig principal directions in the w space
%    forceManipulability.seig principal directions in the sigma space
%
%    References
%    D. Prattichizzo, M. Malvezzi, M. Gabiccini, A. Bicchi. On the 
%    Manipulability Ellipsoids of Underactuated Robotic Hands with 
%    Compliance. Robotics and Autonomous Systems, Elsevier, 2012.
%    http://sirslab.dii.unisi.it/papers/2012/PrattichizzoRAS2012Grasping.pdf
%
%    See also: SGquasistaticHsolution, SGkinManipulability
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


function forceManipulability = SGforceManipulability(Gamma,in_col,Ww,Ws)

Gamma_s = [Gamma.sco Gamma.sh Gamma.srb];
Gamma_w = [Gamma.wco Gamma.wh Gamma.wrb];

nd = size(Gamma.wco,1);
nz = size(Gamma.zco,1);

switch nargin
    case 1
        in_col = 1:size(Gamma_z,2);
        Ww = eye(nd);
        Ws = eye(nz);
    case 2
        Ww = eye(nd);
        Ws = eye(nz);
end
        
Gamma_sm = Gamma_s(:,in_col);
Gamma_wm = Gamma_w(:,in_col);

A = Gamma_wm'*Ww*Gamma_wm;
B = Gamma_sm'*Ws*Gamma_sm;

[V,D] = eig(A,B);

weig = Gamma_wm*V;
seig = Gamma_sm*V;

forceManipulability.V = V;
forceManipulability.D = D;
forceManipulability.weig = weig;
forceManipulability.seig = seig;


