function res = SGpointInCylinder(p,cyl)

if size(p,1) == 1
p = p';
end 
    
p_tilde = [p;1];
p_new_tilde = inv(cyl.Htr)*p_tilde;
p_new = p_new_tilde(1:3);


if(norm(p(1:2)) <=cyl.radius && abs(p(3))<=cyl.h/2)
    res = 1;
else
    res = 0;

end

