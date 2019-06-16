function [minus_PGR] = SGBestPosCost(hand,obj, center_obj, PGR_type)
% This function evaluates the PGR given a certain hand, object and its
% center coordinates
    if nargin ~= 4
        error('The number of inputs is 4!');
    end
    obj.center(1:3) = center_obj; % Updates the object center
    obj.Htr(1:3,4) = center_obj'; % Updates the object center in Htr matrix
    % Creates a new sphere
    obj = SGsphere(obj.Htr,obj.radius,obj.res);
    % Close the hand
    [hand, obj] = SGcloseHandWithSynergies(hand,obj,hand.step_syn, hand.n_syn);
    
    if obj.radius - 5 > obj.center(3)
        minus_PGR = 0;
        return;
    end
    
    switch PGR_type
        case 'BruteForce'
            [PGR, ~, ~] = SG_PGRbruteforce(hand, obj);
        case 'H1'
            [PGR, ~, ~]=SG_PGRh1(hand,obj); % PGR with Heuristic 1
        case 'H2'
            [PGR, ~, ~]=SG_PGRh2(hand,obj,3); % PGR with Heuristic 2
        otherwise
            error('PGR type should be one of this: BruteForce, H1, H2')
    end
    
    minus_PGR = - PGR; % This minus is because the function minimizes the cost
                       % and we want the maximum
end

