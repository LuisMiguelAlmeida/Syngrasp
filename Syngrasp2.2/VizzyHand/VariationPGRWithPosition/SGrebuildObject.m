%   SGrebuildObject - Rebuilds an object given a new center and a rotation
%
%    Usage: [new_object] = SGrebuildObject(object, new_center, rot)
%    Arguments:
%    object = the object structure in the initial grasp configuration
%    new_center = new object center
%    rot = 3D vector that contains the axis rotation angles
%    rot(1) = theta
%    rot(2) = phi
%    rot(3) = psi
%
%    Returns:
%    new_object = new object structure

function [new_object] = SGrebuildObject(object, new_center, rot)
    H=eye(4);
    %translation = new_center - object.center; % Translation vector
    object.Htr = SGrotAndTransl(H,new_center, rot(1), rot(2), rot(3));
    
    switch object.type
        case 'auto'
            % TODO
            disp('ALARM: Not yet done!!!!');
        case 'cube'
            new_object = SGcube(object.Htr,object.dim(1),object.dim(2),object.dim(3));
            
        case 'cyl'
            new_object = SGcylinder(object.Htr,object.h,object.radius,object.res);
            
        case 'sph'
            new_object = SGsphere(object.Htr,object.radius,object.res);
            
        otherwise
            error 'bad input arguments'
    end
end

