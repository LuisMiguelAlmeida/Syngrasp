function [newHand,object] = SGcloseHand(hand,obj,activeJoints,increment)

final_pose = 0;


if (isscalar(increment))
        step = increment * ones(length(hand.q),1);
else
        step = increment;
end
    


count = 0;
max_iter = 1000;
while (final_pose == 0 && count <= max_iter)
    for i=1:hand.n % for each finger
        index = find(hand.qin == i);
        for j = 1:length(index) % for each joint
            k = index(j);
            if(activeJoints(k) == 1)
                q_new = hand.q;
                q_new(k) = q_new(k) + step(k);
                if(q_new(k) >= hand.limit(k,1) && q_new(k) <= hand.limit(k,2))
                    hand = SGmoveHand(hand,q_new);
                    % contact detection
                    [cp_mat] = SGcontactDetection(hand,obj,i);
                    if ~isempty(cp_mat)
                        max_link = max(cp_mat(:,1));
                        for h = 1:max_link
                            activeJoints(index(h)) = 0;
                        end
                        for c=1:size(cp_mat,1)
                            hand = SGaddContact(hand,1,i,cp_mat(c,1),cp_mat(c,2));
                        end
                    end
                else
                    activeJoints(k) = 0;
                end
            end
        end
    end
    
    if (activeJoints == zeros(length(hand.q),1))
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