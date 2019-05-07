% Script to compute the synergy matrix of Vizzy Hands
% Computes the synergies for each finger and saves it on a .mat file
%
% There are two ways to compute the synergies:
% Automatically, where the synergie is aproximated by one liner regression
% Manually, where the user aproximates the synergie by segments
clc; close all; clear;

bagThumb1 = rosbag('RosBags/Thumb1.bag');
bagThumb2 = rosbag('RosBags/Thumb2.bag');
bagIndex = rosbag('RosBags/Index.bag');
bagMiddle = rosbag('RosBags/Middle.bag');
%%
% Define first thumb joint Synergy
[Data, Time] = MatchDataThroughTime(bagThumb1);
Sthumb1 = DefineFingerSynergy(Data,Time, 1,1, 'Thumb1');
%%
% Define second and third thumb joints Synergies
[Data, Time] = MatchDataThroughTime(bagThumb2);
Sthumb2 = DefineFingerSynergy(Data,Time, 1,2, 'Thumb2');
%%
% Define all Index joints Synergies
[Data, Time] = MatchDataThroughTime(bagIndex);

Sindex = DefineFingerSynergy(Data,Time, 1, 3,'Index');
%%
% Define all Middle joints Synergies
[Data, Time] = MatchDataThroughTime(bagMiddle);
Smiddle = DefineFingerSynergy(Data,Time, 1,3, 'PinkyRing');
%%
% save the synergies in a .mat file
save('VizzySynergies.mat', 'Sthumb1', 'Sthumb2', 'Sindex', 'Smiddle');

