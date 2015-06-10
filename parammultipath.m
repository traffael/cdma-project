% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Multipath Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P=[];
P.NumberOfBits      = 184;


P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.codeLength = 8; % encoding (K=1+P.codeLength = 8)
P.ChannelLength = 3;
P.NumberOfFrames  = 5;
P.nMIMO = 1; %1 antenna

ESN1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

P.Long_code = zeros(256,96);
P.Long_code(:,:) = Long_code(ESN1,1);

P.Sequence(1,:) = [1 1 1 -1 -1 1 -1 ];

P.RX = 1; % Number of RX antennas

P.SNRRange = -16:2:10; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 3;
BERmultipath = simulator(P);


figure(1)
semilogy(P.SNRRange,BERmultipath,'b.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
