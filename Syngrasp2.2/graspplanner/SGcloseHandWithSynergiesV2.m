%   SGcloseHandWithSynergiesV2 - Closes each finger until one of its link
%   reaches the object, then one contact point is added.
%
%   The closing procedure is logarithmic, meaning that in each iteration the
%   synergies are equal to the previous plus an increment only if in the next
%   iteration doesn't touch the object.
%   If it does, the step goes to its half.
%   In the end the hand and object are updated.
%
%    Usage: [newHand,object] = SGcloseHandWithSynergies(hand,obj,synergies,n_syn)
%    Arguments:
%    hand = the hand structure in the initial grasp configuration
%    obj = the object structure in the initial grasp configuration
%    synergies = one vector that contains the synergies increment (how much
%    the fingers are closed.
%    n_syn = number of synergies
%
%    Returns:
%    newHand = hand structure updated ( which means that the hand's
%    configuration is closed)
%    object = object structure updated ( Matrices updated and cp added)

function [newHand,object] = SGcloseHandWithSynergiesV2(hand,obj,synergies,n_syn)

if nargin == 3
    n_syn = size(hand.S, 2);
end

if nargin == 2 % It starts with a set of 45º
    synergies = 90*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
    n_syn = size(hand.S, 2);
end

% synergies - vetor that has the increments for each finger
final_pose = 0;

hand.syn = zeros(n_syn,1); % Define all synergies to zero
activeSynergies = ones(n_syn,1); % All synergy fingers are ative
[hand.S, hand.So] = Set_Smat(hand.syn, 'actuator'); % Define synergy matrix


if (isscalar(synergies))
        step =(ones(n_syn,1)*synergies);
else
        step = (synergies);
end
    
stop_anlge =  0.0175/2;

count = 0;
max_iter = 1000;
while (final_pose == 0 && count <= max_iter)
    for i=1:length(hand.syn) % for each synergy
        
        if(activeSynergies(i) == 1)
            new_syn = hand.syn; % Auxilary syn vector
            new_syn(i) = hand.syn(i) + step(i); % Increases each synergy
            
            if new_syn(i) > 3.14 && step(i) < stop_anlge % reach the synergy limit ( finger doesn't touch the obj)
                activeSynergies(i) = 0;
                continue;
            elseif new_syn(i) > 3.14 && step(i) >= stop_anlge
                step(i) = 0.0175;
                continue;
            end
            
            if i == 1 && new_syn(i) > 1.5 && step(i) > 0.0873
                step(i) = 0.0873; % 5 º Slows down the finger movement
            end
            
            [new_S, new_So] = Set_Smat(new_syn, 'actuator'); % Updates Synergy matrix
            
            q_new = new_S*new_syn + new_So;
            
            new_hand = hand;
            % Moves hand to new position
            new_hand = SGmoveHand(new_hand, q_new);            
            
            % contact detection
            [cp_mat] = SGcontactDetection(new_hand,obj,i);
            
            if ~isempty(cp_mat) && step(i) > stop_anlge % 0.0175 rad = 1º
                step(i) = step(i)/2; 
                continue;                
            elseif (~isempty(cp_mat) && step(i) <= stop_anlge) 
                activeSynergies(i) = 0;
                disp('synergy desactivated');
                disp(i);
                for c=1:size(cp_mat,1)
                    new_hand = SGaddContact(new_hand,1,i,cp_mat(c,1),cp_mat(c,2));
                end
            end
            
            if(i == 3) % Vizzy finger case
                i=i+1; % pass to ring finger
                % contact detection
                [cp_mat] = SGcontactDetection(hand,obj,i);
                
                if ~isempty(cp_mat) && step(i-1) > stop_anlge % 0.0175 rad = 1º
                    step(i-1) = step(i-1)/2; 
                    continue;                
                elseif ~isempty(cp_mat) && step(i-1) <= stop_anlge   
                    activeSynergies(i-1) = 0;
                    disp('synergy desactivated');
                    disp(i);
                    for c=1:size(cp_mat,1)
                        new_hand = SGaddContact(new_hand,1,i,cp_mat(c,1),cp_mat(c,2));
                    end
                end
            end
            
            % No contact detected, assigning auxilary variables to the principal ones
            hand = new_hand; 
            hand.S = new_S;
            hand.So = new_So;
            hand.syn = new_syn;
          
        end
        
    end
    
    if (activeSynergies == zeros(n_syn,1))
        final_pose = 1;
    end
    
    count = count +1;
    
end

% determine if object is in contact with hand's palm
% (this is done by seing if there is some contact in the metacarpal bone)
alpha = NaN;
wrs_org = zeros(3, 1); % Wrist origin

for i=1:4 % for each finger
    link_seg = SGsegment(wrs_org, hand.F{i}.base(1:3,4));    
    [alpha] = SGlinkIntersection(link_seg,obj);
    if ~isnan(alpha)    
       hand = SGaddPalmContact(hand,1,i,alpha);
    end
    
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

