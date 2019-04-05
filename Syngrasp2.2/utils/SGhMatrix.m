%   SGhMatrix - Computes the Selection matrix
%
%   This function is used by SGselectionMatrix to build the H matrix    
%
%   Usage: [H] = SGhMatrix(cn, ct)
%
%   Arguments:
%    
%   cn = normals to contact points
%   
%   Ct = type of contact:
%       
%       1: hard finger (2D or 3D);
%       2: soft finger (2D or 3D);
%       3: complete constraint (2D or 3D);
%   
%
%    See also: SGselectionMatrix

%    Copyright (c) 2011 SIRSLab
%    Department of Information Engineering
%    University of Siena
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    SynGrasp is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SynGrasp is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SynGrasp. If not, see <http://www.gnu.org/licenses/>.


function [H] = SGhMatrix(cn, ct)

% function [H]=build_h(cn, ct)
% Builds the constraint matrix H for a configuration with
% contact types as specified in ct (contact type) and
% Related normals are passed in cn (nx3). 
% Contact types:
% 1: hard finger (2D or 3D);
% 2: soft finger (2D or 3D);
% 3: complete constraint (2D or 3D);

[nc, ndim]=size(cn);
lct=length(ct);
nhf=lct-length(find(ones(size(ct))*1-ct));
nsf=lct-length(find(ones(size(ct))*2-ct));
ncc=lct-length(find(ones(size(ct))*3-ct));
N = nhf+nsf+ncc;
if N ~= nc, disp('Wrong Data'); end

if ndim == 3
    H = zeros(3*N + 3*ncc + nsf, 6*N);
    ccol=1; crow=1;
    for i=1:N                   %Force selectors
        Hi=eye(3);
        [rh,ch]=size(Hi);
        H(crow:crow+rh-1, ccol:ccol+ch-1)=Hi;
        ccol=ccol+ch; crow=crow+rh;
    end
    for i=1:N                   %Moment Selectors
        if ct(i) == 1           %hard finger 3D
            Hi=zeros(1,3); 
        elseif ct(i) == 2		%soft finger 3D
            Hi=cn(i,:); 
        elseif ct(i) == 3		%complete constraint 3D
            Hi=eye(3);
        end 
        
        [rh,ch]=size(Hi);
        H(crow:crow+rh-1, ccol:ccol+ch-1)=Hi;
        ccol=ccol+ch; crow=crow+rh;
    end
elseif ndim == 2
    H = zeros(2*N + ncc , 3*N);
    ccol=1; crow=1;
    
    for i=1:N                   %Force selectors
        Hi=eye(2);
        [rh,ch]=size(Hi);
        H(crow:crow+rh-1, ccol:ccol+ch-1)=Hi;
        ccol=ccol+ch; crow=crow+rh;
    end

    for i=1:N                   %Moment Selectors

        Hi = floor(ct(i) / 3);
        
        [rh,ch]=size(Hi);
        H(crow:crow+rh-1, ccol:ccol+ch-1)=Hi;
        ccol=ccol+ch; crow=crow+rh;
    end
end

rh = size(H,1);
selector = zeros(rh,1);
for i=1:rh
    selector(i) = (sum(abs(H(i,:))) ~= 0); % 1 or 0
end

% for each non-zero (i.e. 1) value in selector, we have a row in nH ->
% pre-allocation
nH = zeros(sum(selector),size(H,2));
k = 1;
for i=1:rh
    if selector(i) == 1 % sum(abs(H(i,:))) ~= 0
        %nH = [nH; H(i,:)];
        nH(k,:) = H(i,:);
        k = k + 1;
    end
end

H=nH;
