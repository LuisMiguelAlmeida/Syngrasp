%    SGquasistaticHsolution - Evaluate the kinematic manipulability principal
%    directions
%
%    Usage: SGquasistaticHsolution(hand, object)
%
%    Arguments:
%    hand, object: structures that contain hand and object grasp properties
%
%    Returns: 
%    Gamma: matrix whose columns represent the solution of the grasp
%    problem in a quasi-static framework
%
%    References
%    D. Prattichizzo, M. Malvezzi, M. Gabiccini, A. Bicchi. On the 
%    Manipulability Ellipsoids of Underactuated Robotic Hands with 
%    Compliance. Robotics and Autonomous Systems, Elsevier, 2012.
%    http://sirslab.dii.unisi.it/papers/2012/PrattichizzoRAS2012Grasping.pdf
%
%    See also:  SGkinManipulability, SGforceManipulability
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

function Gamma = SGquasistaticHsolution(hand, object)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end
if(~SGisObject(object))
    error 'object argument is not a valid object-structure' 
end

% evaluate quasistatic linear maps
linMaps = SGquasistaticMaps(hand,object);
E = ima(linMaps.P);


G = object.G;
J = hand.J;
S = hand.S;
Ks = object.Kc;
Kq = hand.Kq;
Kz = hand.Kz;


nq = size(hand.q,1);
nd = 6; %%% 3-dimensional case
nz = size(hand.S,2);
nl = 3*size(object.cp,2);
nh = rank(E);
nrb = max(nz-nh,0);

%if geometric effects are not provided in the hand structure, neglect them
if ~isfield(hand,'Kju')
    Kju0 = zeros(nq,nd);
else
    Kju0 = hand.Kju;
end

if ~isfield(hand,'Kjq')
    Kjq0 = zeros(nq,nq);
else
    Kjq0 = hand.Kjq;
end

if ~isfield(hand,'Ksz')
    Ksz0 = zeros(nz,nz);
else
    Ksz0 = hand.Ksz;
end

% zeros(,nd)  zeros(,nl)   zeros(,nq)  zeros(,nz) zeros(,nd) zeros(,nq) zeros(,nz) zeros(,nz)

Mh = [eye(nd)       G             zeros(nd,nq)    zeros(nd,nz) zeros(nd,nd) zeros(nd,nq) zeros(nd,nz) zeros(nd,nz);
    zeros(nq,nd)     -J'           eye(nq)       zeros(nq,nz) zeros(nq,nd) zeros(nq,nq) zeros(nq,nz) zeros(nq,nz);
    zeros(nz,nd)  zeros(nz,nl)   -S'           eye(nz)    zeros(nz,nd) zeros(nz,nq) zeros(nz,nz) zeros(nz,nz);
    zeros(nl,nd)  eye(nl)       zeros(nl,nq)    zeros(nl,nz)      Ks*G'      -Ks*J      zeros(nl,nz) zeros(nl,nz);
    zeros(nq,nd)  zeros(nq,nl)      eye(nq)    zeros(nq,nz) zeros(nq,nd)      Kq          -Kq*S zeros(nq,nz);
    zeros(nz,nd)  zeros(nz,nl)  zeros(nz,nq)     eye(nz)     zeros(nz,nd) zeros(nz,nq)    Kz            Kz ];

Gamma1 = ker(Mh);
%
%%%% numerical approximation
Gamma0 = zeros(size(Gamma1));
gammatol = 1e-7;
for i = 1:size(Gamma1,1)
    for j = 1:size(Gamma1,2)
        if abs(Gamma1(i,j)) > gammatol
            Gamma0(i,j) = Gamma1(i,j) ;
        end
    end
end

in_row(1) = 1; 
in_row(2) = nd; %delta w
in_row(3) = in_row(2)+nl;%delta lambda
in_row(4) = in_row(3)+nq;%delta tau
in_row(5) = in_row(4)+nz;%delta sigma
in_row(6) = in_row(5)+nd;%delta u
in_row(7) = in_row(6)+nq;%delta q
in_row(8) = in_row(7)+nz;%delta z
in_row(9) = in_row(8)+nz;%delta zr

in_col(1) = 1;
in_col(2) = nd;
in_col(3) = in_col(2)+nh;
in_col(4) = in_col(3)+nrb;

Gamma.all = Gamma0;
% coordinated motions
Gamma.wco = Gamma0(1:in_row(2),1:in_col(2));
Gamma.lco = Gamma0(in_row(2)+1:in_row(3),1:in_col(2));
Gamma.tco = Gamma0(in_row(3)+1:in_row(4),1:in_col(2));
Gamma.sco = Gamma0(in_row(4)+1:in_row(5),1:in_col(2));
Gamma.uco = Gamma0(in_row(5)+1:in_row(6),1:in_col(2));
Gamma.qco = Gamma0(in_row(6)+1:in_row(7),1:in_col(2));
Gamma.zco = Gamma0(in_row(7)+1:in_row(8),1:in_col(2));
Gamma.zrco = Gamma0(in_row(8)+1:in_row(9),1:in_col(2));
% internal forces
Gamma.wh = Gamma0(1:in_row(2),in_col(2)+1:in_col(3));
Gamma.lh = Gamma0(in_row(2)+1:in_row(3),in_col(2)+1:in_col(3));
Gamma.th = Gamma0(in_row(3)+1:in_row(4),in_col(2)+1:in_col(3));
Gamma.sh = Gamma0(in_row(4)+1:in_row(5),in_col(2)+1:in_col(3));
Gamma.uh = Gamma0(in_row(5)+1:in_row(6),in_col(2)+1:in_col(3));
Gamma.qh = Gamma0(in_row(6)+1:in_row(7),in_col(2)+1:in_col(3));
Gamma.zh = Gamma0(in_row(7)+1:in_row(8),in_col(2)+1:in_col(3));
Gamma.zrh = Gamma0(in_row(8)+1:in_row(9),in_col(2)+1:in_col(3));
% rigid body motion
Gamma.wrb = Gamma0(1:in_row(2),in_col(3)+1:in_col(4));
Gamma.lrb = Gamma0(in_row(2)+1:in_row(3),in_col(3)+1:in_col(4));
Gamma.trb = Gamma0(in_row(3)+1:in_row(4),in_col(3)+1:in_col(4));
Gamma.srb = Gamma0(in_row(4)+1:in_row(5),in_col(3)+1:in_col(4));
Gamma.urb = Gamma0(in_row(5)+1:in_row(6),in_col(3)+1:in_col(4));
Gamma.qrb = Gamma0(in_row(6)+1:in_row(7),in_col(3)+1:in_col(4));
Gamma.zrb = Gamma0(in_row(7)+1:in_row(8),in_col(3)+1:in_col(4));
Gamma.zrrb = Gamma0(in_row(8)+1:in_row(9),in_col(3)+1:in_col(4));






 
 
