clear all;
format long;

% previous paths
% path='E:\JJ Data\New Data\3-20-19\Data';
% savepath='E:\JJ Data\New Data\3-20-19\Result';
% path='D:\Documents\GMU\Research\Entropy Project\New Data\4-2-19\Data';
% savepath='D:\Documents\GMU\Research\Entropy Project\New Data\4-2-19\Result';
% path='F:\JJ\3-20-19\small sample steady';
% savepath='F:\JJ\3-20-19\small sample steady result';

% path to get raw data
path ='E:\JJ Data\5-25-data\0.55';

% path to save analysis data
savepath ='E:\JJ Data\5-25-data\0.55_Result';

% find total number of files in the folder
flist=dir(path);
mnum=size(flist,1)-2;

%% parameters
fras = 5; %interval for indentifying flickering
full = 1; %analyze full image or not toggle
%     period = 200; % period for electrical data
k=10; % average along time dimension to reduce size of pixels

for m=4:10 %file index
    % load data and grab name
    load(strcat(path,'\',flist(m+2).name),'images','power_data')
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    tic
    
    % moving average along time dimension
    images = movmean(images,k,1);
    
    % save electrical data separately
    save(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'),'power_data');
    fprintf(strcat('for calculating V, I, P of  ',flist(m+2).name,'\n'))
    clear power_data
    toc
    
    % resize image
    %     videoData = images(:,30:end,:);
    %     videoData = imresize3(videoData, [1080,256,512]);
    %     videoData = images;
    %     Vin = power_data(1,:);
    %     Iin = power_data(2,:);
    %     [Vout,Iout,P] =  vc_post_new(Vin,Iin,period);
    
    % find flickering
    %     [time_inds]=findDefect(images, fras, time_n_ahead);
    
    %space entropy calculation
    space_yval=EntDefect_space(images, full);
    save(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(full),'_transposed.mat'),'space_yval','-v7.3');
    fprintf(strcat('for calculating space h of  ',flist(m+2).name,'\n'))
    clear space_inds space_yval
    toc
    
    %time entropy calculation
    time_yval = EntDefect_time(images,full);
    save(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(full),'.mat'),'time_yval','-v7.3');
    fprintf(strcat('for calculating time h of  ',flist(m+2).name,'\n'))
    clear time_yval
    toc
    
    % send email reminder
    clear images
    SendEmail
    
    % for compression as information entropy, DISCARDED NOW
    %     com_h = compression_h(videoData,fras,space_n_ahead, space_inds, full);
    %     save(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'),'com_h');
    %     fprintf(strcat('for calculating compression h of  ',flist(m+2).name,'\n'))
    %     toc
end