%%% 通信原理仿真实验题
%%% 用Matlab仿真产生高斯型噪声，分析其数字特征、分布特性和功率谱密度
clear;
clc;
close all;

% 产生高斯型噪声
N = 1e4;
y = randn(1,N); % 均值为0，方差为1的高斯白噪声

figure(1);
plot(y)
xlabel("Index")
ylabel("Amplitude")
title("Gaussian noise")
set(gca,'fontsize',28)

% 数字特征
expectation = mean(y); % 期望
variance = var(y); % 方差
std_var = std(y); % 标准差

% 分布特性
[f,xi] = ksdensity(y); % 数据分布拟合PDF函数
figure(2);
plot(xi,f)
xlabel("Data")
ylabel("Probability")
title("PDF of Gaussian noise")
set(gca,'fontsize',28)

figure(3);
ecdf(y) % 数据分布拟合CDF函数
xlabel("Data")
ylabel("Probability")
title("CDF of Gaussian noise")
set(gca,'fontsize',28)

% 功率谱密度
% 维纳-辛钦定理：均值为常数的广义平稳随机过程的功率谱密度等于其自相关函数的傅里叶变换
[c,lags] = xcorr(y,'coeff'); % 归一化自相关函数，零滞后时出现最大峰值，等于sum(y.^2)/N
f = fftshift(fft(c)); % 傅里叶变换
PSD = abs(f);

figure(4);
xAxis = (0:length(f)-1)*N/length(f) - N/2;
plot(xAxis, PSD)
xlabel("f(Hz)")
ylabel("Power spectrum density")
title("PSD of Gaussian noise")
set(gca,'fontsize',28)
