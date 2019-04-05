% This function generates a cloud of N points along a sphere with center
% given by object's matrix H, with gauge G. Then creates an array of Homogeneous
% transformation matrices for hand pose
% P is a 4*4*N matrix Sigma-World R.F.

 function P = SGgenerateCloud(struct,G,N)

 switch struct.type
     case 'sph'
         G = struct.radius+G;
     case 'cyl'
         dist = norm(struct.p(:,1,1) - struct.center);
         G = dist + G;
     case 'cube'
         G = norm(0.5*(struct.dim)) + G;
     otherwise
         error('bad input argument')
 end
         
% These are realizations of Random Variables ~U[0,2*pi]
x_angle = 2*pi.*rand(1,N); % parameter for SGrotx 
y_angle = 2*pi.*rand(1,N);  % parameter for SGroty
z_angle = 2*pi.*rand(1,N);    % parameter for SGrotz
%Rotations:
Rx = zeros(3,3,N);
Ry = Rx;
Rz = Rx;
H_tmp = zeros(4,4,N);
P = H_tmp;
for i=1:N
    H_tmp(:,4,i) = [struct.center;1];
    Rx(:,:,i) = SGrotx(x_angle(i));
    Ry(:,:,i) = SGroty(y_angle(i));
    Rz(:,:,i) = SGrotz(z_angle(i));
    H_tmp(1:3,1:3,i) = Rx(:,:,i)*Ry(:,:,i)*Rz(:,:,i);
    H_tmp(:,:,i) = H_tmp(:,:,i)*SGtransl([0,0,G]);
    %H_tmp(:,:,i) = H_tmp(:,:,i)*SGtransl([0,0,0]);
    P(:,:,i) = H_tmp(:,:,i);
end