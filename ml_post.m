function [amp, phase] = ml_post(signal,ml_period)
%% with the below parameters, valid only for the variac data!!!!!!!!
%run on the craw and vraw data to remove the driving current, and estimate
%the instantaneous response. This essentially low pass filters the data
%too!
% jhp
ml_sigma = 20000; %wavelet width. Bigger means more precision, but less speed.
ml_len = 1000;% %wavelet length. Should likely be set from above, but it's here
%ml_period = 167; %=60Hz%1khz=1000;
x = 1:ml_len;
ml = exp(-(x-(ml_len/2)).^2/(2*ml_sigma)).*exp(1i*2*pi*x/ml_period);
amp = conv(signal,ml,'valid');
phase = atand(real(amp)./imag(amp));
amp = abs(amp)*2/sum(abs(ml));
return
