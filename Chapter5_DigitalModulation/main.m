clc;
clear;
close all

% 1) 码型波形生成
% codeLen = 1000;
% generateCode(codeLen);

% 2）初始化
codeType = ["unipolar_nrz","unipolar_rz","polar_nrz","polar_rz","Manchester_code"];

load("binarySequence.mat",'b');
type = codeType(1);
Rb = 1000; % bit/s
time = 1e-4:1e-4:1; % s
wave = wave_gen(b,type,Rb,time);

% 3）plot
% figure;
% plot(time,wave)
% xlabel("t(s)")
% set(gca,'fontsize',28)

% 4）功率谱密度
Nx = length(wave);
nsc = floor(Nx/4.5);
nov = floor(nsc/2);
nfft = max(256,2^nextpow2(nsc));
fs = 2*Rb;
[pxx,f] = pwelch(wave,hamming(nsc),nov,nfft,fs);
% pxx = pxx * fs/2;
% pxx(1) = pxx(1)*2;
% pxx(length(pxx)) = pxx(length(pxx))*2;


