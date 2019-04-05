function Q = ker(A)
%KER      Kernel of a matrix.
%  Q=ker(A) is an orthonormal basis for kerA.

%  Basile and Marro 6-20-90

Q = ortco(A');
% --- last line of ker ---
