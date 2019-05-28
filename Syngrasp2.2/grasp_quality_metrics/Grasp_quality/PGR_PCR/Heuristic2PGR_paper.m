function [PGR, PCR, combopt]=Heuristic2PGR_paper(hand0,a,kg)
%    
%   Heuristic2PGR_paper - evaluates the PGR and PCR quality measures for a
%   given grasp using the heuristic 2 reported in the paper
%   "On Grasp Quality Measures: Grasp Robustness and Contact Force 
%   Distribution in Underactuated and Compliant Robotic Hands."
%
%    Usage: [PGR PCR combopt]=Heuristic2PGR_paper(hand0, a)
%
%    Arguments:
%    hand0 = the hand structure in the initial grasp configuration
%    a = vector that define the positions of the contact points on each
%    link of hand0 
%    kg = number of contacts that must be considered attached
%
%    Returns:
%    PGR = The PGR quality index
%    PCR = The PCR quality index
%    combopt = matrix with the optimal combinations for each number of
%    engaged synergies
%
%    References:
%    
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

% Definition of the hand 
[qm, Syn] = SGsantelloSynergies; % Load Santello's synergies
hand0 = SGdefineSynergies(hand0,Syn,qm);
hand0 = SGmoveHand(hand0,qm); 

nc0=size(hand0.cp,2); % initial number of contact points

[hand0, object0]=SGmakeObject(hand0);

%Comb=permn([1 3],nc0);
% kg=2; % number of contacts that must be considered attached
contacts = 1:1:nc0;
Cnk = nchoosek(contacts,kg);

vector=3*ones(1,nc0);
for j=1:size(Cnk,1) %% loop on the combinations Cnk of contact points
    vector=3*ones(1,nc0);
    for l=1:size(Cnk,2)
        vector(Cnk(j,l))=1;
    end
    Comb(j,:)=vector;
end
     
% Give to the Brute force function the selected combinations
[PGR, PCR, combopt]=BruteForcePGR(hand0, a, Comb);
end
