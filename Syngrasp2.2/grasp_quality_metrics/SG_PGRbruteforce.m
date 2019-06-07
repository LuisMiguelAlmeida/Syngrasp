%   SG_PGRbruteforce - evaluates the PGR and PCR quality measures for a given grasp
%
%    Usage: [PGR, PCR, combopt] = SG_PGRbruteforce(hand0, object0, Combination)
%    Arguments:
%    hand0 = the hand structure in the initial grasp configuration
%    object0 = the object structure in the initial grasp configuration
%    Combination = states combinations of the contact points
%
%    Returns:
%    PGR = The PGR quality index
%    PCR = The PCR quality index
%    combopt = matrix with the optimal combinations for each number of engaged synergies
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

function [PGR, PCR, combopt] = SG_PGRbruteforce(hand0, object0, Combination)
    
    nc0 = size(hand0.cp,2); % Initial number of contact points
    if nargin < 2 || nargin > 3
        error('BruteForcePGR requires exactly 2 or 3 arguments');
    elseif nargin == 2
        % A single list of points as rows of xyz
        Comb = permn([1 2 3],nc0); 
    elseif nargin == 3
        Comb = Combination;
    else
        % None of the forms I allow seem to fit. Give up and throw an error.
        error('The arguments do not seem to fit into any of the allowed forms for input');
    end

    cp = hand0.cp; % Auxiliary cp vector

    ks = 1; % Stiffness at the contacts

    Kx = ks*ones(nc0,1);
    Ky = ks*ones(nc0,1);
    Kn = ks*ones(nc0,1);

    % K0 = ks*eye(3*nc0,3*nc0); % Not used -> I commented

    % Contact properties and optimization parameters
    mu = 0.8;
    % alpha = 1/sqrt(1+mu^2); % Not used -> I commented
    fmin = 1;
    fmax = 30;
    k = 0.001;
    w = zeros(6,1);

    hand0.Kz = eye(size(hand0.S,2)); 
    linMaps = SGquasistaticMaps(hand0,object0);
    E = ima(linMaps.P); % Basis for the controllable internal forces
    ncont = size(E,2);
    y0 = 100*ones(ncont,1);

    option.TolX = 1e-3;
    option.TolFun = 1e-3;
    option.MaxIter = 50000;
    option.MaxFunEvals = 5000; % Put to 10000 for nc = 15
    
    [~, cost_val] = fminsearch(@(y) SGVcostPCR(w,y,pinv(object0.G),E,...
        object0.normals,mu,fmin,fmax,k),y0,option); % Search for the 'best' y

    PCR = 1/cost_val; % Potential contact robustness

    n_Comb = size(Comb,1); % Number of combinations

    % Pre-allocating memory: Speeds problem
    combination(1:n_Comb) = ...
        struct('num',zeros(1, nc0),'nc',nc0,'hand',hand0,'object',object0,...
        'flag1',zeros(1,nc0),'flag2',zeros(1,nc0),'flag3',zeros(1,nc0));
    %'yopt',[]);
    % flagX Vector that traces the contacts in state X (X = 1,2,3)

    % Pre-allocation of quality_vector
    quality_vector = zeros(1, n_Comb);

    wb = waitbar(0,'PGR Brute Force');
    for i = 1 : n_Comb
        % Only updates a few times
        if mod(i,1000) == 0
            msg = sprintf('Computing PGR %d/%d',i,n_Comb);
            wb = waitbar(i/n_Comb,wb,msg); % waibar
        end

        combination(i).num = Comb(i,:);

        ccol = 1; crow = 1;

        for j = 1 : nc0 % Loop on the contact points
            if combination(i).num(j) == 1 % State 1
                Kis = diag([Kx(j),Ky(j),Kn(j)]);
                combination(i).flag1(j) = 1;
                
            elseif combination(i).num(j) == 2 % State 2
                % Kis = diag([0 0 Kn(j)]);
                Kis = Kn(j);
                combination(i).flag2(j) = 1;

            else % State 3
                %Kis = diag([0 0 0]);
                Kis = [];

                %%%%% ATTENTION: the detached contact points must be
                %%%%% removed accordingly to the initial configuration of the contact points.
                % SGremoveContact(hand,finger,link,alpha)
                % Remove
                [combination(i).hand, combination(i).object] = ...
                    SGremoveContact(combination(i).hand,combination(i).object,...
                    cp(4,j),cp(5,j),cp(6,j));

                combination(i).nc = combination(i).nc-1;
                combination(i).flag3(j) = 1; % In the j-th contact point in combination i, the contact j is detached
            end

            [rh,ch] = size(Kis);
            combination(i).K(crow:crow+rh-1, ccol:ccol+ch-1) = Kis; % N.B. Simplifying
            ccol = ccol + ch; 
            crow = crow + rh;
        end

        % There is no contact point on the object
        % PCR is zero and moves on to the next iteration
        if combination(i).nc == 0
            continue;
        end

        [combination(i).hand, combination(i).object] = SGmakeObject(...
            combination(i).hand,combination(i).object.center,combination(i).object.normals);

        combination(i).S = SelectionMatrix(combination(i));

        % combination(i).Ks = Ks;

        % Kp = ks*eye(combination(i).hand.m); % Decomment in case we want to consider a certain Kp
        % JS = combination(i).S'*combination(i).hand.J; % Decomment in case we want to consider a certain Kp
        % K = inv(inv(Ks)+JS*inv(Kp)*JS'); % Equivalent Contact Stiffness % Decomment in case we want to consider a certain Kp
        % combination(i).K = K; % Decomment in case we want to consider a certain Kp

        % combination(i).K = Ks; % N.B. Simplifying
        % hypothesis % Comment in case we want to consider a certain Kp

        % Multiplication of matrix G with S:
        if all(size(combination(i).S))
            % GS = combination(i).object.G*combination(i).S;
            % JS = combination(i).S'*combination(i).hand.J; % Comment in case we want to consider a certain Kp
            
            % Assign to G the new value GS
            combination(i).object.G = combination(i).object.G*combination(i).S;
            combination(i).hand.J = combination(i).S'*combination(i).hand.J; % Comment in case we want to consider a certain Kp

            % Check if the grasp is feasible
            kerKG = ker(combination(i).K*combination(i).object.G');
            if size(kerKG,2) == 1
                if kerKG == zeros(size(kerKG,1),1)
                    % Goes here if the combination satisfies the constraint ker(Ks*G') = 0
                    combination(i).object = SGcontactStiffness(combination(i).object,combination(i).K); % associate the global stiffness matrix to the object

                    Gkr = combination(i).object.Kc*combination(i).object.G'*inv(combination(i).object.G*combination(i).object.Kc*combination(i).object.G');

                    linMap = SGquasistaticMaps_PGR(combination(i).hand,combination(i).object); 

                    combination(i).E = ima(linMap.P); % basis for the controllable internal forces
                    ncont = size(combination(i).E,2);
                    y0 = 0.5*ones(ncont,1);

                    [~,cost_val] = fminsearch(...
                        @(y) SGVcost_PGR(w,y,Gkr,combination(i).E,combination(i).object.normals,mu,fmin,fmax,k,combination(i)),y0,option); % Search for the "best" y 

                    % combination(i).lambdaopt = combination(i).E*yopt;
                    % combination(i).yopt = yopt; % first return argument of fminsearch
                    quality_vector(i) = 1/cost_val;
                end
            end
        % else % Goes here when S is empty, i.e. when there isn't any contact
            % GS = combination(i).object.G;
        end
    end

    delete(wb); % Delete waitbar

    [PGR, I] = max(quality_vector);

    combopt(1,:) = combination(I).num; % Save the best state combination
end