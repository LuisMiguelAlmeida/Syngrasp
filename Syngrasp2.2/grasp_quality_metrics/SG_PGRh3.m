%   SG_PGRh2 - evaluates the PGR and PCR quality measures for a
%   given grasp using the heuristic 2 reported in the paper
%   "On Grasp Quality Measures: Grasp Robustness and Contact Force 
%   Distribution in Underactuated and Compliant Robotic Hands."
%
%    Usage: [PGR PCR combopt]=SG_PGRh2(hand0,object0,kg)
%
%    Arguments:
%    hand0 = the hand structure in the initial grasp configuration
%    object0 = the object structure in the inital grasp configuration
%    kg = number of contacts that must be considered attached
%
%    Returns:
%    PGR = The PGR quality index
%    PCR = The PCR quality index
%    combopt = matrix with the optimal combinations for each number of
%    engaged synergies
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

function [PGR, PCR, combopt] = SG_PGRh3(hand0,object0,kg)

    nc0 = size(hand0.cp,2); % initial number of contact points

    % If the number of contact points are less than the number that must be
    % considered to be attached, then PCR,PGR will be zero
    if nc0 < kg
        PCR = 0;
        PGR = 0;
        combopt = [];
        disp('ALERT!! The number of contact points are less than the number of contact points that must be attached\n');
        return;
    end

    % kg = 2; % number of contacts that must be considered attached
    contacts = 1:1:nc0;
    Cnk_St1 = nchoosek(contacts,kg);
    n_Cnk = size(Cnk_St1,1); % Number of Cnk combinations
    
    Comb_St2_3 = permn([2 3], nc0-kg); % Combination of the rest of "detached points" 
    n_St23 = size(Comb_St2_3,1); % Number of combinations in state 2 and 3
    
    auxComb = 3*ones(n_Cnk, nc0); % Pre-allocate memory
  
    for j = 1 : n_Cnk % loop on the combinations Cnk of contact points
        for l = 1 : kg
            auxComb(j,Cnk_St1(j,l)) = 1;
        end
    end
    
    Comb = 3*ones(n_Cnk*n_St23, nc0);
    
    row = 1;
    for i = 1: n_Cnk
        Comb(row:row + n_St23-1, :) = ones(n_St23, nc0).*auxComb(i,:);
        h=1;
        for j= 1:nc0
            if auxComb(i,j) ~= 1 % state 1
                Comb(row:row + n_St23-1, j) = Comb_St2_3(:,h);
                h=h+1;
            end
        end
        row = row + n_St23; % Update row number
    end
        
    
    % Give to the Brute force function the selected combinations
    [PGR, PCR, combopt] = SG_PGRbruteforce(hand0,object0,Comb);
end