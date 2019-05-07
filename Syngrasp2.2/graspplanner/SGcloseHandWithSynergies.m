function [newHand,object] = SGcloseHandWithSynergies(hand,obj,synergies,n_syn)
% synergies - vetor that has the increments for each finger
final_pose = 0;

hand.syn = zeros(n_syn,1); % Define all synergies to zero
activeSynergies = ones(n_syn,1); % All synergy fingers are ative
[hand.S hand.So] = Set_Smat(hand.syn, 'actuator'); % Define synergy matrix


if (isscalar(synergies))
        step =(ones(n_syn,1)*synergies);
else
        step = (synergies);
end
    


count = 0;
max_iter = 1000;
while (final_pose == 0 && count <= max_iter)
    for i=1:length(hand.syn) % for each synergy
        
        if(activeSynergies(i) == 1)
            hand.syn(i) = hand.syn(i) + step(i); % Increases each synergy
            q_new = hand.S*hand.syn +hand.So;
%             q_diff = abs(hand.q - q_new);
%             for k = 1:(length(q_diff))
%                 if(q_diff(k) > 0.001)
%                     if(q_new(k) < -0.2 || q_new(k) > pi)
%                         activeSynergies(i) = 0;
%                         disp('synergy desactivated');
%                         disp(i);
%                         break;
%                     end
%                 end
%             end
            % Moves hand to new position
            hand = SGmoveHand(hand,q_new);            
            [hand.S, hand.So] = Set_Smat(hand.syn, 'actuator'); % Updates Synergy matrix
            % contact detection
            [cp_mat] = SGcontactDetection(hand,obj,i);
            if ~isempty(cp_mat)            
                activeSynergies(i) = 0;
                disp('synergy desactivated');
                disp(i);
                for c=1:size(cp_mat,1)
                    hand = SGaddContact(hand,1,i,cp_mat(c,1),cp_mat(c,2));
                end
            end
            if(i == 3) % Vizzy finger case
                i=i+1; % pass to ring finger
                % contact detection
                [cp_mat] = SGcontactDetection(hand,obj,i);
                if ~isempty(cp_mat)
                        activeSynergies(i-1) = 0;
                    for c=1:size(cp_mat,1)
                        hand = SGaddContact(hand,1,i,cp_mat(c,1),cp_mat(c,2));
                    end
                end
            end
            
        end
        
    end
    
    if (activeSynergies == zeros(n_syn,1))
        final_pose = 1;
    end
    
    count = count +1;
    
end

if size(hand.cp,2)>0
    [hand,object] = SGcontact(hand,obj);
else 
    object = obj;
    object.base = [eye(3) object.center; zeros(1,3) 1];
    object.Kc = [];
    object.H = [];
    object.Gtilde = [];
    object.G = [];
end
newHand = hand;
end

