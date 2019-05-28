%    SGVcost_PGR - Evaluate the force-closure cost function for a given
%    grasp as in the reference paper but with slight modifications in order 
%    to allow the usage also in case of contacts in state 2.
%    
%    The function returns the value of the force-closure cost function to
%    minimize to achieve the best grasp feasible with the given set of
%    synergies 
%
%    Usage: [yopt,cost] = fminsearch(@(y) SGVcost_PGR(w,y,pG,hand.Es,hand.cn,mu, fmin,fmax,k),y0)
%
%    Arguments:
%    w = the external load
%    y = the optimization variable representing the synergy activation
%    vector
%    pG =  grasp matrix pseudoniverse
%    E = matrix of controllable internal forces of the analyzed hand
%    n = number of contact points
%    mu = friction coefficent
%    fmin = minimum normal force
%    fmax = maximum normal force
%    k = coefficent of the optimization function (suggested value: 0.01)
%    
%    Returns:
%    cost = the cost function
%    yopt = the optimal  synergy activation vector
%
%    See also: SGmakehand, SGmakeFinger
%
%    References: 
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. 
%    On the role of hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
%
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.


function [cost] = SGVcost_PGR(w,y,pG,E,n,mu, fmin,fmax,k, combinazione)

if(~isscalar(mu) || ~isscalar(k) || ~isscalar(fmin) || ~isscalar(fmax))
   error 'arguments mu, k, fmin and fmax should be scalars' 
end

% evaluate the contact forces
try
    w = w(1:6); % It forces an error if "casually" size(pG,2) == size(w,1) and both are NOT 6
                % forcing a silent error to manifest
    lambda = -pG*w + E*y;
catch
    error 'input parameters dimensions should be the following: pG[nl x 6], w[6 x 1], E[nl x nh], y[nh x 1]'
end

% cosine of the friction cone angle
alpha = 1/sqrt(1+mu^2);

alphaij = [0,1,alpha];
betaij = [0,0,0];
gammaij = [-1,0,-1];
deltaij = [fmin,-fmax,0];

a = 3/(2*k^4);
b = 4/(k^3);
c = 3/(k^2);
% initialize V
V = 0;

nc1=sum(combinazione.flag1);
nc2=sum(combinazione.flag2);
nc3=sum(combinazione.flag3);

N = nc1+nc2+nc3; % total number of contacts
crow=1;
ccolN=1;

% for each contact
for i = 1:N
    
    % extract the contact force relative to the i-th contact from the
    % lambda vector
         
    if combinazione.num(i)==1
        lambdai=lambda(crow:crow+2);
        ni=n(:,ccolN);
        rh=3;
        rhN=1;

    elseif combinazione.num(i)==2
        ni=n(:,ccolN);
        lambdai=lambda(crow)*ni;
        rh=1;
        rhN=1;
    else
        rh=0;
        rhN=0;
    end
    
    % for each constraint
    if (combinazione.num(i)==1 ) % lambdai is defined only in these two cases

        for j = 1:3
            % constraint
            sigmaij = alphaij(j)*norm(lambdai) + betaij(j)*norm(cross(lambdai,ni))...
                + gammaij(j)*lambdai'*ni + deltaij(j);
            % check if the constraint is satisfied and evaluate Vij
            if sigmaij < -k
                vij = 1/(2*sigmaij^2);
            else
                vij = a*sigmaij^2+b*sigmaij+c;
            end
            V = V+vij;
            
        end
        elseif (combinazione.num(i)==2 )
            for j = 1:2 % I consider only the constraints on fmin and fmax
            % constraint
            sigmaij = alphaij(j)*norm(lambdai) + betaij(j)*norm(cross(lambdai,ni))...
                + gammaij(j)*lambdai'*ni + deltaij(j);
            % check if the constraint is satisfied and evaluate Vij
            if sigmaij < -k
                vij = 1/(2*sigmaij^2);
            else
                vij = a*sigmaij^2+b*sigmaij+c;
            end
            V = V+vij;
            end
    end
    crow=crow+rh;
    ccolN=ccolN+rhN;
end

cost = V/(nc1+nc2);
