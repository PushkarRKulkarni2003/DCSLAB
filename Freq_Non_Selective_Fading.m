clc;clear all;close all
fs = 10^6;                   % Sample rate (1 MHz)
numSamples = 10^4;         % Number of samples
maxDopplerShift = 10^2;      % Maximum Doppler shift (100 Hz)

txSignal = (randn(numSamples, 1) + 1j*randn(numSamples, 1));  % Complex Gaussian signal
rayleighChan = comm.RayleighChannel( ...
    'SampleRate', fs, ...
    'MaximumDopplerShift', maxDopplerShift, ... % Doppler shift
    'NormalizePathGains', true);                % Normalize path gains

rxSignal = rayleighChan(txSignal);
figure;
subplot(2, 1, 1);
plot(real(txSignal(1:100)), 'b-o');
hold on;
plot(imag(txSignal(1:100)), 'r-x');
title('Transmitted Signal (First 100 Samples)');
xlabel('Sample Index');
ylabel('Amplitude');
legend('Real Part', 'Imaginary Part');
grid on;
subplot(2, 1, 2);
plot(real(rxSignal(1:100)), 'b-o');
hold on;
plot(imag(rxSignal(1:100)), 'r-x');
title('Received Signal through Flat Rayleigh Fading Channel (First 100 Samples)');
xlabel('Sample Index');
ylabel('Amplitude');
legend('Real Part', 'Imaginary Part');
grid on;
figure;
pwelch(txSignal, [], [], [], fs, 'centered');
hold on;
pwelch(rxSignal, [], [], [], fs, 'centered');
title('Power Spectral Density (PSD) of Transmitted and Received Signals');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
legend('Transmitted Signal', 'Received Signal');
grid on;