% Wireless Receivers II - Assignment 1:
%
% AWGN Parameter Example File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
clear;
P.NumberOfBits      = 184;
P.CoherenceTime       = 100;
P.CodingType    = 'None';
P.Modulation    = 1;      % 1: BPSK
P.ChannelType   = 'AWGN'; % 'AWGN', 'Fading'
P.ReceiverType  = 'Simple';

P.RX = 1; % Number of RX antennas

P.Sequence = [1]; % chip sequence
P.NumberOfChip = numel(P.Sequence);

P.SNRRange =    -15:15; % SNR Range to simulate in dB

BER = simulator(P);

figure(1)
semilogy(P.SNRRange,BER)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
