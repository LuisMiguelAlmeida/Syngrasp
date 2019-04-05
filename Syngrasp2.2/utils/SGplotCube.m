%function that plots a cube in the space given the cube as a structure
%calculated by the function SGcube

function SGplotCube(cube)

hold on
grid on
axis 'equal'
xlabel('x')
ylabel('y')
zlabel('z')
for i = 1:6
    fill3(cube.faces.ver{i}(1,:),cube.faces.ver{i}(2,:),cube.faces.ver{i}(3,:),'r')
end
% fill3(cube.faces.f1(1,:),cube.faces.f1(2,:),cube.faces.f1(3,:),'y')
% fill3(cube.faces.f2(1,:),cube.faces.f2(2,:),cube.faces.f2(3,:),'m')
% fill3(cube.faces.f3(1,:),cube.faces.f3(2,:),cube.faces.f3(3,:),'c')
% fill3(cube.faces.f4(1,:),cube.faces.f4(2,:),cube.faces.f4(3,:),'r')
% fill3(cube.faces.f5(1,:),cube.faces.f5(2,:),cube.faces.f5(3,:),'g')
% fill3(cube.faces.f6(1,:),cube.faces.f6(2,:),cube.faces.f6(3,:),'b')
end