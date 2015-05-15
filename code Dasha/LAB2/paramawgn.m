% Wireless Receivers II - Assignment 2:
%
% AWGN CDMA Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
%clear;

P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000;

P.AccessType = 'CDMA';

P.Modulation    = 1;        % 1: BPSK

P.ChannelType   = 'AWGN'; % 'AWGN', 'Fading'
P.ChannelLength = 1;
P.HamLen = 8; % Length of Hadamard Sequence
P.SNRRange = -20:20; % SNR Range to simulate in dB
P.Channel_numb = 8;
P.ReceiverType  = 'Rake';
P.Fingers = 1;


P.CDMAUsers     = 1;
BER1 = simulator_2(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
figure(1)
semilogy(P.SNRRange,BER1,'ro-','DisplayName',simlab)
hold on

P.CDMAUsers     = 2;
BER2 = simulator(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER2,'bo-','DisplayName',simlab)

P.CDMAUsers     = 4;
BER4 = simulator(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER3,'yo-','DisplayName',simlab)

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid minor;
legend('-DynamicLegend');