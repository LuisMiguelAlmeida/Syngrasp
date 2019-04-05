function SGplotSolid(struct)
hold on
grid on
switch struct.type
    case 'cube'
        SGplotCube(struct);
    case 'cyl'
        SGplotCylinder(struct);
    case 'sph'
        SGplotSphere(struct);
    otherwise
        error 'bad input arguments'
end
hold off
end