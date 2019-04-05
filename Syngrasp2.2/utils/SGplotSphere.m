%function that plots a sphere in the space given the sphere as a structure
%calculated by the function SGsphere

function SGplotSphere(sph)

grid on
SGdrawSphere(sph.Htr,sph.radius,sph.res);

end