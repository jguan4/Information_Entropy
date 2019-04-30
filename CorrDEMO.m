clear all;
format long;

% Data file path
% path='E:\JJ Data\New Data\v_const\RawData';
% savepath='E:\JJ Data\New Data\v_const\Result_new_1';
% path='E:\JJ Data\New Data\3-20-19\Data';
% savepath='E:\JJ Data\New Data\3-20-19\Result';
% path='F:\JJ\3-20-19\small sample steady';
% savepath='F:\JJ\3-20-19\small sample steady result';

path ='J:\JJ Data\New Data\4-2-19\Data';
savepath ='J:\JJ Data\New Data\4-2-19\Result';
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
t_s_corr = [];
p_s_corr = [];
p_t_corr = [];
for m=1:mnum
    % Loading files
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'_test_s.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'_test_s.mat'));
    %     load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    
    % Get data parameters and adjust entropy
    sizeInd_time = size(time_yval,1);
    sizeInd_space = size(space_yval,1);
    ss = min(sizeInd_time,sizeInd_space);
    P = power_data(2,:);
    P_filter = filter(b,a,P);
    time_h_ave = zeros([1,sizeInd_time]);
    for i=1:size(time_yval,1)
        temp = squeeze(time_yval(i,:,:));
        time_h_ave(i) = (sum(sum(temp)))/nnz(temp);
    end
    space_yval_ave = squeeze(mean(space_yval,2));
    P_filter_cut = P_filter(n_average+1:end);
    sizeP = length(P_filter_cut);
    P_resize = resample(P_filter_cut,ss,sizeP);
    P_resize_n =( P_resize-mean(P_resize))./std(P_resize);
    space_yval_resize = resample(space_yval_ave, ss,sizeInd_space);
    space_yval_resize_n = (space_yval_resize-mean(space_yval_resize))./std(space_yval_resize);
    time_h_ave_resize = resample(time_h_ave, ss,sizeInd_time);
    time_h_ave_resize_n = (time_h_ave_resize-mean(time_h_ave_resize))./std(time_h_ave_resize);

    [t_s_c, t_s_lags] = xcov(time_h_ave_resize,space_yval_resize,'coeff');
    t_s_corr(arr_ind,:) = t_s_c;
    [M,I]=max(abs(t_s_c));
    t_s_corr_lag(arr_ind,:) = [t_s_c(I) t_s_lags(I)];
    
    [p_s_c, p_s_lags] = xcov(P_resize,space_yval_resize_n,'coeff');
    p_s_corr(arr_ind,:) = p_s_c;
    [M,I]=max(abs(p_s_c));
    p_s_corr_lag(arr_ind,:) = [p_s_c(I) p_s_lags(I)];
    
    [p_t_c, p_t_lags] = xcov(P_resize,time_h_ave_resize_n,'coeff');
    p_t_corr(arr_ind,:) = p_t_c;
    [M,I]=max(abs(p_t_c));
    p_t_corr_lag(arr_ind,:) = [ p_t_c(I) p_t_lags(I)];
    
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
    
    figure;
    subplot(3,1,1)
    plot(t_s_lags,t_s_c);
    title('Time vs. Space');
    subplot(3,1,2)
    plot(p_s_lags,p_s_c);
    title('Power vs. Space');
    subplot(3,1,3)
    plot(p_t_lags,p_t_c);
    title('Power vs. Time');
    
    
%     figure(10);
%     hold on;
%     caxis([min(P_resize_n) max(P_resize_n)]);
%     s = scatter(time_h_ave,space_yval_resize);
%     s.CData = P_resize_n;
%     colorbar;
%     title('Time vs. Space')
%     drawnow;
end

% t_s_c_mean = mean(t_s_corr,1);
% t_s_c_std = std(t_s_corr);
% p_s_c_mean = mean(p_s_corr,1);
% p_s_c_std = std(p_s_corr,1);
% p_t_c_mean = mean(p_t_corr,1);
% p_t_c_std = std(p_t_corr,1);
% figure
% errorbar(-269:269,t_s_c_mean,t_s_c_std);
% title('Time vs. Space')
% figure
% errorbar(-269:269,p_s_c_mean,p_s_c_std);
% title('Power vs. Space')
% figure
% errorbar(-269:269,p_t_c_mean,p_t_c_std);
% title('Power vs. Time')