%   SG_PGRh4 - evalates the PGR and PCR quality measures for a
%   given grasp using the heuristic 3
%
%    Usage: [PGR PCR combopt]=SG_PGRh4(hand0,object0)
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

function [PGR, PCR, combopt] = SG_PGRh4(hand0,object0)
    
    nc0 = size(hand0.cp,2); % initial number of contact points

    % If the number of contact points is smaller than 4 then brute force is
    % used
    if nc0 < 4
        [PGR, PCR, combopt] = SG_PGRbruteforce(hand0,object0);
        return;
    end 
    
    

    kg = 2; % number of contacts that must be considered attached
    contacts = 1:1:nc0;
    Cnk_St1 = nchoosek(contacts,kg);
    
    % Number of Cnk combinations in State 1
    n_Cnk_St1 = size(Cnk_St1,1);
    
    % Number of Cnk combinations in State 2
    n_Cnk_St2 = (nchoosek(nc0-kg,2)+nchoosek(nc0-kg,3)); 
    
    % Number of total possible combinations
    n_Cnk = n_Cnk_St1*n_Cnk_St2; 
    
    Comb = 3*ones(n_Cnk, nc0); % Pre-allocate memory  
    
    row = 1;
    for i = 1: n_Cnk_St1
        Comb(row:row + n_Cnk_St2-1, Cnk_St1(i,:)) = 1; 
        
        ContactsLeft = setdiff(contacts, Cnk_St1(i,:));
        
        ContactsLeftSt2_2 = nchoosek(ContactsLeft,2);
        for j = 1: nchoosek(nc0-kg,2)
          Comb(row,ContactsLeftSt2_2(j,:)) = 2;
          row = row + 1;
        end
        
        ContactsLeftSt2_3 = nchoosek(ContactsLeft,3);
        for j = 1: nchoosek(nc0-kg,3)
          Comb(row,ContactsLeftSt2_3(j,:)) = 2;
          row = row + 1;
        end
    
    end
        
    
    % Give to the Brute force function the selected combinations
    [PGR, PCR, combopt] = SG_PGRbruteforce(hand0,object0,Comb);
end