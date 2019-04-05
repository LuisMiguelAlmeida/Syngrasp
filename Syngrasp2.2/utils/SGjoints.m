% This function updates the positions of the joints in the finger structure 

function newHand = SGjoints(hand)

    newHand = hand;

    for i=1:hand.n     
        newHand.F{i}.joints = hand.F{i}.base(1:3,4);
        referenceJoint = hand.F{i}.base;        

        for j = 1:hand.F{i}.n        
            localTransf = SGDHMatrix(hand.F{i}.DHpars(j,:));
            referenceJoint = referenceJoint*localTransf;        
            newHand.F{i}.joints = [newHand.F{i}.joints referenceJoint(1:3,4)];
        end 
    end

end