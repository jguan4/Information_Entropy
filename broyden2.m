function x=broyden2(f,x0)
[n,m]=size(x0);
b=eye(n,n); % initial b
tol = 1e-10;
error = 1;
while error > tol
    x=x0-b*f(x0);
    del=x-x0;
    delta=f(x)-f(x0);
    b=b+(del-b*delta)*del'*b/(del'*b*delta);
    error = norm(x-x0);
    x0=x;
end