function alpha = SGlinkIntersection(seg,struct2,epsilon)

    if(~SGisSeg(seg))
       error 'Argument seg should be a seg-structure' 
    end
    
    if (nargin<3)
        epsilon=1e-4;
        sprintf('default value of epsilon set to %d',epsilon);
    end
    
    switch struct2.type
        case 'cube'
            offset = 5.0;
            struct2_m = SGcube(struct2.Htr,struct2.dim(1)+offset,struct2.dim(2)+offset,struct2.dim(3)+offset);
            alpha = SGintSegCube(seg,struct2_m);
        case 'cyl'
            struct2_m = SGcylinder(struct2.Htr,struct2.h,struct2.radius,struct2.res);
            alpha = SGintSegCyl(seg,struct2_m,epsilon);
        case 'sph'
            struct2_m = SGsphere(struct2.Htr,struct2.radius,struct2.res);
            alpha = SGintSegSph(seg,struct2_m,epsilon);
        otherwise
            error 'bad input arguments'
    end
end