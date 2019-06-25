function alpha = SGintSegCube(seg,cube)

%splitting the cube into its faces,
%retrieving vertices:

%V=[cube.faces.f1,cube.faces.f2,cube.faces.f3,cube.faces.f4,cube.faces.f5,cube.faces.f6]; % F is a 3-by-24 matrix

ep = 1e-3; % Margin of error of cube's face postion

V = [];

for i=1:6
    V = [V cube.faces.ver{i}];
end


Inv = inv(cube.Htr);
V_tilde = zeros(size(Inv,1),24);
for cont=1:24
    V_tilde(:,cont) = Inv*[V(:,cont);1];
end
%evaluating intersections: 
alphaVect = zeros(1,6);
for i=1:4:24
    CM = [V(:,i)' 1 ; V(:,i+1)' 1 ; V(:,i+2)' 1];
    if rank(CM) <= 2
        error('bad cube definition: vertices on face %d are aligned',SGindexReduction(i))
    end
    x1 = CM(1,1); 
    x2 = CM(2,1);
    x3 = CM(3,1);
    y1 = CM(1,2);
    y2 = CM(2,2);
    y3 = CM(3,2);
    z1 = CM(1,3);
    z2 = CM(2,3);
    z3 = CM(3,3);
    A = y1*(z2 - z3) - z1*(y2 - y3) + (y2*z3 - y3*z2);
    B = -(x1*(z2 - z3) - z1*(x2 - x3) + (x2*z3 - x3*z2));
    C = x1*(y2 - y3) - y1*(x2 - x3) + (x2*y3 - x3*y2);
    D = -(x1*(y2*z3 - y3*z2) - y1*(x2*z3 - x3*z2) + z1*(x2*y3 - x3*y2));
    DEN = (A*(seg.p1(1) - seg.p0(1)) + B*(seg.p1(2) - seg.p0(2)) + C*(seg.p1(3) - seg.p0(3)));
    if (DEN == 0)
        alphaVect(SGindexReduction(i)) = NaN;
        break
    end
    alphaTmp = -(A*seg.p0(1) + B*seg.p0(2) +C*seg.p0(3) + D) / DEN;
    %check alpha:
    j = SGindexReduction(i);
    
    if (alphaTmp <= 0.0 || norm(alphaTmp) > 1.0)
       alphaVect(j) = NaN;
    else
       alphaVect(j) = alphaTmp;
    end
end

for k=1:length(alphaVect)
    if ~isnan(alphaVect(k))
        alpha = alphaVect(k);
        X_tmp = seg.p0(1) + alpha*(seg.p1(1) - seg.p0(1));
        Y_tmp = seg.p0(2) + alpha*(seg.p1(2) - seg.p0(2));
        Z_tmp = seg.p0(3) + alpha*(seg.p1(3) - seg.p0(3));
        P_tilde = inv(cube.Htr)*[X_tmp;Y_tmp;Z_tmp;1];
        X_tmp = P_tilde(1);
        Y_tmp = P_tilde(2);
        Z_tmp = P_tilde(3);
        if ((X_tmp >= min(V_tilde(1,:))-ep) && (X_tmp <= max(V_tilde(1,:))+ep) && (Y_tmp >= min(V_tilde(2,:))-ep) && (Y_tmp <= max(V_tilde(2,:))+ep) && (Z_tmp >= min(V_tilde(3,:))-ep) && (Z_tmp <= max(V_tilde(3,:))+ep))
            alphaVect(k) = alpha;
        else
            alphaVect(k) = NaN;
        end
    else
        alphaVect(k) = NaN;
    end
end
alpha = min(alphaVect);
end