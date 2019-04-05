function res = SGpointInCube(p,cube)

if size(p,1) == 1
p = p';
end 
    
p_tilde = [p;1];
p_new_tilde = inv(cube.Htr)*p_tilde;
p_new = p_new_tilde(1:3);

if(abs(p_new(1))<= abs(cube.dim(1))/2 && abs(p_new(2)) <= abs(cube.dim(2))/2 && abs(p_new(3)) <= abs(cube.dim(3))/2)
    
    res = 1;
    
else
    
    res = 0;
   

end

end

