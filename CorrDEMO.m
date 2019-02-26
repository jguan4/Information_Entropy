clear all;
format long;

% Data file path
path='E:\JJ Data\New Data\v_const\RawData';
savepath='E:\JJ Data\New Data\v_const\Result_new_1';
flist=dir(path);
mnum=size(flist,1)-2;

% Data file parameter
time_n_ahead = 2;
space_n_ahead = 2;
full = 1;

% Power filter parameter
a = 1;
n_average = 8000;
b = ones([1,n_average])/n_average;

arr_ind = 1;
t_s_corr_lag = [];
p_s_corr_lag = [];
p_t_corr_lag = [];

for m=2:10
    % Loading files
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    
    % Get data parameters and adjust entropy
    sizeInd_time = length(time_yval);
    sizeInd_space = length(space_yval);
    time_h_ave = squeeze(mean(mean(time_yval,2),3));
    P_filter = filter(b,a,P);
    P_filter_cut = P_filter(n_average+1:end);
    sizeP = length(P_filter_cut);
    P_resize = resample(P_filter_cut,sizeInd_time,sizeP);
    space_yval_resize = resample(space_yval, sizeInd_time,sizeInd_space);
    
    space_yval_resize_n = (space_yval_resize-mean(space_yval_resize))./std(space_yval_resize);
    time_h_ave_n = (time_h_ave-mean(time_h_ave))./std(time_h_ave);
    P_resize_n =( P_resize-mean(P_resize))./std(P_resize);
    
%     [t_s_c, t_s_lags] = xcov(time_h_ave,space_yval_resize,'coeff');
%     [M,I]=max(abs(t_s_c));
%     t_s_corr_lag(arr_ind,:) = [t_s_c(I) t_s_lags(I)];
%     
%     [p_s_c, p_s_lags] = xcov(P_resize,space_yval_resize,'coeff');
%     [M,I]=max(abs(p_s_c));
%     p_s_corr_lag(arr_ind,:) = [p_s_c(I) p_s_lags(I)];
%     
%     [p_t_c, p_t_lags] = xcov(P_resize,time_h_ave,'coeff');
%     [M,I]=max(abs(p_t_c));
%     p_t_corr_lag(arr_ind,:) = [ p_t_c(I) p_t_lags(I)];

    arr_ind = arr_ind + 1;
    
%     figure;
%     subplot(3,1,1)
%     plot3(1:sizeInd_time,time_h_ave_n,space_yval_resize_n);
%     title('Time vs. Space');
%     subplot(3,1,2)
%     plot3(1:sizeInd_time,P_resize_n,space_yval_resize_n)
%     title('Power vs. Space');
%     subplot(3,1,3)
%     plot3(1:sizeInd_time,P_resize_n,time_h_ave_n);
%     title('Power vs. Time');
%     drawnow;

%     plot(t_s_lags,t_s_c);
%     title('Time vs. Space');
%     subplot(3,1,2)
%     plot(p_s_lags,p_s_c);
%     title('Power vs. Space');
%     subplot(3,1,3)
%     plot(p_t_lags,p_t_c);
%     title('Power vs. Time');


    figure(10);
    hold on;
    caxis([min(P_resize_n) max(P_resize_n)]);
    s = scatter(time_h_ave,space_yval_resize);
    s.CData = P_resize_n;
    colorbar;
    title('Time vs. Space')
    drawnow;
end