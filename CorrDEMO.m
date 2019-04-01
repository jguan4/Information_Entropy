clear all;
format long;

% Data file path
% path='E:\JJ Data\New Data\v_const\RawData';
% savepath='E:\JJ Data\New Data\v_const\Result_new_1';
path='E:\JJ Data\New Data\1_24_19\RawData';
savepath='E:\JJ Data\New Data\1_24_19\Result';
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

for m=1:6
    % Loading files
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'_new.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'_new2.mat'));
    %     load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    
    % Get data parameters and adjust entropy
    sizeT = length(space_yval);
    sizeInd_time = size(time_yval,1);
    sizeInd_space = size(space_yval,1);
    %     P_resize = resample(P,sizeT,sizeP);
    P_filter = filter(b,a,P);
    time_h_ave = [];
    for i=1:size(time_yval,1)
        temp = squeeze(time_yval(i,:,:));
        time_h_ave(i) = (sum(sum(temp)))/nnz(temp);
    end
    space_yval_ave = squeeze(mean(space_yval,2));
    P_filter_cut = P_filter(n_average+1:end);
    sizeP = length(P_filter_cut);
    P_resize = resample(P_filter_cut,sizeInd_time,sizeP);
    space_yval_resize = resample(space_yval_ave, sizeInd_time,sizeInd_space);
    
    space_yval_resize_n = (space_yval_resize-mean(space_yval_resize))./std(space_yval_resize);
    time_h_ave_n = (time_h_ave-mean(time_h_ave))./std(time_h_ave);
    P_resize_n =( P_resize-mean(P_resize))./std(P_resize);
    
    [t_s_c, t_s_lags] = xcov(time_h_ave,space_yval_resize,'coeff');
    t_s_corr(arr_ind,:) = t_s_c;
    [M,I]=max(abs(t_s_c));
    t_s_corr_lag(arr_ind,:) = [t_s_c(I) t_s_lags(I)];
    
%     [p_s_c, p_s_lags] = xcov(P_resize(2:end),space_yval_resize_n,'coeff');
%     [M,I]=max(abs(p_s_c));
%     p_s_corr_lag(arr_ind,:) = [p_s_c(I) p_s_lags(I)];
%     
%     [p_t_c, p_t_lags] = xcov(P_resize(2:end),time_h_ave_n,'coeff');
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
    
%     figure;
%     subplot(3,1,1)
%     plot(t_s_lags,t_s_c);
%     title('Time vs. Space');
%     subplot(3,1,2)
%     plot(p_s_lags,p_s_c);
%     title('Power vs. Space');
%     subplot(3,1,3)
%     plot(p_t_lags,p_t_c);
%     title('Power vs. Time');
    
%     
%     figure(10);
%     hold on;
%     caxis([min(P_resize_n) max(P_resize_n)]);
%     s = scatter(time_h_ave,space_yval_resize);
%     s.CData = P_resize_n;
%     colorbar;
%     title('Time vs. Space')
%     drawnow;
end