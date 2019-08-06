% Defines the actuation matrix for a determinated hand
% You can define how the actuation matrix should be contructed
function A = DefineActuationMatrix(hand)
    
    switch hand.type
        
        case 'VizzyHand'
            na = 3; % Number of actuators
            n_cp = size(hand.cp,2); % Number of contact points
            A_list = py.list();
            
            for i = 1: n_cp
                
                % If the cp is on the palm
                if hand.cp(5,i) == 0
                    A_line = ones(1, na);
                else
                    % else it is on the finger
                    % The thumb and index finger (finger_id = 1 and 2) have
                    % two actuators (one for each finger)
                    % The middle and ring_pinky finger have a common
                    % actuator
                    A_line = zeros(1, na);
                    finger_id = hand.cp(4,i);
                    if finger_id ~= 4
                        A_line(finger_id)=1;
                    else
                        A_line(3)=1; 
                    end
                end
                
                A_cell = arrayfun(@(x) py.numpy.int64(x), A_line , 'UniformOutput', false);
                A_list.append(py.list(A_cell));
            end
            
        otherwise
            error('Actuation matrix not defined for: %s', hand.type);
    end
    
    % Transform A matrix in Python ndarray
    A_list = int64(eye(n_cp));
    A = py.numpy.array(A_list);
end

