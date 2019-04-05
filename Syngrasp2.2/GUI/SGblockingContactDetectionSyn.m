  function [new_hand,new_object] = SGblockingContactDetectionSyn(hand,object,new_z)
   
   if(size(new_z,1) == 1)
   new_z = new_z';
   end
   
   new_q = hand.qm + hand.S*new_z;
   
   %hand = SGmoveHand(hand,new_q);
   
   tmp_hand = hand;
   tmp_obj = object;
   
   for i=1:hand.m
   
   [tmp_hand,tmp_obj] = SGblockingContactDetection(tmp_hand,tmp_obj,i,new_q(i));
   end
   
   new_hand =tmp_hand;
   new_object = tmp_obj;
   end