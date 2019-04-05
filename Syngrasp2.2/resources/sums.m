function Q = sums(A,B)
%SUMS     Sum of subspaces.
%  Q = sums(A,B) is an orthonormal basis for subspace im[A B] = imA + imB .

%  Basile and Marro 4-20-90

Q = ima([A B],0);
% --- last line of sums ---
