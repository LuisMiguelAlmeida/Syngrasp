%    SGcheckFriction - check if the friction constraints are satisfied
%
%    The function allow to check the friction constraints
%
%    Usage:  c = SGcheckFriction(w,y,pG,E,n,alpha,k)
%
%    Arguments:
%    w = external load
%    y = coefficients for the linear combination of E columns
%    pG = grasp matrix pseudoinverse
%    E = controllable internal force subspace
%    n = contact normal (matriz 3xnc)
%    alpha = cosine of the friction angle
%    k = positive margin
%
%    Returns: 
%    c= logic variable whose value is 1 if the contact constraint is
%       satisfied for each contact, 0 otherwise
%
%    References
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force 
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, 
%    Zaragoza, Spain, June 2011. 
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. On the role of 
%    hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
%    http://sirslab.dii.unisi.it/papers/2012/GabicciniAUTROB2011grasping-published.pdf
% 
%    See also:  SGquasistatic, SGquasistaticMaps
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


function c = SGcheckFriction(w,y,pG,E,n,alpha,k)

% only for HF contact model
if(~isscalar(alpha) || alpha < -1 || alpha > 1)
    error 'alpha argument should be a cosine value (scalar in [-1,1])'
end

try
    w = w(1:6); % It forces an error if "casually" size(pG,2) == size(w,1) and both are NOT 6
                % forcing a silent error to manifest
    lambda = -pG*w + E*y; 
catch
    error 'input parameters dimensions should be the following: pG[nl x 6], w[6 x 1], E[nl x nh], y[nh x 1]'
end

% evaluate the number of contacts
[tmp,nc] = size(n);
if(tmp ~= 3 || size(lambda,1) ~= 3*nc)
   error 'input parameters dimensions should be such that: pG[3nc x 6], n[3 x nc]' 
end

c = 1;
% for each contact
for i = 1:nc
    % extract the contact force relative to the i-th contact from the
    % lambda vector
    lambdai = lambda(3*i-2:3*i); 
    % i-th contact normal
    ni = n(:,i);
    % for each constraint
    
        sigmaif = alpha*norm(lambdai) -lambdai'*ni;
        % check if the constraint is satisfied and evaluate Vij
        if sigmaif > -k
            c = 0;
        end
    
end


        