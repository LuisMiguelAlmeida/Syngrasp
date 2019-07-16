%% Function to Find best position and rotation
%     There are two ways to use this function:
%    1st - You only need to search for the best object position, so mode is
%    defined as 'Pos'
%    2nd - You need to search for the best position and rotation, so mode is
%    defined as 'PosAndRot'
%
%    Usage:  [center_obj_opt, cost_val] = FindBestObjectPose(hand,obj, center_obj0, rot0, 'Pos')
%    or  [center_obj_opt, cost_val] = FindBestObjectPose(hand,obj, center_obj0, rot0, 'PosotAndRot')
%    Arguments:
%    hand = hand structure 
%    obj = object structure 
%    center_obj0 = initial object center(where the fucntion will start its
%    search)
%    rot0 = initial object rotation
%    mode = string that decides if this function only search the best
%    position or it also find the best object rotation
%
%    Returns:
%    center_obj_opt = optimal object center or pose    
%    cost_val = PGR value on the best position

function [center_obj_opt, cost_val] =  FindBestObjectPose(hand,obj, center_obj0, rot0, mode)
    
    option = optimset('Display','iter','PlotFcns',@optimplotfval);
    option.TolX = 1e-1;
    option.TolFun = 1e-1;
    option.MaxIter = 25; 
    option.MaxFunEvals = 5000; % Put to 10000 for nc = 15

    pose0 = [center_obj0, rot0];
    
    switch mode
        case 'Pos'
            [center_obj_opt, cost_val] = fminsearch(@(center_obj) SGBestPosCost(hand,obj,center_obj,rot0, 'BruteForce'),center_obj0,option); % Search for the 'best' object center
        case 'PosAndRot'
            [center_obj_opt, cost_val] = fminsearch(@(pose) SGBestPosCostWithRot(hand,obj,pose, 'BruteForce'),pose0,option); % Search for the 'best' object center
    end
end
