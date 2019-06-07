function [S] = SelectionMatrix(combination)

nc1=sum(combination.flag1);
nc2=sum(combination.flag2);
nc3=sum(combination.flag3);

N = nc1+nc2+nc3; % total number of contacts

S = zeros(size(combination.object.G,2), 3*nc1+nc2);
ccol=1; crow=1;
for j=1:N                   %Force selectors
    if combination.num(j)==2
        Si=[0 0 1]';
    elseif combination.num(j)==1
        Si=eye(3);
    else
        Si=[];
    end
    [rh,ch]=size(Si);
    S(crow:crow+rh-1, ccol:ccol+ch-1)=Si;
    ccol=ccol+ch; crow=crow+rh;
end