function [inds]=findDefect(videoData, fras)
T=size(videoData,1);
X=size(videoData,2);
Y=size(videoData,3);
inds=zeros(T-fras,X,Y);

for i=1:T-fras
    ind=zeros(X,Y);
    windowstd=squeeze(std(double(videoData(i:(i+fras),:,:)),0,1));
    windowmean=squeeze(mean(double(videoData(i:(i+fras),:,:)),1));
    window_scaled=windowstd./windowmean;
    wsmean=mean2(window_scaled);
    wsstd=std2(window_scaled);
    [rowi,coli]=find(window_scaled>(wsmean+wsstd*2));
    for j=1:size(rowi)
        ind(rowi(j),coli(j))=1;
    end
    inds(i,:,:)=ind;
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