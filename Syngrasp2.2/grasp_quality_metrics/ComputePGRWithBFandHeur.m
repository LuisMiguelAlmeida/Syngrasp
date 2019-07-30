%   ComputePGRWithBFandHeur - computes the PGR quality for a given
%   method(s) (such Brute Force, H1, H2, H3, H4)
%  
%
%    Usage: PGR = ComputePGRWithBFandHeur(hand, obj, 'BF', 'H2')
%    Arguments:
%    hand = the hand structure 
%    obj = the object structure
%    'BF' = Brute force method to compute PGR
%    'H1' = Heuristic 1 method to compute PGR
%    'H2' = Heuristic 2 
%    'H3' = Heuristic 3
%    'H4' = Heuristic 4 
%    Returns:
%    PGR = The PGR quality index
%    PCR = The PCR quality index
%    combopt = matrix with the optimal combinations for each number of
%    engaged synergies
function PGR = ComputePGRWithBFandHeur(varargin)

    if nargin <3
        str = 'You should give a hand, an object, and heuristic that you want to compute the PGR quality \n';
        str = [str, 'Example: PGR = ComputePGRWithBFandHeur(hand, obj, ''BF'', ''H2'')'];
        error(sprintf(str));
    end
    
    hand = varargin{1};
    obj = varargin{2};
    
    if ~isstring(varargin{3})
        PGR_types = char(varargin{3:nargin});
    else
        PGR_types =[varargin{3:nargin}]';
    end
    
    for i = 1 : size(PGR_types,1)
        switch PGR_types(i,:)
            case 'BF'
                PGR.BF = SG_PGRbruteforce(hand, obj);
                
            case 'H1'
                PGR.H1 = SG_PGRh1(hand, obj);
                
            case 'H2'
                PGR.H2 = SG_PGRh2(hand, obj,3);
                                
            case 'H3'
                PGR.H3 = SG_PGRh3(hand, obj,3);
                
            case 'H4'
                PGR.H4 = SG_PGRh4(hand, obj);
                
            case 'PCR'
                PGR.PCR = SG_PCR(hand, obj);
            otherwise
                error('Some method name is wrong! Pls check the function syntax!');
        end
    end

end

