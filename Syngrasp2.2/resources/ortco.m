function Q = ortco(A)
%ORTCO    Complementary orthogonalization.
%  Q=ortco(A) is an orthonormal basis for the orthogonal complement of imA .

%  Basile and Marro 4-20-90

[ma,na] = size(A);
if norm(A,'fro')<10^(-10), Q = eye(ma); return, end
[ma,na] = size(ima(A,1));
RR = ima([A/norm(A,'fro'),eye(ma)],0);
Q = RR(:,na+1:ma);
if isempty(Q)
  Q = zeros(ma,1);
end
% --- last line of ortco ---
