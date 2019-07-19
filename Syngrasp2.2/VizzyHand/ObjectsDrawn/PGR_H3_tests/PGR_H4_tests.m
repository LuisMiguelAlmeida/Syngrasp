% Script to evaluate heuristic 4
grasps = dir('Grasps/*.mat');

n_grasps = length(grasps); % Number of grasps

% Pre-allocation of memory
PGR_BF(1:n_grasps)= struct('quality', 0,'comb',0,'time',0);
PGR_H4(1:n_grasps)= struct('quality', 0,'comb',0,'time',0);

fprintf('Brute force:\n');

for i = 1:n_grasps
    waitbar(i/n_grasps)
    load(grasps(i).name);
    [Quality, ~, combopt] = SG_PGRbruteforce(hand, obj);
    time = toc;
    PGR_BF(i).quality = Quality;
    PGR_BF(i).comb = combopt;
    PGR_BF(i).time = time;
    
end


fprintf('Heuristic 4:\n');

for i = 1:n_grasps
    waitbar(i/n_grasps)
    load(grasps(i).name);
    tic;
    [Quality, ~, combopt] = SG_PGRh4(hand, obj);
    time = toc;
    PGR_H4(i).quality = Quality;
    PGR_H4(i).comb = combopt;
    PGR_H4(i).time = time;
end


save ws_H4_tests.mat

%% Plots BF vs H4
load('ws_H4_tests.mat');

plot([PGR_BF.quality], 'go');
hold on;
plot([PGR_H4.quality],'b+');
legend('Brute Force', 'H4');

Diff = setdiff([PGR_BF.quality], [PGR_H4.quality]);

fprintf('The percentage of PGR_BF different from PGR_H4 is (in %%): %f\n', 100*length(Diff)/n_grasps);

%fprintf('Relative error is (in %%): %f\n', 100*sum(abs(PGR_BF-PGR_H4)./PGR_BF)/n_grasps);

%% Comparison of times between BF and H2, H3, H4
close all;
load('ws_H3_tests.mat');
load('ws_H4_tests.mat');

plot([PGR_BF.time]); hold on;
plot([PGR_H2.time]); hold on;
plot([PGR_H3.time]); hold on;
plot([PGR_H4.time]);
xlabel('Grasp Number')
ylabel('Time (s)')
legend('BF', 'H2', 'H3', 'H4');

figure();

plot(log10([PGR_BF.time])); hold on;
plot(log10([PGR_H2.time])); hold on;
plot(log10([PGR_H3.time])); hold on;
plot(log10([PGR_H4.time]));
xlabel('Grasp Number')
ylabel('Time')
legend('BF', 'H2', 'H3', 'H4');
title('Logaritmic scale (log10)')

