function H = SGtransl (P)

%returns the homogeneous transformation matrix translation by P

%if (length(P)~=3)
%   error('invalid input arguments; input vector must belong to R3')
%end

if (size(P,1)==1)
    H = [eye(3) P'; zeros(1,3) 1];
else if (size(P,2)==1)
        H = [eye(3) P ; zeros(1,3) 1];
    end
end

end