% Loads different types of grasps and make the corresponding plots

clc
i =1; % initialization of i variable
%% Large Diameter Grasp
tic;

load('LargeDiameter.mat');
titl{i} = 'Large Diameter'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();
toc; % 15675.427317 seg
%% Small Diameter Grasp
tic;
load('SmallDiameter.mat');
titl{i} = 'Small Diameter'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();

% Palmar Grasp
load('Palmar.mat');
titl{i} = 'Palmar'; 
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();
toc;

% Precision Disk Grasp
tic;
load('PrecisionDisk.mat');
titl{i} = 'Precision Disk'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();
toc;

% Power Disk Grasp
tic;
load('PowerDisk.mat');
titl{i} = 'Power Disk'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
toc;
save ws_obj_drawn;

%% Load pre computed images
load ws_obj_drawn; % Loads worspace

%% opens figures pre-computed
for j = 1 : i
    openfig(titl{j}); 
end
