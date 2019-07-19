% Script to evaluate if the PGR_H3 has the same trend that PGR_bruteforce
grasps = dir('Grasps/*.mat');

n_grasps = length(grasps); % Number of grasps
PGR_BF(1:n_grasps)=struct('quality', 0,'comb',0,'time',0);
PGR_H2(1:n_grasps)=struct('quality', 0,'comb',0,'time',0);
PGR_H3(1:n_grasps)=struct('quality', 0,'comb',0,'time',0);

kg = 3;
for i = 1:n_grasps
    waitbar(i/n_grasps)
    load(grasps(i).name);
    tic
    [Quality, ~, combopt] = SG_PGRbruteforce(hand, obj);
    time = toc;
    PGR_BF(i).quality = Quality;
    PGR_BF(i).comb = combopt;
    PGR_BF(i).time = time;
    
    tic
    [Quality, ~, combopt]=SG_PGRh2(hand,obj,kg);
    time = toc;
    PGR_H2(i).quality = Quality;
    PGR_H2(i).comb = combopt;
    PGR_H2(i).time = time;
    
    tic
    [Quality, PCR, combopt]=SG_PGRh3(hand,obj,kg);
    time = toc;
    PGR_H3(i).quality = Quality;
    PGR_H3(i).comb = combopt;
    PGR_H3(i).time = time;
end

save ws_H3_tests.mat

%%
load('ws_H3_tests.mat')
%% Heuristics comparation
plot(1:n_grasps, [PGR_BF.quality]); hold on;
plot(1:n_grasps, [PGR_H2.quality]); hold on;
plot(1:n_grasps, [PGR_H3.quality]);
xlabel('Grasp Number')
ylabel('PGR')
legend('BF', 'H2', 'H3');

figure();

%% Error between PGR Brute force and Heuristic 3

plot(abs([PGR_BF.quality]-[PGR_H3.quality]));
xlabel('Grasp Number')
ylabel('Error between PGR BF and PGR H3')

%% Time comparison
plot(1:n_grasps, [PGR_BF.time]); hold on;
plot(1:n_grasps, [PGR_H2.time]); hold on;
plot(1:n_grasps, [PGR_H3.time]);
xlabel('Grasp Number')
ylabel('Time')
legend('BF', 'H2', 'H3');

%% Distribution of cp states in each grasp
figure();

n_st1= zeros(1,n_grasps);
n_st2= zeros(1,n_grasps);
n_st3= zeros(1,n_grasps);

for i = 1: n_grasps
    n_cp = length(PGR_BF(i).comb(:)); % number of contact points
    n_st1(i) = sum(PGR_BF(i).comb(:) == 1);
    n_st2(i) = sum(PGR_BF(i).comb(:) == 2);
    n_st3(i) = sum(PGR_BF(i).comb(:) == 3);
end

plot(1:n_grasps, n_st1, 'b*', 'MarkerSize', 10); hold on;
plot(1:n_grasps, n_st2, 'r+', 'MarkerSize', 10); hold on;
plot(1:n_grasps, n_st3, 'yo', 'MarkerSize', 10);
legend('ST1','ST2', 'ST3') 

%% 
% Finding the minimum and maximum number of contact points of all grasps
min_cp = 100;
max_cp = 0;
count =0;
for i = 1:n_grasps
    load(grasps(i).name);
    
    n_cp = size(hand.cp,2);
    min_cp = min(min_cp, n_cp);
    max_cp = max(max_cp, n_cp);
    
end

%% See if the total n_cp has some influence in the n_cp for each state
% Groups the grasps according the total cp and then counts the number of cp
% in each state for each grasp

ncp(1:max_cp-min_cp+1) = ...
            struct('n_st1', [],'n_st2', [],'n_st3', []);
for i = 1:n_grasps
    
    load(grasps(i).name);
    n_cp = size(hand.cp,2);
    
    n_st1 = sum(PGR_BF(i).comb(:) == 1);
    n_st2 = sum(PGR_BF(i).comb(:) == 2);
    n_st3 = sum(PGR_BF(i).comb(:) == 3);
    
    ind = n_cp-min_cp+1; % vector index
    ncp(ind).n_st1 =  [ncp(ind).n_st1, n_st1];
    ncp(ind).n_st2 = [ncp(ind).n_st2, n_st2];
    ncp(ind).n_st3 = [ncp(ind).n_st3, n_st3];
end

%%
for i = 1:max_cp-min_cp+1
    
    figure();
    plot(ncp(i).n_st1, 'b*', 'MarkerSize', 10); hold on;
    plot(ncp(i).n_st2, 'r+', 'MarkerSize', 10); hold on;
    plot(ncp(i).n_st3, 'yo', 'MarkerSize', 10); 
    xlabel('Grasp Number')
    xlabel('Number of contact points')
    title(sprintf('The number of total cp in each grasp: %d', i+min_cp-1));

end

