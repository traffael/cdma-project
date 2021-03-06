% Wireless Receivers II - Assignment 2:
%
% Fading CDMA Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000;

P.AccessType = 'CDMA';
P.CDMAUsers     = 1;

P.Modulation    = 1;        % 1: BPSK

P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 1;

P.HamLen = 8; % Length of Hadamard Sequence

P.SNRRange = -10:30; % SNR Range to simulate in dB
P.Fingers = 4;
P.ReceiverType  = 'Rake';

P.CDMAUsers     = 1;
BER = simulatorrr(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
figure(2)
semilogy(P.SNRRange,BER,'b*-','DisplayName',simlab)

hold on

P.CDMAUsers     = 2;
BER2 = simulator(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER2,'g*-','DisplayName',simlab)

P.CDMAUsers     = 4;
BER4 = simulator(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER4,'r*-','DisplayName',simlab)

P.CDMAUsers     = 8;
BER8 = simulator(P);
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER8,'y*-','DisplayName',simlab)

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid minor;
legend('-DynamicLegend');