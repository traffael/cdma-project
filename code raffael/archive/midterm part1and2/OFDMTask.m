function BER = OFDMTask(SNRdB, M, doPplot)

% Main system parameters
num_subcarriers = 256;
guard_interval = 16;

% Create channel with impulse response that is half the length of the
% cyclic prefix and normalize
h = randn(1,guard_interval/2) + 1i*randn(1,guard_interval/2);
h = h / sqrt(sum(abs(h).^2));

% Load channel estimation sequence
load channel_estimation_sequence;

% Create information bits
bits = randi([0 1], 1, 2*num_subcarriers);

% Insert training symbols
channel_estimation_sequence = [ channel_estimation_sequence channel_estimation_sequence ];
channel_estimation_bits = demapper(channel_estimation_sequence(1:ceil(num_subcarriers/M)));
bits(1:2*M:end) = channel_estimation_bits(1:2:end);
bits(2:2*M:end) = channel_estimation_bits(2:2:end);

% Modulate using 4-QAM
symbols = (2*bits(1:2:end)-1 + 1i*(2*bits(2:2:end)-1))/sqrt(2);

% Apply IFFT
tx_signal = ifft(symbols)*sqrt(num_subcarriers);

% Add cyclic prefix
tx_signal = [ tx_signal(end-guard_interval+1:end) tx_signal ];

% Send over channel
rx_signal = conv(tx_signal, h);

% Add noise
noise_var = 1/10^(SNRdB/10);
rate = 1 - 1/M;
rx_signal = rx_signal + sqrt(noise_var/(2*rate))*(randn(1, length(rx_signal)) + 1i*randn(1, length(rx_signal)));

% Remove cyclic prefix (we assume perfect synchronization)
rx_signal = rx_signal(guard_interval+1:end-length(h)+1);

% Apply FFT
rx_symbols = fft(rx_signal)/sqrt(num_subcarriers);

% Channel estimation
h_est = ...

if(doPplot)    
    real_chan_fft = fft(h, num_subcarriers);
    est_chan_fft = h_est;
    
    % Plot channel gain
    figure(2)
    plot(20*log10(abs(est_chan_fft)))
    hold on
    plot(20*log10(abs(real_chan_fft)),'r-')
    legend('Estimate', 'True Channel', 'Location', 'Best')
    title('Gain')
    drawnow
    hold off

    % Plot channel Phase
    figure(3)
    plot(angle(est_chan_fft))
    hold on
    plot(angle(real_chan_fft),'r-')
    legend('Estimate', 'True Channel', 'Location', 'Best')
    title('Phase')
    drawnow
    hold off
    pause
end

% Per-tone equalization
rx_symbols = rx_symbols ./ h_est;

% Demapping
rx_bits = demapper(rx_symbols);

% Count errors only over information bits
bits(1:2*M:end) = [];
bits(2:2*M:end) = [];
rx_bits(1:2*M:end) = [];
rx_bits(2:2*M:end) = [];
BER = mean(rx_bits' ~= bits);
