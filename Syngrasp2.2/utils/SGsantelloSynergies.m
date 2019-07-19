function [qm, S] = SGsantello_synergies


S_tmp = load('S_matrix.mat');
S = S_tmp.S;

s0 = zeros(1, size(S,2));% Taking into account wrist joint
S = [s0; S];
qm_tmp = load('qm.mat');
qm = qm_tmp.qm;
qm = [0, qm]; % Taking into account wrist joint


