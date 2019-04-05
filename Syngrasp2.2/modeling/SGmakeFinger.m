%    SGmakeFinger - Create a finger
%
%    The function defines a finger structure from given arguments
%
%    Usage: finger = SGmakeFinger(DHpars, base, q)
%
%    Arguments:
%    DHpars = n (number of joints) x 4 matrix containing Denavit Hartenberg
%    parameters for each joint 
%    base = 4 x 4 homogeneous transformation matrix for the finger frame
%    q = n x 1 vector containing values of joint variables
%
%    Returns:
%    finger = the finger structure
%
%    See also: SGmakehand
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


function finger=SGmakeFinger(DHpars,base,q)

%%%Parameter check
checkParams(DHpars,base,q);

%%% Pre-allocation
finger = struct('n',[],'DHpars',[],'base',[],'q',[],'qin',[]);

%%% DHpars: Denavit_Hartenberg parameters

finger.DHpars = DHpars;
finger.n = size(DHpars,1);
finger.base = base;

finger.q = q;
finger.qin = cumsum(ones(size(q))); % index indicating the position of each joint in the finger


function checkParams(DHpars,base,q)

    [rdh,cdh] = size(DHpars);
    [rb,cb] = size(base);
    [rq,cq] = size(q);

    if(cq ~= 1)
        error 'q is not a column vector'
    end
    if(rdh ~= rq)
        error 'DHpars number of rows must be the same as q number of columns'
    end
    if(rb ~= 4 || cb ~= 4 || sum(abs(base(4,1:3))) ~= 0 || base(4,4) ~= 1)
        error 'base is not a valid homogeneous transformation matrix'
    end
    if(cdh ~= 4)
       error 'Denavit-Hartenberg parameter matrix must have 4 columns' 
    end    
    
end

end