function cp_mat = SGcontactDetection(hand,struct,i)
% i is the index that indicates the finger the algorithm is moving

finger = hand.F{1,i};

cp_mat = []

for j = 1:(size(finger.joints,2) - 1)
    alpha = NaN;    
    if(norm(finger.joints(:,j+1)-finger.joints(:,j)) > 0)     
        link_seg = SGsegment(finger.joints(:,j),finger.joints(:,j+1));    
        [alpha] = SGlinkIntersection(link_seg,struct);    
    end 

    if ~isnan(alpha)    
       cp_mat = [cp_mat; j alpha];
    end
end

end