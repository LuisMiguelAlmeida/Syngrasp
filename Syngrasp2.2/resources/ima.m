function Q = ima(A,p)
%IMA      Orthogonalization.
%  Q=ima(A) is an orthonormal basis for imA. If called as Q=ima(A,p) with
%  p=1 permutations are allowed, while with p=0 they are not.

%  Basile and Marro 4-20-90 (modified for Matlab 5: 5-22-97)

nargs=nargin;
error(nargchk(1,2,nargs));
if (nargs==1)
  p=1;
end
tol=eps*norm(A,'fro')*10^6;
[ma,na]=size(A);
if (p==1)
[Q,R,E]=qr(A);
  if (na==1)|(ma==1)
    d=R(1,1);
  else
    d=diag(R);
  end
  d=(abs(d))';
  nul=find(d>tol);
  r=length(nul>0);
  if (r>0)
    Q=Q(:,nul);
  else
    Q=zeros(ma,1);
  end
else
  ki=1;
  A1=A;
  while (ki==1)
    [ma,na]=size(A1);
    punt=1:na;
    [Q,R]=qr(A1);
    if (na==1)|(ma==1)
      d=R(1,1);
    else
      d=diag(R);
    end
    d=(abs(d))';
    nul=find(d<=tol);
    n=min(nul);
    if ~isempty(n), punt=find(punt~=n); end
    if (isempty(nul))|(isempty(punt))
      ki=0;
    else
      A1=A1(:,punt);
    end
  end
  if (~isempty(n))&(isempty(punt))
    Q=zeros(ma,1);
  else
    r=length(d);
    if (r>0)
      Q=Q(:,1:r);
      Q=-Q;
      Q(:,r)=-Q(:,r);
    end
  end
end
% --- last line of ima ---
