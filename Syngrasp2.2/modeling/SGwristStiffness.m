function newHand = SGwristStiffness(hand,stiffness)

if(~SGisHand(hand))
    error 'hand argument is not a valid hand-structure' 
end

newHand = hand;
if (isscalar(stiffness))    
    newHand.Kw = stiffness*eye(size(hand.q,1));
else    
    newHand.Kw = stiffness;
end

end