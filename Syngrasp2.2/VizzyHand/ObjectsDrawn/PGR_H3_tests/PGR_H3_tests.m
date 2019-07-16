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

%% Heuristics comparation
plot(1:n_grasps, [PGR_BF.quality]); hold on;
plot(1:n_grasps, [PGR_H2.quality]); hold on;
plot(1:n_grasps, [PGR_H3.quality]);
xlabel('Grasp Number')
ylabel('PGR')
legend('BF', 'H2', 'H3');

figure();

%% Time comparison
plot(1:n_grasps, [PGR_BF.time]); hold on;
plot(1:n_grasps, [PGR_H2.time]); hold on;
plot(1:n_grasps, [PGR_H3.time]);
xlabel('Grasp Number')
ylabel('Time')
legend('BF', 'H2', 'H3');

%%
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

plot(1:n_grasps, n_st1, 'b*', 'MarkerSize', 10); figure
plot(1:n_grasps, n_st2, 'r+', 'MarkerSize', 10); figure
plot(1:n_grasps, n_st3, 'yo', 'MarkerSize', 10);

