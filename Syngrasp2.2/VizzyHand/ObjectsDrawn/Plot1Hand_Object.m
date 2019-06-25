function [PCR,PGR_BF, PGR_H1, PGR_H2] = Plot1Hand_Object(hand, obj, titl, n_attached, n_fig)
    % Plot the hand and an object with PCR, PGR brute force, H1 and H2
    
    PCR = 0;PGR_BF = 0;PGR_H1 = 0;PGR_H2 = 0;
    
    if ~isfield(hand, 'cp') || ~isfield(obj, 'cp')
        %error('No contact points');
        return;% No contact points
    end
        
    if nargin == 5
        figure(n_fig);
    end
    view(1,8);
    hold on;
    SGplotHand(hand);
    hold on;
    SGplotObject(obj);
    hold on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(titl);
    [PCR]=SG_PCR(hand, obj);
    [PGR_BF, ~, ~]=SG_PGRbruteforce(hand, obj); % Brute Force PGR
    [PGR_H1, ~, ~]=SG_PGRh1(hand,obj); % PGR with Heuristic 1
    [PGR_H2, ~, ~]=SG_PGRh2(hand,obj,n_attached); % PGR with Heuristic 2
    str = sprintf('PCR: %.2f\nPGR Brute Borce: %.2f\nPGR H1: %.2f\nPGR H2: %.2f',PCR,PGR_BF, PGR_H1, PGR_H2);
    text(0.9,0.9,str,'Units','normalized')
    hold off;
end

