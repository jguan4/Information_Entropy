% Take average over reg of m by n entries in A

function ave = mean_block(A,m,n)
row = size(A,1);
col = size(A,2);
if mod(row,m)~=0 || mod(col,n)~=0
    error('Dimension mismatched');
end

B=A';
ii = 1:(row*col/m);
inds_basis = ii+floor((ii-1)/col)*col;
m_r = 0:m-1;
m_r_incre = col*m_r'.*ones([m, row*col/m]);
inds = repmat(inds_basis,[m,1])+m_r_incre;
C=B(inds);
C=reshape(C,m,n,row*col/(m*n));
D=squeeze(mean(mean(C)))';
ave = reshape(D',col/n,row/m)';
