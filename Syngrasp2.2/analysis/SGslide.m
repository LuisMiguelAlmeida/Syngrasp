% This function computes the dislacement of hand joints and wrist position
% due to the dqr assigned. It takes care of the compliance at wrist, joint
% and contact level

function [displacements] = SGslide(hand,Kc,dqr)

nc = size(hand.cp,2);
Kqext = [hand.Kq, zeros(hand.m, 6); zeros(6, hand.m) hand.Kw];

%qext = [hand.q; hand.Wr];
           
    A = [eye(3*nc), -hand.Jext, zeros(3*nc, hand.m +6), zeros(3*nc);
            zeros(hand.m +6, 3*nc), zeros(hand.m +6), eye(hand.m + 6) -hand.Jext';
            zeros(hand.m +6, 3*nc), Kqext, eye(hand.m +6), zeros(hand.m +6, 3*nc);
           -Kc, zeros(3*nc, hand.m +6), zeros(3*nc, hand.m +6), eye(3*nc);
    ];

b = [zeros(3*nc,1); zeros(hand.m+6, 1); Kqext * dqr'; zeros(3*nc,1)];

displacements = A\b;
     

    
end