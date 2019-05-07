%   VizzyHandModel
%
%    The function builds the Vizzy Hand Model
%
%    Usage: hand = VizzyHandModel
%
%    Returns:
%    hand = the Vizzy Hand Model
%
%   Author: Luís Almeida
%   Course: Master in Electrical and Computer Engineering
%   University: IST (Lisbon)

function newHand = VizzyHandModel(T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 -    VIZZY    H A N D    P A  R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pre-allocation
DHpars{4} = [];
base{4} = [];
F{4} = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thumb
 DHpars{1}=[ 
    pi/2 -22.5 0 0 ;            
    0 -33 0 0 ;         
    0 -28.48 0 0 ];          

base{1} = [   -0.2982    0.0799   -0.9512   17.5949
               0.9187   -0.2462   -0.3087  -54.2112
              -0.2588   -0.9659    0.0000   -4.5000
               0         0         0        1.0000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index
DHpars{2}=[
     0 -33 0 0 ;             % MCP joint (flexion/extention)
     0 -26.5 0 0 ;             % PIP joint (flexion/extention)
     0 -28.48 0 0];             % DIP joint (flexion/extention)
base{2} = [-0.9885    0.0000   -0.1513  121.4548
    0.1513    0.0000   -0.9885  -18.5950
    0.0000   -1.0000   -0.0000   -4.5000
         0         0         0    1.0000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Middle
DHpars{3}=[
    0 -33 0 0;         % MCP joint (flexion/extention)
    0 -26.5 0 0;         % PIP joint (flexion/extention)
    0 -28.48 0 0];        % DIP joint (flexion/extention)
base{3} = [ -0.9966   -0.0000    0.0829  126.2000
            -0.0829    0.0000   -0.9966   10.5000
            -0.0000   -1.0000   -0.0000   -4.5000
             0         0         0        1.0000];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Ring
DHpars{4}=[
    0 -33 0 0;         % MCP joint (flexion/extention)
    0 -26.5 0 0;         % PIP joint (flexion/extention)
    0 -28.48 0 0];        % DIP joint (flexion/extention)

base{4} = [   -0.9470   -0.0000    0.3213  120.6651
              -0.3213    0.0000   -0.9470   40.9395
              -0.0000   -1.0000   -0.0000   -4.5000
               0         0         0       1.0000];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(DHpars)
    % number of joints for each finger
    joints = size(DHpars{i},1);
    % initialize joint variables
    q = zeros(joints,1);
    % make the finger
     if (nargin == 1)
        F{i} = SGmakeFinger(DHpars{i},T*base{i},q);
    else
        F{i} = SGmakeFinger(DHpars{i},base{i},q);
    end
end

newHand = SGmakeHand(F);
newHand.type = 'VizzyHand';
