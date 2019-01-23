function data = partition(u,width,ref)

% partition the data
% u1 = data
% width is the size of the partition
% ref determines whether one starts the alphabet at the bottom or...
% 1 = min, 2 = max, 3 = middle
% ref = 4 means make an alphabet of even size 'width'

%% find the range of data values and number of partitions

mindata = min(u);
maxdata = max(u);

n = ceil((maxdata-mindata)/width); % round up

%% assign symbols to data according to partition (0 to n-1)

data = zeros(size(u));

if ref == 1

    for i = 1:n-1

        % we'll be reassigning values but that doesn't matter
        I = find(u >= mindata+i*width);
        data(I) = i;

    end
    
elseif ref == 2
    
    for i = 1:n-1
        
        I = find(u <= maxdata-i*width);
        data(I) = i;
        
    end
    
elseif ref == 3
   
    u = u - mean(u);
    
    i = 1;
    ind1 = 1;
    while ind1 > 0
        
        I = find(u >= (i-1)*width);
        if isempty(I)
            ind1 = 0;
            continue;
        else
            data(I) = i;
        end
        
        i = i + 1;
        
    end
    
    i = 1;
    ind2 = 1;
    while ind2 > 0
        
        I = find(u <= -(i-1)*width);
        if isempty(I)
            ind2 = 0;
            continue;
        else
            data(I) = -i;
        end
        
        i = i + 1;
        
    end
            
elseif ref == 4
    
    if rem(width,2) == 0

        u = u - mean(u);
        cutoff = max(u)/(width/2);

        for i = 1:(width/2)
            if i < (width/2)
                % above
                I = find(u < i*cutoff & u >= (i-1)*cutoff);
                data(I) = i;
                % below
                I = find(u >= -i*cutoff & u < -(i-1)*cutoff);
                data(I) = -i;
            else
                % above
                I = find(u >= (i-1)*cutoff);
                data(I) = i;
                % below
                I = find(u < -(i-1)*cutoff);
                data(I) = -i;
            end
        end
        
    elseif rem(width,2) == 1
        
        u = u - mean(u);
        cutoff = max(u)/width;
        
        for i = 1:width-2
            % above
            I = find(u >= cutoff*((i-1)*width+1));
            data(I) = i;
            % below
            I = find(u <= -cutoff*((i-1)*width+1));
            data(I) = -i;
        end
        
    end
        
end
