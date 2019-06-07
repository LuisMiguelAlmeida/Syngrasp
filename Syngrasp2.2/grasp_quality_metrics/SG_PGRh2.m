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

function [PGR, PCR, combopt] = SG_PGRh2(hand0,object0,kg)

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
    Cnk = nchoosek(contacts,kg);

    n_Cnk = size(Cnk,1); % Number of Cnk combinations
    Comb = 3*ones(n_Cnk, nc0); % Pre-allocate memory
  
    for j = 1 : n_Cnk % loop on the combinations Cnk of contact points
        for l = 1 : kg
            Comb(j,Cnk(j,l)) = 1;
        end
    end

    % Give to the Brute force function the selected combinations
    [PGR, PCR, combopt] = SG_PGRbruteforce(hand0,object0,Comb);
end