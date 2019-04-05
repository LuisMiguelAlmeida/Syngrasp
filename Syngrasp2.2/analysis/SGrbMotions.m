%    SGrbMotions - Evaluate object rigid body motions
%    
%    This functions evaluates the object rigid body motion allowed in a
%    given configuration of the hand-object system
%
%    Usage: rbmotion = SGrbMotions(hand,object)
%
%    Arguments:
%    hand = the hand structure
%    object = the object structure
%
%    Returns: 
%    rbmotion.Zrb = synergy reference variation
%    rbmotion.Urb = object displacement
%    rbmotion.Qrb = hand joint displacement
%    rbmotion.Zarb = synergy actual variation 
%    rbmotion.Lrb = contact force variation-check variable, should be zero 
%    rbmotion.Trb = joint torques-check variable, should be zero 
%
%    References
%    D. Prattichizzo, M. Malvezzi, A. Bicchi. On motion and force 
%    controllability of grasping hands with postural synergies. 
%    In Robotics: Science and Systems VI, pp. 49-56, The MIT Press, 
%    Zaragoza, Spain, June 2011. 
%    http://sirslab.dii.unisi.it/papers/grasping/RSS2010graspingsynergies.pdf
%
%    See also:  SGquasistatic, SGquasistaticMaps
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

function rbmotion = SGrbMotions(hand,object)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end
if(~SGisObject(object))
    error 'object argument is not a valid object-structure' 
end

linMaps = SGquasistaticMaps(hand,object);

Zrb = ker(linMaps.P);
Urb = linMaps.V*Zrb;
Qrb = linMaps.Q*Zrb;
Zarb = linMaps.Y*Zrb; % = Zrb (only to check)
Lrb = linMaps.P*Zrb; %0 (only to check)
Trb = linMaps.T*Zrb; %0 (only to check)

% synergy variation
rbmotion.Zrb = Zrb;
% object displacement
rbmotion.Urb = Urb;
% hand jonit displacement
rbmotion.Qrb = Qrb;
% actual synergy values, should be equal to the reference
rbmotion.Zarb = Zarb;
% contact forces, should be zero
rbmotion.Lrb = Lrb;
% joint torques, should be zero
rbmotion.Trb = Trb;