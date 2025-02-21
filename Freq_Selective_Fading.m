clc;clear all;close all;
fs = 10^6;                    % Sample rate (1 MHz)
numSamples = 10^4;          % Number of samples
dopplerShift = 10^2;          % Maximum Doppler shift (100 Hz)
numPaths = 5;                % Number of multipath components
maxDelay = 3*10^-6;             % Maximum delay spread (3 microseconds)

% Generate an impulse signal (delta function)
impulseSignal = [1; zeros(numSamples-1, 1)];  % An impulse signal
% Create a frequency-selective Rayleigh fading channel
rayleighChan = comm.RayleighChannel( ...
    'SampleRate', fs, ...
    'PathDelays', linspace(0, maxDelay, numPaths), ...  % Multipath delays
    'AveragePathGains', [-2 -3 -6 -8 -10], ...          % Path gains (dB)
    'MaximumDopplerShift', dopplerShift, ...            % Doppler shift
    'NormalizePathGains', true);
% Pass the impulse signal through the frequency-selective fading channel
rxImpulseSignal = rayleighChan(impulseSignal);
% Plot the impulse response
timeAxis = (0:numSamples-1)/fs;  % Time axis for plotting
figure;
stem(timeAxis(1:100), 20*log10(abs(rxImpulseSignal(1:100))));  % Plot first 100 samples in dB
title('Impulse Response of Frequency-Selective Rayleigh Fading Channel');
xlabel('Time (s)');
ylabel('Gain (dB)');
grid on;
% Frequency Response
N_FFT = 1024;  % FFT size for frequency response
freqResponse = fft(rxImpulseSignal, N_FFT);  % FFT of the received impulse signal
freqAxis = linspace(-fs/2, fs/2, N_FFT);  % Frequency axis
% Plot the frequency response
figure;
plot(freqAxis/fs, 20*log10(abs(fftshift(freqResponse))));  % Shift zero frequency to center
title('Frequency Response of Frequency-Selective Rayleigh Fading Channel');
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
grid on;