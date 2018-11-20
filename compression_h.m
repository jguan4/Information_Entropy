function com_h = compression_h(videoData, fras, n_ahead)
T=size(videoData,1);
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