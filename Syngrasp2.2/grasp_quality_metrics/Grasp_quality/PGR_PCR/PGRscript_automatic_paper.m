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

quality_vector=[];

%%% DEFINITION OF THE HAND
hand0=SGparadigmatic;

% 1. Vector a of the positions of the contacts on the links:
 a=0.5*ones(1,15);

% Define hand's configuration 


% 2. Select the number of contact points
disp('Select the number of contact points')
type = input('(3,4,5,6,8,9,10,12,15):  ','s');

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

[qm, Syn] = SGsantelloSynergies; % Load Santello's synergies
hand0 = SGdefineSynergies(hand0,Syn(:,1:3),qm);
hand0 = SGmoveHand(hand0,qm);

[hand0, obj0] = SGmakeObject(hand0);
SGplotHand(hand0);hold on;
SGplotObject(obj0);

disp('Select the desired type of computation')
type = input('(BF, H1, H2, H3, H4):  ','s');
tic
switch type
    case 'BF'   
        [PGR, PCR, combopt]=SG_PGRbruteforce(hand0,obj0);
        
    case 'H1'
        disp('heuristic1');
        [PGR, PCR, combopt]=SG_PGRh1(hand0,obj0);
        
    case 'H2'
        disp('heuristic2');
        kg=3;
        [PGR, PCR, combopt]=SG_PGRh2(hand0,obj0,kg);
    case 'H3'
        disp('heuristic3');
        kg=3;
        [PGR, PCR, combopt]=SG_PGRh3(hand0,obj0,kg);
    case 'H4'
        disp('heuristic4');
        [PGR, PCR, combopt]=SG_PGRh4(hand0,obj0);
    otherwise
        error('wrong type of computation');
end

% STORE SIMULATION TIME:
sim_time=toc;



%% PLOTS
% PGR vs PCR log
figure
semilogy([1:15], PCR,'--',[1:15],PGR, 'LineWidth',3)
grid on
legend('PCR','PGR')
xlabel('NUMBER OF SYNERGIES','FontSize',14)
ylabel('PCR, PGR','FontSize',14);

% PGR vs PCR 
figure
plot([1:15], PCR,[1:15],PGR ,'LineWidth',3)
grid on
legend('PCR','PGR')
xlabel('NUMBER OF SYNERGIES','FontSize',14)
ylabel('PCR, PGR','FontSize',14);

