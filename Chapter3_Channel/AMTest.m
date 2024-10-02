t = 0:0.1:10*2*pi;
mt = sin(t/10);
figure;
plot(mt)

fc = 2e6;
zaiBo = cos(fc*t);
figure;
plot(mt.*zaiBo)