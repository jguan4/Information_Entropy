clear all;
format long;

path='E:\JJ Data\New Data\v_const\RawData';
savepath='E:\JJ Data\New Data\v_const\Result_new_1';
flist=dir(path);
mnum=size(flist,1)-2;
time_n_ahead = 2;
space_n_ahead = 2;
full = 1;

a = 1;
n_average = 8000;
b = ones([1,n_average])/n_average;

for m=2:10
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    if full ==1
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
         load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    else
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_',num2str(space_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_',num2str(space_n_ahead),'_active.mat'));
    end
    sizeT = length(space_yval);
    sizeP = length(P);
     sizeInd_time = length(time_yval);
    sizeInd_space = length(space_yval);
         P_resize = resample(P,sizeT,sizeP);
    P_filter = filter(b,a,P);
     time_h_ave = squeeze(mean(mean(time_yval,2),3));
    figure
    title(strcat(trial_stamp,time_stamp, ' full=', num2str(full)))
    subplot(4,1,1)
    plot(P_filter);
    title('Power')
    subplot(4,1,2)
    plot(space_yval);
    xlim([0 sizeInd_space])
    title(strcat('Space h_', num2str(space_n_ahead),' full=', num2str(full)))
     subplot(4,1,3)
     plot(time_h_ave);
     xlim([0 sizeInd_time])
     title(strcat('Time h_', num2str(time_n_ahead)))
    subplot(4,1,4)
    plot(com_h);
    xlim([0 sizeInd_space])
    title(strcat('Compression h_', num2str(space_n_ahead),' full=', num2str(full)))
    saveas(gcf,strcat(savepath,'/',trial_stamp,time_stamp,'_power_h.fig'))
end