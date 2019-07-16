function [minus_PGR] = SGBestPosCost(hand,obj, pos, rot ,  PGR_type)
% This function evaluates the minus PGR given a certain hand, object and its
% center coordinates
    if nargin ~= 5
        error('The number of inputs is 5!');
    end
    obj.center(1:3) = pos; % Updates the object center
    obj.Htr(1:3,4) =pos'; % Updates the object center in Htr matrix
    
    % Creates a new sphere
    obj = SGrebuildObject(obj, obj.center,rot);
    
    % Close the hand
    if isfield(hand, 'step_syn') && isfield(hand, 'n_syn')
        [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj,hand.step_syn, hand.n_syn);
    else
       [hand, obj] = SGcloseHandWithSynergiesV2(hand,obj);
    end
    
    switch obj.type
        case 'sph'
            if obj.radius - 5 > obj.center(3)
                minus_PGR = 0;
                return;
            end
        case 'cube'
            % Face 5 is the opposite of 6 (no common vertices)
            % If some z coordinate of any vertex is bigger than -5, it is
            % considered that the cube is "inside" of the palm
            for i = 5:6
                if sum(gt(-5,obj.faces.ver{1,i}(3,:))) > 0
                     minus_PGR = 0;
                     return;
                end
            end
            
        case 'cyl'
            % TODO
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

