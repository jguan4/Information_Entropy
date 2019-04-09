function H = entropy_grassberger(n,N);

% Entropy estimate with bias correction due to Grassberger:
% Grassberger, P. (1955) "Note on the bias of information estimates",
% Information Theory in Psychology II-Bed H Quastler (Glencoe, IL: Free Press) pp 95?100
% with a "correction" from
% Schurmann, T., and Grassberger, P. "Entropy estimation of symbol
% sequences", Chaos 6 (1996)
%
%

H = nansum((n/N).* (log(N) - psi(0,n) - real((-1).^(n).*(1./n).*(1./(n+1)))));
