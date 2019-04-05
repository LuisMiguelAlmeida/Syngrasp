function sph=SGdrawSphere(Htr,rad,res)

if nargin < 3
    res=20;
    sph=SGsphere(Htr,rad,res);
    xlabel('x')
    ylabel('y')
    zlabel('z')
    surf(sph.X,sph.Y,sph.Z)
else if nargin ==3
        sph=SGsphere(Htr,rad,res);
        xlabel('x')
        ylabel('y')
        zlabel('z')
        surf(sph.X,sph.Y,sph.Z)
    end
end
if nargin ~=3
    error('invalid input arguments')
end

end