clear all;
format long;

path='D:\Documents\GMU\Research\Entropy Project\New Data\V1_0';
flist=dir(path);
mnum=size(flist,1)-2;

for m=1:mnum
    load(strcat(path,'\',flist(m+2).name))
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    videoData = images;
    tic
    space_yval=EntDefect_space(videoData);
    save(strcat(path,'\',flist(m+2).name, '_space_h.mat'),'space_yval');
    fprintf(strcat('for calculating space h of  ',flist(m+2).name,'\n'))
    toc
    time_yval = EntDefect_time(videoData);
    save(strcat(path,'\',flist(m+2).name, '_time_h.mat'),'time_yval');
    fprintf(strcat('for calculating time h of  ',flist(m+2).name,'\n'))
    toc
end