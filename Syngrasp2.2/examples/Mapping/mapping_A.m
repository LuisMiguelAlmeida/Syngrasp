function A = mapping_A(hand,c)

    
    I = eye(3,3);
    
    
    
    xyz = hand.ftips;

    A = zeros(3*size(hand.cp,2), 7);
    
    for i=1:size(hand.cp,2)
    
    A(3*(i-1)+1:3*(i-1)+3,:) = [I -SGskew(xyz(:,i)' - c) (xyz(:,i)' - c)'];
    
    
    end



end