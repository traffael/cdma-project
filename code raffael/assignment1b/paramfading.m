% Wireless Receivers II - Assignment 2:
%
% Fading CDMA Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

clear all;


% Parameters
P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000;

P.AccessType = 'CDMA';

P.Modulation    = 1;        % 1: BPSK

P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 1;

P.HamLen = 8; % Length of Hadamard Sequence

P.SNRRange = -10:20; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';


u=[1 2 4 8];
for i=1:4
    
    i
    P.CDMAUsers     = u(i);

    BER(i,:) = simulator(P);

    simlab(i,:) = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);

    
end

semilogy(P.SNRRange,BER,'*-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid minor;
legend(simlab);
