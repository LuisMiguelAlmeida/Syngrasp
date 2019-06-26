%   SGcloseHandWithSynergies - Closes each finger until one of its link
%   reaches the object, then one contact point is added.
%
%   The closing procedure is linear, meaning that in each iteration the
%   synergies are equal to the previous plus an increment.
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

function [newHand,object] = SGcloseHandWithSynergies(hand,obj,synergies,n_syn)

if nargin == 3
    n_syn = 3; %size(hand.S, 2); % For VizzyHand
end

if nargin == 2 % It starts with a set of 45º
    synergies = 10*0.0087*[1 1 1]; % 0.5 º = 0.0087 rad
    n_syn = 3; %size(hand.S, 2); % For VizzyHand
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
    


count = 0;
max_iter = 1000;
while (final_pose == 0 && count <= max_iter)
    for i=1:length(hand.syn) % for each synergy
        
        if(activeSynergies(i) == 1)
            hand.syn(i) = hand.syn(i) + step(i); % Increases each synergy
            if hand.syn(i) > 3.14
                 activeSynergies(i) = 0;
                 continue;
            end
            [hand.S, hand.So] = Set_Smat(hand.syn, 'actuator'); % Updates Synergy matrix
            q_new = hand.S*hand.syn +hand.So;

            % Moves hand to new position
            hand = SGmoveHand(hand,q_new);            
            
            % contact detection
            [cp_mat] = SGcontactDetection(hand,obj,i);
            if ~isempty(cp_mat)            
                activeSynergies(i) = 0;
                [cp_mat] = SGcontactDetection(hand,obj,i);
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

% determine if object is in contact with hand's palm
% (this is done by seing if there is some contact in the metacarpal bone)
alpha = NaN;
wrs_org = zeros(3, 1); % Wrist origin

for i=1:4 % for each finger
    link_seg = SGsegment(wrs_org, hand.F{i}.base(1:3,4));    
    [alpha] = SGlinkIntersection(link_seg,obj);
    if ~isnan(alpha)    
       hand = SGaddPalmContact(hand,1,i,alpha);
       disp('Palm contact added')
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

