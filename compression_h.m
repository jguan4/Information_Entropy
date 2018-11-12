function com_h = compression_h(videoData, fras, n_ahead)
T=size(videoData,1);
com_h = zeros(T-fras*n_ahead,1);

for i = 1:T-fras*n_ahead
    com_hh = zeros(fras, 1);
    for j=0:fras-1
        A=squeeze(videoData(i+n_ahead*j,:,:));
        imwrite(A,'newImage.jpg','jpg');
        info = imfinfo('newImage.jpg');
        com_hh(j+1) = info.FileSize;
        delete('newImage.jpg')
    end
    com_h(i) = mean(com_hh);
end