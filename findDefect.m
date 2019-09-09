function [inds]=findDefect(videoData, fras,n_ahead)
% get dimention
T=size(videoData,1);
X=size(videoData,2);
Y=size(videoData,3);
inds=zeros(T-fras*n_ahead,X,Y,'int8');

for i=1:T-(fras-1)*n_ahead
    % take mean and std
    windowstd=squeeze(std(double(videoData(i:n_ahead:(i+n_ahead*(fras-1)),:,:)),0,1));
    windowmean=squeeze(mean(double(videoData(i:n_ahead:(i+n_ahead*(fras-1)),:,:)),1));
    
    % demean
    window_scaled=windowstd./windowmean;
    
    % take average of demeaned data
    wsmean=mean2(window_scaled);
    wsstd=std2(window_scaled);
    
    % if more than two std change, consider it a flickering
    [rowi,coli]=find(window_scaled>(wsmean+wsstd*2));
    lin_ind=sub2ind([X, Y],rowi,coli);
    inds(i,lin_ind) = 1;
    clear windowstd windowmean window_scaled wsmean wsstd rowi coli lin_ind
end

% totalIntv=(T-fras-intvNum)/intvSkip;
% newInds=zeros(totalIntv,X,Y);
% 
% for intv=1:totalIntv
%     prevIntv = (intv-1)*intvSkip+1;
%     nextIntv = intv*intvSkip+intvNum;
%     [ab,cd]=find(sum(inds(prevIntv:nextIntv,:,:),1)>10);
%     newInd=zeros(X,Y);
%     for j=1:size(ab)
%         newInd(ab(j),cd(j))=1;
%     end
%     newInds(intv,:,:)=newInd;
% end