% Wireless Receivers II - Assignment 2:
%
% AWGN CDMA Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000;

P.AccessType = 'CDMA';
P.CDMAUsers     = 1;

P.Modulation    = 1;        % 1: BPSK

P.ChannelType   = 'AWGN'; % 'AWGN', 'Fading'
P.ChannelLength = 1;

P.HamLen = 8; % Length of Hadamard Sequence

P.SNRRange = -10:20; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

BER = simulator(P);

figure(1)
simlab = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
semilogy(P.SNRRange,BER,'ro-','DisplayName',simlab)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid minor;

hold on


P.CDMAUsers = 2;
BER = simulator(P);

simlab1 = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);

semilogy(P.SNRRange,BER,'bo-','DisplayName',simlab1)


P.CDMAUsers = 4;
BER = simulator(P);

simlab2 = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);

semilogy(P.SNRRange,BER,'go-','DisplayName',simlab2)

hold off;

legend('-DynamicLegend');