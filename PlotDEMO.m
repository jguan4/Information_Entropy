clear all;
format long;

path='E:\JJ Data\New Data\v_const\RawData';
savepath='E:\JJ Data\New Data\v_const\Result';
flist=dir(path);
mnum=size(flist,1)-2;
time_n_ahead = 1;
space_n_ahead = 1;

a = 1;
n_average = 3000;
b = ones([1,n_average])/n_average;

for m=1:5
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP_',num2str(1),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_',num2str(space_n_ahead),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_',num2str(space_n_ahead),'.mat'));
    sizeT = length(space_yval);
    sizeP = length(P);
    sizeInd = size(time_yval,1);
%     P_resize = resample(P,sizeT,sizeP);
    P_filter = filter(b,a,P);
    time_h_ave = squeeze(mean(mean(time_yval,2),3));
    figure
    title(strcat(trial_stamp,time_stamp))
    subplot(4,1,1)
    plot(P_filter);
    title('Power')
    subplot(4,1,2)
    plot(space_yval);
    xlim([0 sizeInd])
    title('Space h')
    subplot(4,1,3)
    plot(time_h_ave);
    xlim([0 sizeInd])
    title('Time h')
    subplot(4,1,4)
    plot(com_h);
    xlim([0 sizeInd])
    title('Compression h')
    saveas(gcf,strcat(savepath,'/',trial_stamp,time_stamp,'_power_h.fig'))
end