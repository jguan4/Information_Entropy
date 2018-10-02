function n = counts(data,L)

% get the counts for all the different words that exist

N = length(data);

string = zeros(N-(L-1),L);

location = ones(N-L+1,L);
location(1,:) = cumsum(location(1,:));
location = cumsum(location,1); 


% the rows of the matrix 'location' are sliding indices of the strings

string = data(location); 

a = size(string);
if a(1) < a(2)
    string = string';
end

[A,I,J] = unique(string,'rows');


n = accumarray(J,1);
