function res = SGpointInSphere(p,sphere)

if(norm(p - sphere.center) <= sphere.radius)
    
    res = true;
    
else
    res = false;

end

