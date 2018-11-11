clear all;
format long;

path='E:\JJ Data\New Data\v_const\RawData';
savepath='E:\JJ Data\New Data\v_const\Result';
flist=dir(path);
mnum=size(flist,1)-2;

for m=1:2
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h.mat'));
    sizeT = length(space_yval);
    sizeP = length(P);
    P_resize = resample(P,sizeT,sizeP);
    time_h_ave = squeeze(mean(mean(time_yval,2),3));
    figure
    title(strcat(trial_stamp,time_stamp))
    subplot(3,1,1)
    plot(P);
    title('Power')
    subplot(3,1,2)
    plot(space_yval);
    xlim([0 555])
    title('Space h')
    subplot(3,1,3)
    plot(time_h_ave);
    xlim([0 555])
    title('Time h')
    saveas(gcf,strcat(savepath,'/',trial_stamp,time_stamp,'_power_h.fig'))
end