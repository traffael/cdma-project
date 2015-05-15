% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Multipath Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 1000;
P.NumberOfSymbols     = 1000;

P.CoherenceTime       = 100;

P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 3;

P.RX = 1; % Number of RX antennas

P.Sequence = [1 1 1 -1 -1 1 -1 ]; 

P.SNRRange = -20:20; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 2;
P.Sequence =  [1 1 1 1 -1 1 -1];
BER1 = simulator(P);

P.Sequence =  [1 1 1 1 1 1 -1];
BER2 = simulator(P);

P.Sequence =  [-1 -1 -1 1 1 1 1];
BER3 = simulator(P);


%P.RakeFingers = 1;
%BER1 = simulator(P);

%P.RakeFingers = 2;
%BER2 = simulator(P);

%P.RakeFingers = 3;
%BER3 = simulator(P);

figure(1)
semilogy(P.SNRRange,BER1,'b.-')
hold on
semilogy(P.SNRRange,BER2,'r.-')
semilogy(P.SNRRange,BER3,'g.-')


xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
legend('Rake 1 Finger/Correlator','Rake 2 Fingers','Rake 3 Fingers');
