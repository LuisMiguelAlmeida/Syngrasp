function cyl = SGdrawCylinder(Htr,h,rad,res)

cyl= SGcylinder(Htr,h,rad,res);

hold on
grid on
xlabel('x')
ylabel('y')
zlabel('z')
surf(cyl.X,cyl.Y,cyl.Z)
end