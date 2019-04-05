function Sc = scale_matrix(k)

    I = eye(3,3);
    Sc = zeros(7,7);
    
    Sc = [k*I zeros(3,3) [0,0,0]'; zeros(3,3) I [0,0,0]'; [0,0,0] [0,0,0] 1];
    
    

end