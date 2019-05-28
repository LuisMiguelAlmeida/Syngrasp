%    SGVcostPCR - Evaluate the force-closure cost function for a given
%    grasp as in the reference paper but with slight modifications.
%    
%    The function returns the value of the force-closure cost function to
%    minimize to achieve the best grasp feasible with the given set of
%    synergies 
%
%    Usage: [yopt,cost] = fminsearch(@(y) SGVcostPCR(w,y,pG,hand.Es,hand.cn,mu, fmin,fmax,k),y0)
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
%    Reference: 
%    M. Gabiccini, A. Bicchi, D. Prattichizzo, M. Malvezzi. 
%    On the role of hand synergies in the optimal choice of grasping forces. 
%    Autonomous Robots, Springer, 31:235-252, 2011.
%
%    Note: this evaluation is suitable only for Hard Finger Contact model


function [cost] = SGVcostPCR(w,y,pG,E,n,mu, fmin,fmax,k)

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

% evaluate the number of contacts
 [tmp,nc] = size(n);
if(tmp ~= 3 || size(lambda,1) ~= 3*nc)
   error 'input parameters dimensions should be such that: pG[3nc x 6], n[3 x nc]' 
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

% for each contact
for i = 1:nc
    % extract the contact force relative to the i-th contact from the
    % lambda vector
    lambdai = lambda(3*i-2:3*i);
    % i-th contact normal
    ni = n(:,i);
    % for each constraint
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
end

cost = V/nc;
