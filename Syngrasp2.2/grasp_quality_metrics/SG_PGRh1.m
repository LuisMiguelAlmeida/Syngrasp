%   Heuristic1PGR_paper - evaluates the PGR and PCR quality measures for a
%   given grasp using the heuristic 1 reported in the paper
%   "On Grasp Quality Measures: Grasp Robustness and Contact Force 
%   Distribution in Underactuated and Compliant Robotic Hands."
%
%    Usage: [PGR PCR combopt]=Heuristic1PGR_paper(hand0, a)
%    Arguments:
%    hand0 = the hand structure in the initial grasp configuration
%    a = vector that define the positions of the contact points on each
%    link of hand0 
%
%    Returns:
%    PGR = The PGR quality index
%    PCR = The PCR quality index
%    combopt = matrix with the optimal combinations for each number of
%    engaged synergies
%
%    References:
%    M. Pozzi, M. Malvezzi, D. Prattichizzo. 
%    On Grasp Quality Measures: Grasp Robustness and Contact Force 
%    Distribution in Underactuated and Compliant Robotic Hands. 
%    IEEE Robotics and Automation Letters, 2(1):329-336, January 2017.

function [PGR, PCR, combopt]=SG_PGRh1(hand0,object0)

if(nargin ~=2)
    error('To evaluate the PGR it is need a structure for the hand and another for the object');
end

nc0=size(hand0.cp,2); % initial number of contact points

cp = hand0.cp; % auxiliary cp vector

% Stiffness at the contacts
ks=1;

Kx=ks*ones(nc0,1);
Ky=ks*ones(nc0,1);
Kn=ks*ones(nc0,1);

%K0=ks*eye(3*nc0,3*nc0);

% Contact properties and optimization parameters
mu = 0.8;
%alpha = 1/sqrt(1+mu^2);
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
[yoptB,cost_val] = fminsearch(@(y) SGVcostPCR(w,y,pinv(object0.G),E,object0.normals,mu, fmin,fmax,k),y0,option); % I search for the 'best' y

PCR = 1/cost_val; % Potential contact robustness

%%% HEURISTIC 1
% 1. Preload of contact forces:
lambda0 = E*yoptB;
eps=1; % In degrees % eps=5 for 10 contacts
nc_comb=nc0;
flag=zeros(1,nc0);

% 2. Check if the contact forces are close to the friction cone or not
for i=1:nc0
    lambda0i=lambda0(3*i-2:3*i);
    alphai=acos(lambda0i'*object0.normals(:,i)/norm(lambda0i))*180/pi;
    phi=atan(mu)*180/pi;
    if alphai<eps % lost contact 
        nc_comb=nc_comb-1;
        flag(i)=2; 
    elseif  phi-alphai<eps % contact too close or out of the friction cone
        nc_comb=nc_comb-1;
        flag(i)=1; % The i-th contact is in state 2
    end
end
% 3. Define the combinations of the three states that must be
% considered

Comb=permn([1 2 3],nc_comb);
n_Comb = size(Comb,1); % Number of combinations


% Pre-allocation of quality_vector
quality_vector = zeros(1, n_Comb);

% Pre-allocation of one matrix where each column represents the state that
% the contact point is and each line represents one combination possible.
cp_states = zeros(n_Comb,nc0);

for i=1:n_Comb
    j = 1;
    for h=1:nc0 % Loop on the contact points
            if flag(h)==0
                cp_states(i,h) = Comb(i,j);
                j = j+1;
            else
                cp_states(i,h) = 2;
            end
    end   
end

%%% HEURISTIC 2: among the considered combinations, I put also the
%%% optimal combination found in the previus step. 
%     if isyn>1
%         combination(size(Comb,1)+1).num=combMat(isyn-1,:)
%     end
%     
%%% HEURISTIC 3: among the considered combinations, I put also all the
%%% optimal combinations found in the previus steps. 
%     if isyn>1
%         for isynprec=1:isyn-1
%             combination(size(Comb,1)+isynprec).num=combMat(isyn-isynprec,:);
%         end
%     end
%     

for i=1:n_Comb
    
    ccol=1; crow=1; Ks=[];

    % Pre-allocating memory: Speeds problem
    combination = ...
        struct('num',cp_states(i,:),'nc',nc0,'hand',hand0,'object',object0,...
        'flag1',zeros(1,nc0),'flag2',zeros(1,nc0),'flag3',zeros(1,nc0),'yopt',[]);
    for j = 1:nc0  %% Loop on the contact points

            if (combination.num(j)==1)     % State 1
                Kis=diag([Kx(j), Ky(j),Kn(j)]);
                combination.flag1(j)=1;

            elseif (combination.num(j)==2) % State 2
               % Kis=diag([0 0 Kn(j)]);
               Kis=Kn(j);
               combination.flag2(j)=1;

            else                  % State 3
                %Kis=diag([0 0 0]);
                Kis=[];

                %%%%% ATTENTION: the detached contact points must be
                %%%%% removed accordingly to the initial configuration of the contact points.
                %SGremoveContact(hand,finger,link,alpha)
                % Remove
                [combination.hand, combination.object] = SGremoveContact(combination.hand,combination.object, cp(4,j),cp(5,j),cp(6,j));

                combination.nc=combination.nc-1;
                %combination.flag3(j)=1; % In the j-th comnella comb i, il contatto j si stacca
            end
            [rh,ch]=size(Kis);
            Ks(crow:crow+rh-1, ccol:ccol+ch-1)=Kis;
            ccol=ccol+ch; 
            crow=crow+rh;

    end

    % There is no contact point on the object
    % PCR is zero and moves on to the next iteration
    if(combination.nc == 0)
        continue;
    end
    [combination.hand, combination.object] = SGmakeObject(combination.hand,combination.object.center,combination.object.normals);

    combination.S=SelectionMatrix(combination);

    combination.K=Ks;  % N.B. Simplifying hypothesis

    % K=inv(inv(Ks)+J*inv(Kp)*J'); % Equivalent Contact Stiffness

    % Multiplication of matrix G with S:
    if all(size(combination.S))
        combination.object.G = combination.object.G*combination.S; % GS
        combination.hand.J = combination.S'*combination.hand.J; % JS

        % Check if the grasp is feasible
        kerKG=ker(combination.K*combination.object.G');
        if size(kerKG,2)==1
            if  kerKG==zeros(size(kerKG,1),1)
                combination.object = SGcontactStiffness(combination.object,combination.K); % associate the global stiffness matrix to the object

                Gkr=combination.object.Kc*combination.object.G'*inv(combination.object.G*combination.object.Kc*combination.object.G');

                linMap = SGquasistaticMaps_PGR(combination.hand,combination.object); 

                combination.E = ima(linMap.P); % basis for the controllable internal forces
                ncont = size(combination.E,2);
                y0 = 0.5*ones(ncont,1);

                [~,cost_val] = fminsearch(@(y) SGVcost_PGR(w,y,Gkr,combination.E,combination.object.normals,mu,fmin,fmax,k,combination),y0,option); % I search for the "best" y 

                quality_vector(i)=1/cost_val;
                %combination.yopt=yopt;
            end
        end
    % else % Goes here when S is empty, i.e. when there isn't any contact
        %GS=combination.object.G; 
        
    end

end
    
[PGR, I]=max(quality_vector);

combopt(1,:)=cp_states(I,:); % Save combinations 


%sim_time=toc;
% save 'time_10_h1' sim_time

% PLOTS

% [h, o]=SGmakeObject(hand0);
% figure
% SGplotHand(h)
% hold on
% SGplotObject(o)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% title('Initial Grasp');

end

