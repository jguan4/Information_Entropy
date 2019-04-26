clear all;
format long;

% path='E:\JJ Data\New Data\v_const\RawData';
% savepath='E:\JJ Data\New Data\v_const\Result_new_1';
% path='E:\JJ Data\New Data\1_24_19\RawData';
% savepath='E:\JJ Data\New Data\1_24_19\Result';
% path='F:\JJ\3-20-19\small sample steady';
% savepath='F:\JJ\3-20-19\small sample steady result';

path ='J:\JJ Data\New Data\4-2-19\Data';
savepath ='J:\JJ Data\New Data\4-2-19\Result';
flist=dir(path);
mnum=size(flist,1)-2;
time_n_ahead = 2;
space_n_ahead = 2;
full = 1;

a = 1;
n_average = 8000;
b = ones([1,n_average])/n_average;

for m=1:mnum
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    if full ==1
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'_test.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'_test.mat'));
        %         load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    else
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_',num2str(space_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_',num2str(space_n_ahead),'_active.mat'));
    end
    sizeT = length(space_yval);
    
    sizeInd_time = size(time_yval,1);
    sizeInd_space = size(space_yval,1);
%     P_resize = resample(P,sizeT,sizeP);
    P = power_data(2,:);
    sizeP = length(P);
    P_filter = filter(b,a,P);
    time_h_ave = zeros([1,sizeInd_time]);
    for i=1:size(time_yval,1)
        temp = squeeze(time_yval(i,:,:));
        time_h_ave(i) = (sum(sum(temp)))/nnz(temp);
    end
    space_yval_ave = squeeze(mean(space_yval,2));
    figure
    title(strcat(trial_stamp,time_stamp, ' full=', num2str(full)))
    subplot(3,1,1)
    plot(P_filter(n_average+1:end));
    title('Voltage')
    subplot(3,1,2)
    plot(space_yval_ave);
    xlim([0 sizeInd_space])
    title(strcat('Space h_', num2str(space_n_ahead),' full=', num2str(full)))
    subplot(3,1,3)
    plot(time_h_ave);
    xlim([0 sizeInd_time])
    title(strcat('Time h_', num2str(time_n_ahead)))
    %     subplot(4,1,4)
    %     plot(com_h);
    %     xlim([0 sizeInd_space])
    %     title(strcat('Compression h_', num2str(space_n_ahead),' full=', num2str(full)))
    drawnow;
    %     saveas(gcf,strcat(savepath,'/',trial_stamp,time_stamp,'_power_h.fig'))
end