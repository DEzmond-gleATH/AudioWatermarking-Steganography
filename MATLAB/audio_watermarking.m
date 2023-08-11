clc;
clear;
close all;
%[host, f] = audioread('Laughter-16-8-mono-4secs.wav');
[host, f] = audioread('hello3.wav');
dt=1/f;
t =0:dt:(length(host)*dt)-dt;

subplot(2,1,1)
plot(t,host)
title('Original Audio')

host = uint8(128*(host + 1));
%wm = imread('image.jpeg');
wm = imread('hulk.JPG');
wm=rgb2gray(wm);

[r, c] = size(wm);
wm_l = length(wm(:))*8;

if length(host) < wm_l 
    disp('your audio file is not long enough')
    %or chang 
else
    host_bin = dec2bin(host, 8);
    new_host_bin=dec2bin(host, 8);
    wm_bin = dec2bin(wm(:), 8);
    wm_str=zeros(wm_l,1);
    for j = 1:length(wm(:))
        for i = 1:8
            ind = (j-1)*8 + i;
            wm_str(ind) = str2double(wm_bin(j, i));
        end
    end
    for i = 1:wm_l
        host_bin(i, 8) = dec2bin(wm_str(i));
    end
    host_n = bin2dec(host_bin);
    host_new = 2*(double(host_n)/255 - 0.5);

    subplot(2,1,2)
    plot(t,host_new)
    title('Watermarked Audio')
    figure;
    
    audiowrite('host_new.wav',host_new, f);
    soundsc(host_new, f);
end
%% recovery of image from Watermarked audio %%
subplot(3,1,1)
imshow(wm);
title('Original img')

wmr = dec2bin((host_new/2 + 0.5)*255);
wmr_str = zeros(wm_l,1);
for i = 1:wm_l
    wmr_str(i)=bin2dec(wmr(i,8));
end
wmr_img=dec2bin(zeros(length(wm(:)),1),8);
for j = 1:length(wm(:))
    for i = 1:8
        ind = (j-1)*8 + i;
        wmr_img(j, i) = dec2bin(wmr_str(ind));
    end
end
wmr_img = bin2dec(wmr_img);

wmr_final=zeros(r,c);
for j = 1:c
    for i = 1:r
        ind = (j-1)*r + i;
        wmr_final(i, j) = wmr_img(ind,1);
    end
end
subplot(3,1,2)
imshow(uint8(wmr_final));
title('img recovered from watermarked audio using lsb')
%% recovery of an image from original audio
wmn = new_host_bin;
wmn_str = zeros(wm_l,1);
for i = 1:wm_l
    wmn_str(i)=bin2dec(wmn(i,8));
end
wmn_img=dec2bin(zeros(length(wm(:)),1),8);
for j = 1:length(wm(:))
    for i = 1:8
        ind = (j-1)*8 + i;
        wmn_img(j, i) = dec2bin(wmn_str(ind,1));
    end
end
wmn_img = bin2dec(wmn_img);

wmn_final=zeros(r,c);
for j = 1:c
    for i = 1:r
        ind = (j-1)*r + i;
        wmn_final(i, j) = wmn_img(ind,1);
    end
end
subplot(3,1,3)
imshow(uint8(wmn_final));
title('img recovered from original audio using lsb')