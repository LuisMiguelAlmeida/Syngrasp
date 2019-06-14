% Loads different types of grasps and make the corresponding plots
clear all;
close all;
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
toc;
%% Small Diameter Grasp
load('SmallDiameter.mat');
titl{i} = 'Small Diameter'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();

%% Palmar Grasp
load('Palmar.mat');
titl{i} = 'Palmar'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();


%% Precision Disk Grasp
load('PrecisionDisk.mat');
titl{i} = 'Precision Disk'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});
i = i+1;
figure();


%% Power Disk Grasp
load('PowerDisk.mat');
titl{i} = 'Power Disk'; % titl{i}e
[PCR(i),PGR_BF(i), PGR_H1(i), PGR_H2(i)] = Plot1Hand_Object(hand, obj, titl{i}, 3);
savefig(titl{i});

save ws_obj_drawn;

%% Load pre computed images
load ws_obj_drawn; % Loads worspace

% opens figures pre-computed
for j = 1 : i
    openfig(titl{i}{j}); 
end
