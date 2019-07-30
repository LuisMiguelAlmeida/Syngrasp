function Plot1Hand_ObjectWithPGR(hand, obj, titl, PGR, n_fig)
    % Plot the hand and an object with PCR, PGR brute force, H1 and H2
    
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
    
    % Plot "Legend" with all PGR's given in struct "PGR"
    PGRnames = fieldnames(PGR);
    str = [];
    for i=1:length(PGRnames)
        PGRvalue = PGR.(PGRnames{i});
        str = sprintf('%s%s: %.2f\n',str, PGRnames{i}, PGRvalue);
    end
    text(0.9,0.9,str,'Units','normalized')
    hold off;
end

