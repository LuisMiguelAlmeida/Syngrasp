% function that evaluates the contact between a segment and a sphere,
% returning the corresponding alpha parameter as the normalized position:
% alpha = 0 means the first point, alpha = 1 means the second, if there
% aren't any contact points, alpha = NaN.
% epsilon could be absolute or radius-relative (% of radius)
function alpha = SGintSegSph(seg,sph,epsilon)
% the solving equation is A*alpha^2 + B*alpha + C = 0; where:

if norm(seg.p1 - sph.center)<=sph.radius
    alpha = 1;
    
else
    x1 = seg.p1(1);
    y1 = seg.p1(2);
    z1 = seg.p1(3);
    x0 = seg.p0(1);
    y0 = seg.p0(2);
    z0 = seg.p0(3);
    xc = sph.center(1);
    yc = sph.center(2);
    zc = sph.center(3);
    R  = sph.radius;
    
    A = ((x1 - x0)^2 + (y1 - y0)^2 + (z1 - z0)^2);    
    B = 2*((x1 - x0)*(x0 - xc) + (y1 - y0)*(y0 - yc) + (z1 - z0)*(z0 - zc));    
    C = (x0 - xc)^2 + (y0 - yc)^2 + (z0 - zc)^2 - R^2;    
    Delta = B^2 - 4*A*C;
    
    % contact evaluation:
    
    if (Delta < 0.0)
        %no intersection
        alpha = NaN;
        return
    end
    if (Delta >= 0.0 && norm(Delta) <= epsilon)
        % approximated one point intersection
        alpha = (-B/(2*A));
        if (alpha < 0 || abs(alpha)>1)
            alpha = NaN;
            return
        end
    elseif (Delta > 0.0 && norm(Delta) > epsilon)
        % two points intersection
        t0 = (-B - sqrt(Delta))/(2*A);
        if (t0 > 0.0 && abs(t0)<1)
            alpha = t0;
        else
            alpha = (-B + sqrt(Delta))/(2*A);
            if (alpha < 0 || abs(alpha)>1)
                alpha = NaN;
                return
            end
        end
    end
end
end