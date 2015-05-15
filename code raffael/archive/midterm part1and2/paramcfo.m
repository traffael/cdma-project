% Wireless Receivers II - Assignment 2:
%
% CFO Parameter Example File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 1000;
P.NumberOfSymbols     = 1000;

P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Multipath';   % 'AWGN', 'Multipath'
P.ChannelLength = 3;
P.F_c           = 2.5E9; % Carrier frequency 2.5GHz
P.F_s           = 40E6;  % Sampling frequency/Chip rate 40MHz
P.OscPPM        = 20; % max combined Osc offset
P.CFOffset      = P.OscPPM/1E6*P.F_c/P.F_s; % carrier frequency offset defined f_offset/f_samplingrate
P.ReceiverType  = 'Rake';
P.RakeFingers   = 3; 

P.Sequence = [ 1 1 1 -1 -1 1 -1 ]; % chip sequence
P.Preamble = [ -1 repmat([1 1 -1 -1 -1 1 1 -1],1,8) ] ;

P.CFOcorrect = 'no';

P.SNRRange = -15:30; % SNR Range to simulate in dB

BER = simulator(P);

figure(2)
semilogy(P.SNRRange,BER)
xlabel('SNR [dB]','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1E-5 1]);
grid on;