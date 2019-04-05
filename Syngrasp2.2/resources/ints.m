function Q = ints(A,B)
%INTS     Intersection of subspaces.
%  Q = ints(A,B) is an orthonormal basis for the subspace (imA) intersection (imB) .

%  Basile and Marro 4-20-90

mm= ' **** WARNING: a matrix is empty in INTS';
if (isempty(A))&(isempty(B)), error(' empty matrices in INTS'), end
if isempty(A), A=zeros(size(B,1),1); disp(mm), end
if isempty(B), B=zeros(size(A,1),1); disp(mm), end
Q = ortco(sums(ortco(A),ortco(B)));
% --- last line of ints
