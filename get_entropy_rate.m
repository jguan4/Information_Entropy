function [h,E,L] = get_entropy_rate(H)

% Take the block entropies and calculate the entropy rate with differences.
% We assume that the correct entropy rate occurs when the block entropies
% have "leveled out", i.e. reached a plateau.
% We also get the history length L as a bonus! (needed to get EMC)
% Which means we also get EMC!

%% entropy rate from differences

[ddH,index] = sort(abs(diff(H,2)));
h = H(index(1)+1)-H(index(1));
if index(1) <= 2
    [value,index] = min(abs(diff(H(3:end),2)));
    index(1) = index(1)+2;
    h = H(index(1)+1)-H(index(1));
end


%% history length

L = index(1);

if L > 3
    
    %% Excess Entropy

    x = 1:length(H)-1;
    m = polyfit(x(1:L-1),log(diff(H(1:L))-h),1);

    F = m(1)*x(1:L-1) + m(2);
    ss_err = sum((log(diff(H(1:L))-h)-F).^2);
    ss_tot = sum((log(diff(H(1:L))-h)-mean(log(diff(H(1:L))-h))).^2);
    R = 1-(ss_err/ss_tot);

    if R < 0.9 || sum(abs(imag(m))) > 0 || abs(imag(R)) > 0
        E = sum(diff(H(1:L))-h);
    else
        % E = (-exp(m(2))/m(1))*exp(m(1));
        E = (H(2)-h)/(1-exp(m(1)));
    end

else

    E = sum(diff(H(1:L))-h);

end


