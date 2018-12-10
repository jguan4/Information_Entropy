function com_h = compression_h(videoData, fras, n_ahead, space_inds, pic)
T=size(videoData,1);
intvNum = 40;
intvSkip=1;
criteria = 10;

switch pic
    case 1
        com_h = zeros(T-fras*n_ahead,1);
        for i = 1:T-(fras-1)*n_ahead
            com_hh = zeros(fras, 1);
            for j=0:fras-1
                A=squeeze(double(videoData(i+n_ahead*j,:,:)));
                wcompress('c',A,'newImage.wtc','ezw');
                f=dir('newImage.wtc');
                com_hh(j+1) =f.bytes;
                delete('newImage.wtc')
            end
            com_h(i) = mean(com_hh);
        end
    case 0
        totalIntv=floor((Tt-intvNum)/intvSkip);
        com_h = zeros(totalIntv,1);
        for intv=1:totalIntv
            prevIntv = (intv-1)*intvSkip+1;
            nextIntv = intv*intvSkip+intvNum;
            [ab,cd]=find(squeeze(sum(space_inds(prevIntv:nextIntv, :, :),1))>criteria);
            newcom=sum(space_inds(prevIntv:nextIntv, :, :),1);
            newcom(~ab,~cd)=0;
            wcompress('c',newcom,'newImage.wtc','ezw');
            f=dir('newImage.wtc');
            com_h(intv) =f.bytes;
            delete('newImage.wtc')
        end
end


