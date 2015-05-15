% Wireless Receivers II - Assignment 2:
%
% Fading CDMA Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

clear all

% Parameters
P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000;

P.AccessType = 'CDMA';
P.CDMAUsers     = 1;

P.Modulation    = 1;        % 1: BPSK

P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'


P.HamLen = 8; % Length of Hadamard Sequence

P.SNRRange = -10:20; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

u=[1 4 8];
c=[2 3 4];
for k=1:3
    for l=1:3
        l
        P.CDMAUsers     = u(l);
        P.ChannelLength = c(k);
        
        BER(l,:) = simulator(P);
        
        simlab(l,:) = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.CDMAUsers);
    end

figure
semilogy(P.SNRRange,BER,'*-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1e-4, 1e0]);

grid minor;
legend(simlab);

end
