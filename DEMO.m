clear all;
format long;

path='E:\JJ Data\New Data\v_const\RawData';
savepath='E:\JJ Data\New Data\v_const\Result';
flist=dir(path);
mnum=size(flist,1)-2;

for m=1:mnum
    load(strcat(path,'\',flist(m+2).name))
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    videoData = images;
    Vin = power_data(1,:);
    Iin = power_data(2,:);
    period = 167;
    fras = 5;
    n_ahead = 1;
%     [inds]=findDefect(videoData, fras, n_ahead);
    tic
%     [Vout,Iout,P] =  vc_post_new(Vin,Iin,period);
%     save(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP_',num2str(n_ahead),'.mat'),'Vout','Iout','P');
%     fprintf(strcat('for calculating V, I, P of  ',flist(m+2).name,'\n'))
%     toc
%     space_yval=EntDefect_space(videoData,fras,inds);
%     save(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_',num2str(n_ahead),'.mat'),'space_yval');
%     fprintf(strcat('for calculating space h of  ',flist(m+2).name,'\n'))
%     toc
%     time_yval = EntDefect_time(videoData,fras,inds);
%     save(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(n_ahead),'.mat'),'time_yval');
%     fprintf(strcat('for calculating time h of  ',flist(m+2).name,'\n'))
%     toc
    com_h = compression_h(videoData,fras,n_ahead);
    save(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_',num2str(n_ahead),'.mat'),'com_h');
    fprintf(strcat('for calculating compression h of  ',flist(m+2).name,'\n'))
    toc
end