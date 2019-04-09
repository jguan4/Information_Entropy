function n = counts(data,L)

% get the counts for all the different words that exist

% N = length(data);
% 
% string = zeros(N-(L-1),L);

N = size(data,1);
num_data = size(data,2);

% string = zeros(num_data,N-(L-1),L);

location = ones(N-L+1,L);
location(1,:) = cumsum(location(1,:));
location = cumsum(location,1); 
Lrange = 1:L;

% the rows of the matrix 'location' are sliding indices of the strings

string = data(location,:); 
string_r = reshape(string,N-L+1,L,num_data);
string_rw = Lrange.*string_r;
string_r_sum = squeeze(sum(string_rw,2));
[A,~,J]=unique(string_r_sum);
J_r = reshape(J,N-L+1,num_data);

n = zeros(length(A),num_data);
for i=1:length(A)
    n(i,:) = sum((J_r-i)==0);
end

% a = size(string);
% if a(1) < a(2)
%     string = string';
% end

% [A,I,J] = unique(string,'rows');
% n = accumarray(J,1);
