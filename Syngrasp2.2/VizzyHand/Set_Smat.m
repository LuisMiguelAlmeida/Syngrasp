function [S, So] = Set_Smat(angles, mode)
%UNTITLED Summary of this function goes here
%   Set the Synergy matrix given some variables pre-computed
    load('VizzySynergies.mat');
    % q = [q_thumb q_index q_middle]' each finger has 3 joints
    S = zeros(12, 3); % 12 joints x 3 synergies
    So = zeros(12, 1); % JointAngles = S*synergies + So (origin intercept syn)
    switch mode
        %%%%%% JOINTS %%%%%%%
        case 'joints'
            % First joint of thumb
            for i = 1:length(Sthumb1)
                for j = 1:length(Sthumb1{i}.ymin)
                    if(Sthumb1{i}.ymin(j) < angles(1) && Sthumb1{i}.ymax(j) > angles(1) )
                        S(1,1) = Sthumb1{i}.slope(j);
                        So(1,1) = Sthumb1{i}.b(j);
                        break;
                    end
                end
            
            end
            % Second and third joint of thumb
            for i = 1:length(Sthumb2)
                for j = 1:length(Sthumb2{i}.ymin)
                    if(Sthumb2{i}.ymin(j) < angles(1+i) && Sthumb2{i}.ymax(j) > angles(1+i) )
                        S(1+i,1) = Sthumb2{i}.slope(j);
                        So(1+i,1) = Sthumb2{i}.b(j);
                        break;
                    end
                end
            end
            % 1st, 2nd, 3rd joint of index finger
            for i = 1:length(Sindex)
                for j = 1:length(Sindex{i}.ymin)
                    if(Sindex{i}.ymin(j) < angles(3+i) && Sindex{i}.ymax(j) > angles(3+i) )
                        S(3+i,2) = Sindex{i}.slope(j);
                        So(3+i,1) = Sindex{i}.b(j);
                        break;
                    end
                end
            end
            % 1st, 2nd, 3rd joint of middle finger (same angles for ring
            % finger)
            for i = 1:length(Smiddle)
                for j = 1:length(Smiddle{i}.ymin)
                    if(Smiddle{i}.ymin(j) < angles(6+i) && Smiddle{i}.ymax(j) > angles(6+i) )
                        S(6+i,3) = Smiddle{i}.slope(j); % Middle finger
                        So(6+i,1) = Smiddle{i}.b(j);
                        S(9+i,3) = Smiddle{i}.slope(j); % Pinky finger
                        So(9+i,1) = Smiddle{i}.b(j);
                        break;
                    end
                end
            end
            
        %%%%%% ACTUATOR %%%%%%    
        case 'actuator'
            % First joint of thumb
            for i = 1:length(Sthumb1)
                for j = 1:length(Sthumb1{i}.xmin)
                    if(Sthumb1{i}.xmin(j) < angles(1) && Sthumb1{i}.xmax(j) > angles(1) )
                        S(1,1) = Sthumb1{i}.slope(j);
                        So(1,1) = Sthumb1{i}.b(j);
                        break;
                    end
                end
            
            end
            % Second and third joint of thumb
            for i = 1:length(Sthumb2)
                for j = 1:length(Sthumb2{i}.xmin)
                    if(Sthumb2{i}.xmin(j) < angles(1) && Sthumb2{i}.xmax(j) > angles(1) )
                        S(1+i,1) = Sthumb2{i}.slope(j);
                        So(1+i,1) = Sthumb2{i}.b(j);
                        break;
                    end
                end
            end
            % 1st, 2nd, 3rd joint of index finger
            for i = 1:length(Sindex)
                for j = 1:length(Sindex{i}.xmin)
                    if(Sindex{i}.xmin(j) < angles(2) && Sindex{i}.xmax(j) > angles(2) )
                        S(3+i,2) = Sindex{i}.slope(j);
                        So(3+i,1) = Sindex{i}.b(j);
                        break;
                    end
                end
            end
            % 1st, 2nd, 3rd joint of middle finger (same angles for ring
            % finger)
            for i = 1:length(Smiddle)
                for j = 1:length(Smiddle{i}.xmin)
                    if(Smiddle{i}.xmin(j) < angles(3) && Smiddle{i}.xmax(j) > angles(3) )
                        S(6+i,3) = Smiddle{i}.slope(j); % Middle finger
                        So(6+i,1) = Smiddle{i}.b(j); 
                        S(9+i,3) = Smiddle{i}.slope(j); % Pinky finger
                        So(9+i,1) = Smiddle{i}.b(j);
                        break;
                    end
                end
            end
            
    end
    
    % Add the fixed wrist joint
    S= [zeros(1,3); S];
    So = [0 ; So];
end

