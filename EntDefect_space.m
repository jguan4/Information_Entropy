%function [H,h,E,L]=entIII(width)
% Calculate the block entropies H_L and then the entropy rate h and excess entropy E
% The units are in 'nats'.
%
% start with the data in a column or row vector (here called "pre_data")
% for continuous data we need to partition, so we need to choose 'ref' and 'width',
% where 'ref' determines a reference partition divider and 'width' is the size of the
% partitions. you can see what is going on in the .m file 'partition.m'.
%
% e.g. suppose we have some turbulence data with a maximum fluctuation value of 10 (in
% some units). if we choose ref = 3 (puts divider at mean value of data) and width > 10,
% then we are effectively binarizing the data (giving a -1 for data below mean and +1 for
% data above the mean).
%
% word_size_min should usually be 1 and word_size_max just needs to be big enough to see
% the asymptote of H_L vs. L so that we can determine the entropy rate/density h
%
% the program will give in the end the block entropies in H, the entropy rate h, excess
% entropy E and the value of L where the asymptote of H_L was found. It gives this using
% three different estimates of the block entropies: naive, miller and grassberger.
% i usually use the grassberger estimate which is the 4th sheet of H and the 3rd column of
% h, E and L.
%
% the program relies on the following additional MATLAB programs:
% partition.m, counts.m, entropy_miller.m, entropy_grassberger.m, get_entropy_rate.m

function yval=EntDefect_space(videoData,fras,inds,full)

clearvars -except newcom numd inds videoData fras
format long

width = 10; % size of partitions
ref = 3;    % partition wall/divider reference: 1 = min, 2 = max, 3 = mean,
% 4 = special reference: makes an alphabet of size 'width' with
% the mean as a reference

word_size_min = 1; % min word length
word_size_max = 9; % max word length

T=size(videoData,1);
Tt = size(inds,1);
X=size(videoData,2);
Y=size(videoData,3);
intvNum = 40;
intvSkip=1;
criteria = 10;

totalIntv=floor((Tt-intvNum)/intvSkip);
yval=zeros(1,totalIntv);

for intv=1:totalIntv
    prevIntv = (intv-1)*intvSkip+1;
    nextIntv = intv*intvSkip+intvNum;
    switch full
        case 1
            newcom=inds;
        case 0
            newcom=sum(inds(prevIntv:nextIntv, :, :),1);
            [ab,cd]=find(squeeze(newcom)>criteria);
            newcom(~ab,~cd)=0;
    end
    %     for s=1:size(ab) % sum up the indices or
    %         pp=ab(s);
    %         qq=cd(s);
    %         qjtrial2=squeeze(double(newcom(pp,qq,(intv-1)*intvSkip+1:intv*intvSkip+intvNum)));
    % newcom=imgaussfilt(reshape(newcom,[1 X*Y]));
    newcom=reshape(newcom,[1 X*Y]);
    rp6=newcom;
    pred=double(rp6);
    px=pred;
    lent=size(pred);
    prt=floor((lent/1.01));
    bb=lent/prt;
    lst=floor(bb);
    h = zeros(lst,1);
    E = zeros(lst,1);
    L = zeros(lst,1);
    
    for q=1:lst
        pxn=(px-mean(px))./(std(px));
        size(pxn);
        data = partition(pxn,width,ref);
        
        N = length(data);
        len=(word_size_max-word_size_min)+1;
        
        H=zeros(len+1,lst);
        for ind = 1:len
            L = word_size_min+ind-1;
            n = counts(data,L);
            % p = n/sum(n);
            % H(1,ind+1,q) = -sum(p.*log(p)); % naive entropy estimate
            % [H(2,ind+1,q),H(3,ind+1,q)] = entropy_miller(n,N); % Miller-Madow estimate + "error"
            H(ind+1,q) = entropy_grassberger(n,N); % Grassberger estimate
            
        end
        
        %% calculate entropy rate from block entropies
        
        
        %  [h(q,1),E(q,1),L(q,1)] = get_entropy_rate(H(1,:,q));
        %  [h(q,2),E(q,2),L(q,2)] = get_entropy_rate(H(2,:,q));
        [h(q),E(q),L(q)] = get_entropy_rate(H(:,q)');
        
    end
    newarray=diff(H');
    diffarray = diff(newarray(1,1:7));
    mindiff = min(abs(diffarray));
    
    wl = find(abs(diffarray)== mindiff);
    wordlen = wl+1;
    
    yval(1,intv)=newarray(wordlen);
end
