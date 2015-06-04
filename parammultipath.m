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
P.ChannelLength = 4;
P.NumberOfFrames  = 50;
P.Long_code = Long_code();
P.Sequence = [1 1 1 -1 -1 1 -1 ];

P.RX = 1; % Number of RX antennas

P.SNRRange = -16:2:10; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 4;
BER1 = simulator(P);


figure(1)
semilogy(P.SNRRange,BER1,'b.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
