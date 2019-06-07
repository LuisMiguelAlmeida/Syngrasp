%   SG_PCR - evaluates the PCR quality measures for a
%   given grasp
%
%    Usage:[PCR]=SG_PCR(hand0, Combinazioni)
%    Arguments:
%    hand0 = the hand structure in the initial grasp configuration
%    object0 = object structure in the initial grasp configuration
%
%    Returns:
%    PCR = The PCR quality index
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

function [PCR]=SG_PCR(hand0, object0)
 nc0=size(hand0.cp,2); % initial number of contact points
if (nargin < 2) || (nargin > 2)
  error('BruteForcePGR requires exactly 2 arguments')
end

    % Stiffness at the contacts
    ks=1;

    Kx=ks*ones(nc0,1);
    Ky=ks*ones(nc0,1);
    Kn=ks*ones(nc0,1);

    K0=ks*eye(3*nc0,3*nc0);
    
    % Contact properties and optimization parameters
    mu = 0.8;
    alpha = 1/sqrt(1+mu^2);
    fmin = 1;
    fmax = 30;
    k = 0.001;
    w = zeros(6,1);
    
    option.TolX = 1e-3;
    option.TolFun = 1e-3;
    option.MaxIter = 50000;
    option.MaxFunEvals =5000; % Put to 10000 for nc=15

    hand0.Kz = eye(size(hand0.S,2)); 
    linMaps = SGquasistaticMaps(hand0,object0);
    E = ima(linMaps.P); % basis for the controllable internal forces
    ncont = size(E,2);

    y0 = 100*ones(ncont,1); 
    [yoptB, cost_val] = fminsearch(@(y) SGVcostPCR(w,y,pinv(object0.G),E,object0.normals,mu, fmin,fmax,k),y0,option); % I search for the 'best' y

    PCR = 1/cost_val; % Potential contact robustness
   

end

