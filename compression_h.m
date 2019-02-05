function com_h = compression_h(videoData, fras, n_ahead, space_inds, full)
T=size(videoData,1);
Tt = size(space_inds,1);
intvNum = 1;
intvSkip=1;
criteria = 10;

totalIntv=floor((Tt-intvNum)/intvSkip);
com_h = zeros(totalIntv,1);
switch full
    case 1
        for intv=1:totalIntv
            prevIntv = (intv-1)*intvSkip+1;
            nextIntv = intv*intvSkip+intvNum-1;
            %             newcom=squeeze(sum(space_inds(prevIntv:nextIntv, :, :),1));
            newcom = squeeze(videoData(prevIntv:nextIntv, :, :));
            wcompress('c',newcom,'newImage.wtc','ezw');
            f=dir('newImage.wtc');
            com_h(intv) =f.bytes;
            delete('newImage.wtc')
        end
    case 0
        for intv=1:totalIntv
            prevIntv = (intv-1)*intvSkip+1;
            nextIntv = intv*intvSkip+intvNum;
            newcom=squeeze(sum(space_inds(prevIntv:nextIntv, :, :),1));
            [ab,cd]=find(newcom>criteria);
            lin_ind=sub2ind(size(newcom),ab,cd);
            coms=zeros(size(newcom));
            coms(lin_ind)=newcom(lin_ind);
            wcompress('c',coms,'newImage.wtc','ezw');
            f=dir('newImage.wtc');
            com_h(intv) =f.bytes;
            delete('newImage.wtc')
        end
end


