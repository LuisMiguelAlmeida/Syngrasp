%function that plots a cylinder in the space given the cylinder as a structure
%calculated by the function SGcylinder

function SGplotCylinder(struct_arg)

grid on
SGdrawCylinder(struct_arg.Htr,struct_arg.h,struct_arg.radius,struct_arg.res)

end