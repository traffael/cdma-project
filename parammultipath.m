% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Multipath Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfBits      = 184;


P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 3;

P.RX = 1; % Number of RX antennas

P.SNRRange = -20:20; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 2;
BER1 = simulator(P);


figure(1)
semilogy(P.SNRRange,BER1,'b.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
