% function that evaluates contact between a segment and a cylinder,
% returning the corresponding alpha parameter as the normalized position:
% alpha = 0 means the first point, alpha = 1 means the second, if there
% aren't any contact points, alpha = NaN.
% epsilon could be absolute or radius-relative

function alpha = SGintSegCyl(seg,cyl,epsilon)
%segment points convertion in Sigma_cylinder R.F.

P0_tilde = [seg.p0;1];
P0 = inv(cyl.Htr)*P0_tilde;
P0 = P0(1:3);
P1_tilde = [seg.p1;1];
P1 = inv(cyl.Htr)*P1_tilde;
P1 = P1(1:3);
xc = 0;
yc = 0;
R  = cyl.radius;

x0 = P0(1);
y0 = P0(2);
z0 = P0(3);
x1 = P1(1);
y1 = P1(2);
z1 = P1(3);

% the solving equation is A*alpha^2 + B*alpha + C = 0; where:

A = ((x1 - x0)^2 + (y1 - y0)^2);
B = 2*((x1 - x0)*(x0 - xc) + (y1 - y0)*(y0 - yc));
C = (x0 - xc)^2 + (y0 - yc)^2 - R^2;
Delta = B^2 - 4*A*C;

% contact evaluation:

if (Delta < 0.0)
    %no intersection
    alpha = NaN;
    return    
end
if (Delta >= 0.0 && norm(Delta) <= epsilon)
    % approximated one point intersection
    alphaTmp = (-B/(2*A));
elseif (Delta > 0.0 && norm(Delta) > epsilon)
    % two points intersection
    s0 = (-B - sqrt(Delta))/(2*A);
    if (s0 > 0.0)
        alphaTmp = s0;
    else
        alphaTmp = (-B + sqrt(Delta))/(2*A);
    end
end

X = x0 + alphaTmp*(x1 - x0);
Y = y0 + alphaTmp*(y1 - y0);
Z = z0 + alphaTmp*(z1 - z0);

%bounds check:
alpha = NaN;

P_tilde = [cyl.p;ones(1,length(cyl.X),size(cyl.p,3))];
cpt = 0*P_tilde;
for i = 1:size(cyl.p,3)
    for j = 1:length(cyl.X)
        cpt(:,j,i) = inv(cyl.Htr)*P_tilde(:,j,i);
    end
end
cpt = cpt(1:3,:,:); % cylinder points in Sigma_cylinder R.F.
xmin = min(min(min(cpt(1,:,:))));
xmax = max(max(max(cpt(1,:,:))));
ymin = min(min(min(cpt(2,:,:))));
ymax = max(max(max(cpt(2,:,:))));
zmin = min(min(min(cpt(3,:,:))));
zmax = max(max(max(cpt(3,:,:))));

if (X>=xmin && X<=xmax && Y>=ymin && Y<=ymax && Z>=zmin && Z<=zmax && alphaTmp<=1 && alphaTmp>=0)
    alpha = alphaTmp;
    %alpha = 0.5;
    return
end
end