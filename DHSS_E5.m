clc; clear all; close all;
Fs = 1000;
fc = 100;
fp = 4;
bit_t = 0.1;
m = [0 0 1 1 1 1 0 0];
m = 2 * m-1;
message = repmat(m,1,fp); 

pn_code = randi([0,1],1,length(message));
pn_code = 2*pn_code - 1;
DS = message.*pn_code;
t = 0:1/Fs:(bit_t-1/Fs);
s0 = -1*cos(2*pi*fc*t);
s1 = cos(2*pi*fc*t);
carrier = [];
BPSK = [];
for i = 1:length(DS)
if (DS(i) == 1)
    BPSK = [BPSK s1];
elseif (DS(i) == -1)
    BPSK = [BPSK s0];
end
    carrier = [carrier s1];
end
%% demodulation
rx =[];
for i = 1:length(pn_code)
if(pn_code(i)==1)
    rx = [rx BPSK((((i-1)*length(t))+1):i*length(t))];
else
    rx = [rx (-1)*BPSK((((i-1)*length(t))+1):i*length(t))];
end
end
demod = rx.*carrier;

result = [];
for i = 1:length(m)
x = length(t)*fp;
cx = sum(carrier(((i-1)*x)+1:i*x).*demod(((i-1)*x)+1:i*x));

if(cx>0)
    result = [result 1];
else
    result = [result -1];
end
end

%%
pn_codeWrong = randi([0,1],1,length(m)*fp);
resultWrong = [];
rx2 =[];
for i = 1:length(pn_codeWrong)
if(pn_codeWrong(i)==1)
    rx2 = [rx2 BPSK((((i-1)*length(t))+1):i*length(t))];
else
    rx2 = [rx2 (-1)*BPSK((((i-1)*length(t))+1):i*length(t))];
end
end
demod2 = rx2.*carrier;
for i = 1:length(m)
x = length(t)*fp;
cx = sum(carrier(((i-1)*x)+1:i*x).*demod2(((i-1)*x)+1:i*x));
if(cx>0)
    resultWrong = [resultWrong 1];
else
    resultWrong = [resultWrong -1];
end
end
%% 
message1 = repelem (result,fp);
message2 = repelem (resultWrong,fp);
%% Draw original message, PN code , encoded sequence on time domain
tm = 0:bit_t/fp:length(m)*bit_t-bit_t/fp;
figure
subplot(311)
stairs(tm,message,'linewidth',2)
title('Message bit sequence')
axis([0 length(m)*bit_t -1 1]);
subplot(312)
stairs(tm,pn_code,'linewidth',2)
title('Pseudo-random code');
axis([0 length(m)*bit_t -1 1]);
subplot(313)
stairs(tm,DS,'linewidth',2)
title('Modulated signal');
axis([0 length(m)*bit_t -1 1]);
figure
subplot(311)
stairs(tm,message,'linewidth',2)
title('Message bit sequence')
axis([0 length(m)*bit_t -1 1]);
subplot(312)
stairs(tm,message1,'linewidth',2)
title('Received message using true pseudo-random code')
axis([0 length(m)*bit_t -1 1]);
subplot(313)
stairs(tm,message2,'linewidth',2)
title('Received message using wrong pseudo-random code')
axis([0 length(m)*bit_t -1 1]);

N_FFT=1024
f = linspace(-Fs/2,Fs/2,N_FFT);
figure
subplot(311)
plot(f,abs(fftshift(fft(message,N_FFT))),'linewidth',2);
title('Message spectrum')
subplot(312)
plot(f,abs(fftshift(fft(pn_code,N_FFT))),'linewidth',2);
title('Pseudo-random code spectrum');
subplot(313)
plot(f,abs(fftshift(fft(DS,N_FFT))),'linewidth',2);
title('Modulated signal spectrum');
figure;
subplot(311)
plot(f,abs(fftshift(fft(BPSK,N_FFT))),'linewidth',2);
title('Transmitted signal spectrum');
subplot(312)
plot(f,abs(fftshift(fft(rx,N_FFT))),'linewidth',2);
title('Received signal multiplied by pseudo code');
subplot(313)
plot(f,abs(fftshift(fft(demod,N_FFT))),'linewidth',2);
title('Demodulated signal spectrum before decision device ');