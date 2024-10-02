%%% 通信原理仿真实验题
%%% 用Matlab仿真产生一个瑞利衰落仿真器，它有3个独立的瑞利衰落多径分量，且每个分量有可变的多径时延和平均功率。
%%% 将一随机二进制序列通过仿真器，试观测输出数据序列的时间波形。改变数据传输速率和信道时延，试观测多径扩展产生的影响
clear;
clc;
close all;

% 生成随机二进制序列
dataLen = 10;
x = randi(2,1,dataLen)-1; % 1 x 100
figure(1);
stem(x) % 针头图
title("输入信号序列波形")
set(gca,'fontsize',28)

% 瑞利衰落信道
h = rayleighSimulator(4);

% 输出信号
y = conv(x,h);
output = y(1:dataLen); % 只取前dataLen是因为过了之后直射径就不参与卷积运算了
output = abs(output);

figure(2);
stem(output)
title("输出信号序列波形")
set(gca,'fontsize',28)

%% temporary function
function h = rayleighSimulator(numH)

% 参数初始化
% 时延
delay = [0 randi(10,1,numH-1)]; % 时延可变，1-10
delay = sort(delay); % 升序排列
D_h = delay(end) + 1; % 最后一条信道到达时间

% 各信道平均功率
P_hdB = [0 -8 -17 -21]; % dB
P_h = 10.^(P_hdB ./ 10); % w

% 生成瑞利衰落信道仿真器
Amp_h = sqrt(P_h)./2 .* (randn(1,numH)+1j*randn(1,numH));
h = zeros(1,D_h);
h(:,delay+1) = Amp_h;

end
