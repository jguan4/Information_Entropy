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
% figure
% hold on
for m=1
    trial_stamp =  flist(m+2).name(1:8);
    time_stamp = flist(m+2).name(9:(length(flist(m+2).name)-4));
    load(strcat(savepath,'\',trial_stamp,time_stamp, '_VIP.mat'));
    if full ==1
        space1 = load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'_test_s_transposed.mat'));
        space_yval_1 = space1.space_yval;
        space2 = load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_vid_',num2str(space_n_ahead),'_',num2str(full),'_test_s.mat'));
        space_yval_2 = space2.space_yval;
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'_',num2str(full),'_test_s.mat'));
        %         load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_vid_',num2str(space_n_ahead),'_',num2str(full),'.mat'));
    else
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_space_h_',num2str(space_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_time_h_',num2str(time_n_ahead),'.mat'));
        load(strcat(savepath,'\',trial_stamp,time_stamp, '_com_h_',num2str(space_n_ahead),'_active.mat'));
    end
    sizeT = length(space_yval_1);
    sizeInd_time = size(time_yval,1);
    sizeInd_space = size(space_yval_1,1);
%     P_resize = resample(P,sizeT,sizeP);
    P = power_data(2,:);
    sizeP = length(P);
    P_filter = filter(b,a,P);
    P_filter = P_filter(n_average+1:end);
    time_h_ave = zeros([1,sizeInd_time]);
    for i=1:size(time_yval,1)
        temp = squeeze(time_yval(i,:,:));
        time_h_ave(i) = (sum(sum(temp)))/nnz(temp);
    end
    time_h_ave_resize = resample(time_h_ave,250,sizeInd_time);
    space_yval_ave_1 = squeeze(mean(space_yval_1,2));
    space_yval_ave_2 = squeeze(mean(space_yval_2,2));
    space_yval_ave_add = space_yval_ave_1 + space_yval_ave_2;
    space_h = space_yval_ave_add(11:end-10);
    time_h = time_h_ave_resize';
    cut_inds = 10/sizeInd_space*size(P_filter,2);
    p_cut = P_filter(cut_inds:end-cut_inds);
    p_resize = resample(p_cut, 250, size(p_cut,2));
    figure
    plot(p_resize)
    figure
    subplot(2,1,1);
    plot(time_h)
    subplot(2,1,2);
    plot(space_h)
    search_res = [];
    f = @(x) corr_inv(space_h,time_h,p_resize,x);
    xs = -5:0.25:0;
    ys = -15:0.5:15;
    for r1 = xs
        for r2 = ys
            x0 = [r1,r2]';
            search_res = [search_res;x0', f(x0)];
            
        end
    end
    plot(search_res(:,3))
%     x=broyden2(f,x0);
end

function c = corr_inv(space_h,time_h,p,x)
    hh = [space_h,time_h]*x;
    [corr, corr_t] = xcov(hh,p,'coeff');
    c = sum(abs(corr));
end