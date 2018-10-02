function [H,H_var] = entropy_miller(n,N)

% Entropy estimate with first order fix to undersampling bias based on:
% Miller, G. (1955) "Note on the bias of information estimates",
% Information Theory in Psychology II-Bed H Quastler (Glencoe, IL: Free Press) pp 95?100

H = -sum((n/N).*log(n/N) + ((n-1)/(2*N)));
H_var = (1/N^2)*sum(((log(n/N)+H).^2).*(n.*(1-(n/N))));
