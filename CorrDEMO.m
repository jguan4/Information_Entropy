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

for m=2:10
    % Loading files
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'.mat'));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    
    % Get data parameters and adjust entropy
    sizeT = length(space_yval);
    sizeP = length(P);
    sizeInd_time = length(time_yval);
    sizeInd_space = length(space_yval);
    time_h_ave = squeeze(mean(mean(time_yval,2),3));
    %     P_resize = resample(P,sizeT,sizeP);
    P_filter = filter(b,a,P);
    
    [t_s_c, t_s_lags] = xcov(space_yval,time_h_ave,'coeff');
    figure;
    plot(t_s_lags,t_s_c);
    title('Space vs. Time');
end