%function that calculates main data of a cylinder needed by 
%grasping-related applications.

% Htr = Homogeneous transformation
% h = height of the cylinder
% rad = radius
% shape = vector of linearly spaced percents of radius over height 
% (more entries = better resolution)
% res = number of points around circumference
function struct = SGcylinder(Htr,h,rad,res)

if nargin == 3
    res = 0;
    [X,Y,Z] = cylinder(rad);
end   
if nargin == 4
    [X,Y,Z] = cylinder(rad,res);        
end
c1 = Htr*SGtransl([0,0,-h/2]);
c2 = Htr*SGtransl([0,0,h/2]);
struct.type = 'cyl';
struct.axis = c1(1:3,4)-c2(1:3,4)/norm(c1(1:3,4)-c2(1:3,4)); % axis direction
struct.center = Htr(1:3,4);
Z = h*Z; %height accordingly to requested

struct.p = zeros(3,size(X,2),size(X,1));
for k=1:size(X,1)
    for j=1:size(X,2)
        p = [X(k,j);Y(k,j);Z(k,j);1];
        v = Htr*SGtransl([0,0,-h/2])*p;
        struct.p(:,j,k) = v(1:3);
    end
end

for i=1:size(X,1)
    for j=1:size(X,2)
        struct.X(i,j) = struct.p(1,j,i);
        struct.Y(i,j) = struct.p(2,j,i);
        struct.Z(i,j) = struct.p(3,j,i);
    end
end

struct.radius = rad;
struct.Htr = Htr;
struct.h = h;
struct.res = res;

end