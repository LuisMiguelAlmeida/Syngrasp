%   BruteForcePGR - evaluates the PGR and PCR quality measures for a
%   given grasp
%
%    Usage: [PGR PCR combopt]=BruteForcePGR(hand0, a, Combinazioni)
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

function [PGR, PCR, combopt]=BruteForcePGR(hand0, a, Combinazioni)
 nc0=size(hand0.cp,2); % initial number of contact points
if (nargin < 2) || (nargin > 3)
  error('BruteForcePGR requires exactly 2 or 3 arguments')
elseif (nargin == 2) 
  % a single list of points as rows of xyz
  Comb=permn([1 2 3],nc0); 
elseif (nargin == 3)
  Comb=Combinazioni;
else
  % none of the forms I allow seem to fit.
  % give up and throw an error.
  error('The arguments do not seem to fit into any of the allowed forms for input')
end

for isyn=1:15
    
    display(isyn);
    quality_vector=[];
    
    % Definition of the hand synergies
    [qm, Syn] = SGsantelloSynergies; % Load Santello's synergies
    hand0 = SGdefineSynergies(hand0,Syn(:,1:isyn),qm);
    hand0 = SGmoveHand(hand0,qm); 
    
    %nc0=size(hand0.cp,2); % initial number of contact points

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

    [hand0, object0]=SGmakeObject(hand0);

    linMaps = SGquasistaticMaps(hand0,object0);
    E = ima(linMaps.P); % basis for the controllable internal forces
    ncont = size(E,2);

    y0 = 100*ones(ncont,1); 
    [yoptB, cost_val] = fminsearch(@(y) SGVcostPCR(w,y,pinv(object0.G),E,object0.normals,mu, fmin,fmax,k),y0,option); % I search for the 'best' y

    PCR(isyn) = 1/cost_val; % Potential contact robustness
   
%     Comb=permn([1 2 3],nc0); 
    for i=1:size(Comb,1)
        combinazione(i).num=Comb(i,:); 
        combinazione(i).nc=nc0;
        combinazione(i).hand=hand0;
        
        % Initialization
        combinazione(i).flag1=zeros(1,nc0);  % Vector that traces the contacts in state 1
        combinazione(i).flag2=zeros(1,nc0);  % Vector that traces the contacts in state 2
        combinazione(i).flag3=zeros(1,nc0);  % Vector that traces the contacts in state 3

        ccol=1; crow=1; Ks=[];

        for j = 1:nc0  %% Loop on the contact points

                if (combinazione(i).num(j)==1)     % State 1
                    Kis=diag([Kx(j), Ky(j),Kn(j)]);
                    combinazione(i).flag1(j)=1;

                elseif (combinazione(i).num(j)==2) % State 2
                   % Kis=diag([0 0 Kn(j)]);
                   Kis=Kn(j);
                   combinazione(i).flag2(j)=1;

                else                  % State 3
                    %Kis=diag([0 0 0]);
                    Kis=[];
                    
                    %%%%% ATTENTION: the detached contact points must be
                    %%%%% removed accordingly to the initial configuration of the contact points.
                 
                    % Case with nc=15:
                    if nc0==15
                        if (j>=1 && j<=5) % Contacts on the proximal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,2,a(j));
                        elseif (j>=6 && j<=10) % Contacts on the distal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-5,3,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-10,4,a(j));
                        end
                    % Case with nc=9:    
                    elseif nc0==9
                        if (j>=1 && j<=3) % Contacts on the proximal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,2,a(j));
                        elseif (j>=4 && j<=6) % Contacts on the distal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-3,3,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-6,4,a(j));
                        end
                    % Case with nc=10: 
                    elseif nc0==10
                        if (j>=1 && j<=5) % Contacts on the proximal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,2,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-5,4,a(j+5));
                        end
                     % Case with nc=6:    
                     elseif nc0==6                    
                        if (j>=1 && j<=3) % Contacts on the distal phalanges 
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,3,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-3,4,a(j));
                        end
                     % Case with nc=7:   
                     elseif nc0==7                      
                        if(j==1)
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j+1,2,a(j));
                        elseif (j>=2 && j<=3) % Contacts on the distal phalanges 
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-1,3,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-4,4,a(j));
                        end
                    % Case of contacts only on the Fingertips:
                    elseif (nc0==3 || nc0==4 || nc0==5)                     
                     combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,4,a(j));
                    % Case with nc=12:
                    elseif nc0==12
                        if (j>=1 && j<=4) % Contacts on the proximal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,2,a(j));
                        elseif (j>=5 && j<=8) % Contacts on the distal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-4,3,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-8,4,a(j));
                        end
                    % Case with nc=8:    
                    elseif nc0==8                    
                        if (j>=1 && j<=4) % Contacts on the proximal phalanges
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j,2,a(j));
                        else % Contacts on the fingertips
                             combinazione(i).hand = SGremoveContact(combinazione(i).hand,j-4,4,a(j+5));
                        end
                    else
                        error('Unexpected number of contacts points')
                    end
                     combinazione(i).nc=combinazione(i).nc-1;
                     combinazione(i).flag3(j)=1; % In the j-th comnella comb i, il contatto j si stacca
                end
                [rh,ch]=size(Kis);
                Ks(crow:crow+rh-1, ccol:ccol+ch-1)=Kis;
                ccol=ccol+ch; 
                crow=crow+rh;

        end

        [combinazione(i).hand, combinazione(i).object] = SGmakeObject(combinazione(i).hand);

        combinazione(i).S=SelectionMatrix(combinazione(i));

        combinazione(i).Ks=Ks;
        
        %Kp=ks*eye(combinazione(i).hand.m); % Decomment in case we want to consider a certain Kp
        %JS=combinazione(i).S'*combinazione(i).hand.J; % Decomment in case we want to consider a certain Kp
        %K=inv(inv(Ks)+JS*inv(Kp)*JS'); % Equivalent Contact Stiffness % Decomment in case we want to consider a certain Kp
        %combinazione(i).K=K; % Decomment in case we want to consider a certain Kp
        
        combinazione(i).K=combinazione(i).Ks; % N.B. Simplifying
%         hypothesis % Comment in case we want to consider a certain Kp
        
        % Multiplication of matrix G with S:
        if all(size(combinazione(i).S))
            GS=combinazione(i).object.G*combinazione(i).S;
            JS=combinazione(i).S'*combinazione(i).hand.J; % Comment in case we want to consider a certain Kp
             
            % Assign to G the new value GS
            combinazione(i).object.G=[];
            combinazione(i).object.G=GS;
            combinazione(i).hand.J=JS;
            
            % Check if the grasp is feasible
            kerKG=ker(combinazione(i).K*combinazione(i).object.G');
            if size(kerKG,2)==1
                if  kerKG==zeros(size(kerKG,1),1)
                    combinazione(i).ok=1;
                else
                    combinazione(i).ok=0;
                end
            else
                combinazione(i).ok=0;
            end
        else % Goes here when S is empty, i.e. when there isn't any contact
            GS=combinazione(i).object.G; 
            combinazione(i).ok=0;
        end

        if combinazione(i).ok==1 % Goes here if the combination satisfies the constraint ker(Ks*G')=0

            combinazione(i).object = SGcontactStiffness(combinazione(i).object,combinazione(i).K); % associate the global stiffness matrix to the object

            Gkr=combinazione(i).object.Kc*combinazione(i).object.G'*inv(combinazione(i).object.G*combinazione(i).object.Kc*combinazione(i).object.G');

            linMap = SGquasistaticMaps_PGR(combinazione(i).hand,combinazione(i).object); 

            combinazione(i).E = ima(linMap.P); % basis for the controllable internal forces
            ncont = size(combinazione(i).E,2);
            y0 = 0.5*ones(ncont,1);
     
            [yopt,cost_val] = fminsearch(@(y) SGVcost_PGR(w,y,Gkr,combinazione(i).E,combinazione(i).object.normals,mu,fmin,fmax,k,combinazione(i)),y0,option); % I search for the "best" y 

            combinazione(i).quality=1/cost_val;
            combinazione(i).yopt=yopt;
            combinazione(i).lambdaopt=combinazione(i).E*yopt;
        else 
            combinazione(i).quality=0;
            combinazione(i).yopt=[];
        end
        quality_vector(i)=combinazione(i).quality;

    end
    
[PGR(isyn), I]=max(quality_vector)

combopt(isyn,:)=combinazione(I).num; % Memorizzo le combinazioni
end
end

