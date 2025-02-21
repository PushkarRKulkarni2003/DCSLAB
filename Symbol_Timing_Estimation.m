clc; clear all; close all;
L        = 4;         % Oversampling factor
beta  = 0.5;       % Pulse shaping roll-off factor
rcDelay  = 10;  
htx = rcosdesign(beta, 6, 4); %root raised cosine coeff
hrx  = conj(fliplr(htx));
M = 2; 

data = zeros(1, 2*rcDelay);
data(1:2:end) = 1;
txSym = real(pammod(data, M));
txUpSequence = upsample(txSym, L); % X000X000...
txSequence = filter(htx, 1, txUpSequence);

timeOffset = 1; %delay
rxDelayed = [zeros(1, timeOffset), txSequence(1:end-timeOffset)];
mfOutput = filter(hrx, 1, rxDelayed);
rxSym = downsample(mfOutput, L);

% scatter plot
figure
plot(complex(rxSym(rcDelay+1:end)), 'o')
grid on
title('Rx Scatterplot')
xlabel('In-phase (I)')
ylabel('Quadrature (Q)')
figure
stem(rxSym)
title('Symbol Sequence with delay')
xlabel('Symbol Index')
ylabel('Amplitude')

%Symbol timing recovery
rxSym = downsample(mfOutput, L, timeOffset);
figure
plot(complex(rxSym(rcDelay+1:end)), 'o')
grid on
title('Rx Scatterplot')
xlabel('In-phase (I)')
ylabel('Quadrature (Q)')
figure
stem(rxSym)
title('Symbol Sequence without delay')
xlabel('Symbol Index')
ylabel('Amplitude')