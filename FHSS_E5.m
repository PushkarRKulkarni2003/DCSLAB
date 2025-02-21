clc; clear all;
num_bits = 20; 
samples_per_bit = 120;
num_carriers = 6; 
samples = [10, 20, 30, 40, 60, 120]; 
bit_sequence = [0 1 1 0 0 1 0 1 0 1 1 0 0 1 0 1 0 0 1 0]; 
sequence = 2 * bit_sequence - 1;
input_signal = repelem(sequence, samples_per_bit); 

t_carrier = linspace(0, 2*pi*num_bits, samples_per_bit*num_bits); 
carrier_signal = cos(t_carrier);
figure(1);
subplot(4,1,1); plot(input_signal); 
axis([-100 2400 -1.5 1.5]);
title('Original Bit Sequence');
BPSK_mod_signal = input_signal .* carrier_signal;
subplot(4,1,2); plot(BPSK_mod_signal); 
axis([-100 2400 -1.5 1.5]);
title('BPSK Modulated Signal');

% Generate 6 Carrier Frequencies
carriers = cell(1, num_carriers);
for i = 1:num_carriers
    t = linspace(0, 2*pi, samples(i) + 1); 
    t(end) = []; 
    carriers{i} = repmat(cos(t), 1, ceil(samples_per_bit / length(t)));
    carriers{i} = carriers{i}(1:samples_per_bit); 
end
% Spread Signal with Random Carrier Frequencies
spread_signal = [];
for i = 1:num_bits
    carrier_idx = randi([1, num_carriers]); % Randomly select a carrier
    spread_signal = [spread_signal carriers{carrier_idx}];
end
subplot(4,1,3); 
plot(spread_signal); 
axis([-100 2400 -1.5 1.5]);
title('Spread Signal with 6 frequencies');
% Spreading BPSK Signal
freq_hopped_sig = BPSK_mod_signal .* spread_signal;
subplot(4,1,4); 
plot(freq_hopped_sig); 
axis([-100 2400 -1.5 1.5]);
title('Frequency Hopped Spread Spectrum Signal');
% Demodulation
BPSK_demodulated = freq_hopped_sig ./ spread_signal;
figure(2);
subplot(2,1,1); 
plot(BPSK_demodulated); 
axis([-100 2400 -1.5 1.5]);
title('Demodulated BPSK Signal from Wide Spread');
% Recover Original Bit Sequence
original_BPSK_signal = BPSK_demodulated ./ carrier_signal;
subplot(2,1,2); 
plot(original_BPSK_signal); 
axis([-100 2400 -1.5 1.5]);
title('Transmitted Original Bit Sequence');