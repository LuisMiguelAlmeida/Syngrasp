grasps = dir('*.mat');

n_grasps = length(grasps); % Number of grasps

for i = 1:n_grasps
    load(grasps(i).name);
    [Quality, ~, combopt] = SG_PGRbruteforce(hand, obj);
    
    if Quality < 20
        delete(grasps(i).name);
    end
end