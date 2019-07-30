%    SCRIPT THAT COMPUTES THE PCR AND PGR FOR A GIVEN GRASP by calling the
%    functions BruteForcePGR, Heuristic1PGR_paper, Heuristic2PGR_paper.
%    The number of contact points can be decided by the user.
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

close all;
clear all;
clc;


%num_cp = ["3";"4";"5";"6";"8";"9";"10";"12";"15"];
num_cp = ["9";"10";"12"];
PGR_BF(1:length(num_cp)) = struct('Quality', 0, 'Time',0, 'Comb',0); % PGR structure
PGR_H1(1:length(num_cp)) = struct('Quality', 0, 'Time',0, 'Comb',0); % PGR structure
PGR_H2(1:length(num_cp)) = struct('Quality', 0, 'Time',0, 'Comb',0); % PGR structure
PGR_H3(1:length(num_cp)) = struct('Quality', 0, 'Time',0, 'Comb',0); % PGR structure
PGR_H4(1:length(num_cp)) = struct('Quality', 0, 'Time',0, 'Comb',0); % PGR structure

for i = 1: length(num_cp)
    type = num_cp(i);
    disp(type)
    
    %%% DEFINITION OF THE HAND
    hand0=SGparadigmatic;

    % 1. Vector a of the positions of the contacts on the links:
     a=0.5*ones(1,15);

    % Define hand's configuration 
    [qm, Syn] = SGsantelloSynergies; % Load Santello's synergies
    hand0 = SGdefineSynergies(hand0,Syn(:,1:3),qm);
    hand0 = SGmoveHand(hand0,qm);
    
    
    switch type
        case '3'
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
        case '4'
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
        case '5'
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
          hand0 = SGaddContact(hand0,1,5,4,a(15));
        case '6'
        % Define the contact points on the distal phalanges
          hand0 = SGaddContact(hand0,1 ,1,3,a(6)); 
          hand0 = SGaddContact(hand0,1,2,3,a(7)); 
          hand0 = SGaddContact(hand0,1,3,3,a(8));
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13));
        case '8'
          a=[0 0 0 0 0 0.5 0.5 0.5 0.5 0.5 0.7 0.7 0.7 0.7 0.7];
        % Define the contact points on the proximal phalanges
          hand0 = SGaddContact(hand0,1,1,2,a(1)); 
          hand0 = SGaddContact(hand0,1,2,2,a(2)); 
          hand0 = SGaddContact(hand0,1,3,2,a(3)); 
          hand0 = SGaddContact(hand0,1,4,2,a(4));
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
        case '9'
        % Define the contact points on the proximal phalanges
          hand0 = SGaddContact(hand0,1,1,2,a(1)); 
          hand0 = SGaddContact(hand0,1,2,2,a(2)); 
          hand0 = SGaddContact(hand0,1,3,2,a(3)); 
        % Define the contact points on the distal phalanges
          hand0 = SGaddContact(hand0,1,1,3,a(6)); 
          hand0 = SGaddContact(hand0,1,2,3,a(7)); 
          hand0 = SGaddContact(hand0,1,3,3,a(8)); 
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13));       
        case '10'
          a=[0 0 0 0 0 0.5 0.5 0.5 0.5 0.5 0.7 0.7 0.7 0.7 0.7];
        % Define the contact points on the proximal phalanges
          hand0 = SGaddContact(hand0,1,1,2,a(1)); 
          hand0 = SGaddContact(hand0,1,2,2,a(2)); 
          hand0 = SGaddContact(hand0,1,3,2,a(3)); 
          hand0 = SGaddContact(hand0,1,4,2,a(4));
          hand0 = SGaddContact(hand0,1,5,2,a(5));
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
          hand0 = SGaddContact(hand0,1,5,4,a(15));
      case '12'
        % Define the contact points on the proximal phalanges
          hand0 = SGaddContact(hand0,1,1,2,a(1)); 
          hand0 = SGaddContact(hand0,1,2,2,a(2)); 
          hand0 = SGaddContact(hand0,1,3,2,a(3)); 
          hand0 = SGaddContact(hand0,1,4,2,a(4));
        % Define the contact points on the distal phalanges
          hand0 = SGaddContact(hand0,1,1,3,a(6)); 
          hand0 = SGaddContact(hand0,1,2,3,a(7)); 
          hand0 = SGaddContact(hand0,1,3,3,a(8)); 
          hand0 = SGaddContact(hand0,1,4,3,a(9));
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
        case '15'
        % Define the contact points on the proximal phalanges
          hand0 = SGaddContact(hand0,1,1,2,a(1)); 
          hand0 = SGaddContact(hand0,1,2,2,a(2)); 
          hand0 = SGaddContact(hand0,1,3,2,a(3)); 
          hand0 = SGaddContact(hand0,1,4,2,a(4));
          hand0 = SGaddContact(hand0,1,5,2,a(5));
        % Define the contact points on the distal phalanges
          hand0 = SGaddContact(hand0,1,1,3,a(6)); 
          hand0 = SGaddContact(hand0,1,2,3,a(7)); 
          hand0 = SGaddContact(hand0,1,3,3,a(8)); 
          hand0 = SGaddContact(hand0,1,4,3,a(9));
          hand0 = SGaddContact(hand0,1,5,3,a(10));
        % Define the contact points on the fingertips
          hand0 = SGaddContact(hand0,1,1,4,a(11)); 
          hand0 = SGaddContact(hand0,1,2,4,a(12)); 
          hand0 = SGaddContact(hand0,1,3,4,a(13)); 
          hand0 = SGaddContact(hand0,1,4,4,a(14));
          hand0 = SGaddContact(hand0,1,5,4,a(15));
        otherwise
            error('wrong number of contact points');
    end

    [hand0, obj0] = SGmakeObject(hand0);
    size(hand0.cp,2)
    size(obj0.cp,2)
% SGplotHand(hand0);hold on;
% SGplotObject(obj0);

%     tic;
%     [Quality, ~, combopt]=SG_PGRbruteforce(hand0,obj0);
%     Time = toc;
%     PGR_BF(i).Quality = Quality;
%     PGR_BF(i).Time = Time;  
%     PGR_BF(i).Comb = combopt;
%     
%     tic;
%     [Quality, ~, combopt]=SG_PGRh1(hand0,obj0);
%     Time = toc;
%     PGR_H1(i).Quality = Quality;
%     PGR_H1(i).Time = Time;  
%     PGR_H1(i).Comb = combopt;
    
    tic;
    kg=3;
    [Quality, ~, combopt]=SG_PGRh2(hand0,obj0,kg);
    Time = toc;
    PGR_H2(i).Quality = Quality;
    PGR_H2(i).Time = Time;  
    PGR_H2(i).Comb = combopt;
    
%     tic;
%     [Quality, ~, combopt]=SG_PGRh3(hand0,obj0,kg);
%     Time = toc;
%     PGR_H3(i).Quality = Quality;
%     PGR_H3(i).Time = Time;  
%     PGR_H3(i).Comb = combopt;
%     
%     tic;
%     [Quality, ~, combopt]=SG_PGRh4(hand0,obj0);
%     Time = toc;
%     PGR_H4(i).Quality = Quality;
%     PGR_H4(i).Time = Time;  
%     PGR_H4(i).Comb = combopt;
    
end

%% Plots

% Quality comparison
plot([PGR_BF.Quality],'s','MarkerSize', 10); hold on;
plot([PGR_H1.Quality],'+','MarkerSize', 10); hold on;
plot([PGR_H2.Quality],'x','MarkerSize', 10); hold on;
plot([PGR_H3.Quality],'o','MarkerSize', 10); hold on;
plot([PGR_H4.Quality],'d','MarkerSize', 10); hold on;
xlabel('Grasps number');
ylabel('PGR Quality');
legend('BF','H1','H2','H3', 'H4');
title('Quality comparison between Heuristics');

% Time comparison
figure();
semilogy([PGR_BF.Time],'s', 'MarkerSize', 10); hold on;
semilogy([PGR_H1.Time],'+', 'MarkerSize', 10); hold on;
semilogy([PGR_H2.Time],'x', 'MarkerSize', 10); hold on;
semilogy([PGR_H3.Time],'o', 'MarkerSize', 10); hold on;
semilogy([PGR_H4.Time],'d', 'MarkerSize', 10); hold on;
xlabel('Grasps number');
ylabel('PGR Time (s)');
legend('BF','H1','H2','H3', 'H4');
title('Time comparison between Heuristics');


