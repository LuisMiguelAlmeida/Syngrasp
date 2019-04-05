% SGhumanWritingConf - define a configuration for handwriting tasks in
% human hand
%
% This function defines for the hand structure, a configuration
% corresponding to handwriting tasks. It should be used only with the
% 20-DoF model of the human hand
%
% Usage: newhand = SGhumanWritingConf(hand)
% 
% Arguments: 
%     hand = a structure containing the human hand parameters
%
% Returns:
%     newhand = an updates structure containing the human hand parameters
%
% Reference: D. Prattichizzo, M. Malvezzi, Evaluating human hand  
%            manipulability performance during handwriting tasks, presented
%            at the workshop "Hand Synergies: how to tame the complexity of
%            grasping", ICRA 2013
%
% See also: SGhumanHand
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


function newhand = SGhumanWritingConf(hand)
% thumb
q(1) = pi;
q(2) = 3/4*pi;
q(3) =0.3;
q(4) = 0.1     ;
% index
q(5) = 0.15;
q(6) = 0.7;
q(7) = 1.5;
q(8) = 0;
% middle
q(9) = 0.1;
q(10) = 0.7665;
q(11) = 1.7598;
q(12) = 0;
% ring
q(13) = -0.1479;
q(14) = 1.1946;
q(15) =  1.4081;
q(16) =  0.9388;
% little
q(17) = -0.3563;
q(18) = 1.5801;
q(19) =  1.2122;
q(20) =  0.8081;

newhand = SGmoveHand(hand,q);
