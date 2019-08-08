% Script to evaluate if the GWS Incremental Minkowski sum
grasps = dir('../PGR_H3_tests/Grasps/*.mat');

n_grasps = length(grasps); % Number of grasps
IncMink= zeros(1,n_grasps);

for i = 1:n_grasps
    waitbar(i/n_grasps)
    load(grasps(i).name);
    IncMink(i) = GWSmetric(hand,obj);
end


%% Heuristics comparation
load('../PGR_H3_tests/ws_H3_tests.mat');
plot(IncMink, 'yo'  );
plot(1:n_grasps, [PGR_BF.quality], 'r+'); hold on;
plot(1:n_grasps, [PGR_H2.quality],'gx'); hold on;
plot(1:n_grasps, [PGR_H3.quality], 'bx');
xlabel('Grasp Number')
ylabel('PGR')
legend('BF', 'H2', 'H3');