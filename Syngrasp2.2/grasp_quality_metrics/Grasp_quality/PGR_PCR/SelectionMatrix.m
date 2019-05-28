function [S] = SelectionMatrix(combinazione)

nc1=sum(combinazione.flag1);
nc2=sum(combinazione.flag2);
nc3=sum(combinazione.flag3);

N = nc1+nc2+nc3; % total number of contacts

S = zeros(size(combinazione.object.G,2), 3*nc1+nc2);
ccol=1; crow=1;
for j=1:N                   %Force selectors
    if combinazione.num(j)==2
        Si=[0 0 1]';
    elseif combinazione.num(j)==1
        Si=eye(3);
    else
        Si=[];
    end
    [rh,ch]=size(Si);
    S(crow:crow+rh-1, ccol:ccol+ch-1)=Si;
    ccol=ccol+ch; crow=crow+rh;
end